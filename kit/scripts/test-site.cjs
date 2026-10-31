// Kit-only test: Playwright checks on the site (AC17-AC20).
// Needs Playwright + Chromium installed locally (NODE_PATH resolves `playwright`).
// Run: node kit/scripts/test-site.cjs
const http = require('http');
const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

const SITE = path.resolve(__dirname, '..', '..', 'site');
const TYPES = { '.html': 'text/html', '.css': 'text/css', '.js': 'text/javascript', '.svg': 'image/svg+xml', '.json': 'application/json' };
let failed = false;
const pass = (n) => console.log('PASS ' + n);
const fail = (n, why) => { console.log('FAIL ' + n + ': ' + why); failed = true; };

function serve() {
  return new Promise((resolve) => {
    const s = http.createServer((req, res) => {
      let p = decodeURIComponent(req.url.split('?')[0].split('#')[0]);
      if (p.endsWith('/')) p += 'index.html';
      const f = path.join(SITE, path.normalize(p));
      if (!f.startsWith(SITE) || !fs.existsSync(f) || fs.statSync(f).isDirectory()) { res.writeHead(404); return res.end('nf'); }
      res.writeHead(200, { 'content-type': TYPES[path.extname(f)] || 'application/octet-stream' });
      fs.createReadStream(f).pipe(res);
    });
    s.listen(0, '127.0.0.1', () => resolve(s));
  });
}

async function test(name, fn) {
  try { const why = await fn(); why ? fail(name, why) : pass(name); }
  catch (e) { fail(name, e && e.message ? e.message.split('\n')[0] : String(e)); }
}

(async () => {
  const server = await serve();
  const origin = 'http://127.0.0.1:' + server.address().port;
  const browser = await chromium.launch({ headless: true });
  try {
    const KIT_ROWS = ['kit/', '.github/workflows/release.yml'];

    await test('AC17 files table lists kit/ and release.yml as delete (screens on/off)', async () => {
      const page = await browser.newPage();
      await page.goto(origin + '/playground.html#setup');
      for (const on of [true, false]) {
        await page.locator('#su-ui').setChecked(on);
        const rows = await page.$$eval('#su-files tr', (trs) => trs.map((tr) => [...tr.children].map((c) => c.textContent.trim())));
        for (const want of ['site/', '.github/workflows/pages.yml', ...KIT_ROWS]) {
          const row = rows.find((r) => r[0] === want);
          if (!row) return `screens ${on}: no row '${want}'`;
          if (row[1] !== 'delete') return `screens ${on}: row '${want}' is '${row[1]}', expected delete`;
        }
      }
      await page.close();
    });

    await test('AC18 git rm line includes all kit-only paths (screens on/off)', async () => {
      const page = await browser.newPage();
      await page.goto(origin + '/playground.html#setup');
      for (const on of [true, false]) {
        await page.locator('#su-ui').setChecked(on);
        const first = (await page.locator('#su-cmd > div').first().textContent()).trim();
        const toks = first.split(/\s+/);
        for (const p of ['site', 'kit', '.github/workflows/pages.yml', '.github/workflows/release.yml']) {
          if (!toks.includes(p)) return `screens ${on}: git rm line lacks '${p}': ${first}`;
        }
        if (toks.includes('DESIGN.md') !== !on) return `screens ${on}: DESIGN.md presence wrong: ${first}`;
      }
      await page.close();
    });

    await test('AC19 no horizontal overflow or console errors at 375px (light, dark, old saved state)', async () => {
      const old = '{"ui":true,"deploy":true,"data":true,"done":{"repo":true,"delete":true}}';
      for (const [scheme, seed] of [['light', false], ['dark', false], ['light', true]]) {
        const ctx = await browser.newContext({ viewport: { width: 375, height: 812 }, colorScheme: scheme });
        const page = await ctx.newPage();
        const errs = [];
        page.on('console', (m) => { if (m.type() === 'error') errs.push(m.text()); });
        page.on('pageerror', (e) => errs.push(String(e)));
        if (seed) await page.addInitScript((v) => { try { localStorage.setItem('psk:setup', v); } catch (e) {} }, old);
        await page.goto(origin + '/playground.html#setup');
        const over = () => page.evaluate(() => document.documentElement.scrollWidth <= document.documentElement.clientWidth);
        const tag = `${scheme}${seed ? '+old state' : ''}`;
        if (!(await over())) return `${tag}: horizontal overflow on load`;
        await page.locator('#su-ui').setChecked(false);
        if (!(await over())) return `${tag}: horizontal overflow with screens off`;
        await page.locator('#su-ui').setChecked(true);
        if (!(await over())) return `${tag}: horizontal overflow with screens on`;
        if (errs.length) return `${tag}: console errors: ${errs.join(' | ')}`;
        await ctx.close();
      }
    });

    await test('AC20 no external requests', async () => {
      const bad = [];
      for (const u of ['/index.html', '/playground.html#setup']) {
        const page = await browser.newPage();
        page.on('request', (r) => {
          const url = r.url();
          if (!(url.startsWith(origin) || /^(data|about|blob):/.test(url))) bad.push(url);
        });
        await page.goto(origin + u);
        await page.waitForLoadState('load');
        await page.close();
      }
      if (bad.length) return 'external requests: ' + bad.join(', ');
    });
  } finally {
    await browser.close();
    server.close();
  }
  process.exitCode = failed ? 1 : 0;
})().catch((e) => { console.log('FAIL harness: ' + e.message); process.exitCode = 1; });
