#!/usr/bin/env python3
"""Kit-only test: YAML assertions on .github/workflows/release.yml (AC2-AC4).
Run: python3 kit/scripts/test-release-workflow.py  (needs PyYAML)"""
import os, re, sys
import yaml

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
PATH = os.path.join(ROOT, ".github", "workflows", "release.yml")
GUARD = "github.repository == 'Eugenelcc/project-starter-kit'"
failed = False


def load():
    with open(PATH, encoding="utf-8") as f:
        raw = f.read()
    return raw, yaml.safe_load(raw)


def ac2(raw, wf):
    assert wf.get("on", wf.get(True)) == {"push": {"tags": ["v*"]}}, "on != push tags v*"


def ac3(raw, wf):
    jobs = wf["jobs"]
    assert jobs, "no jobs"
    for n, j in jobs.items():
        assert j.get("if") == GUARD, f"job {n} lacks repo guard"


def ac4(raw, wf):
    assert wf.get("permissions") == {"contents": "write"}, "top-level permissions"
    for n, j in wf["jobs"].items():
        assert "permissions" not in j, f"job {n} has own permissions"
        for s in j["steps"]:
            if "uses" in s:
                assert s["uses"].startswith("actions/checkout@v4"), s["uses"]
    names = re.findall(r"secrets\.(\w+)", raw)
    assert all(n == "GITHUB_TOKEN" for n in names), names


for name, fn in [
    ("AC2 triggers only on v* tag pushes", ac2),
    ("AC3 every job has the repo guard", ac3),
    ("AC4 only GITHUB_TOKEN, contents write, checkout only", ac4),
]:
    try:
        raw, wf = load()
        fn(raw, wf)
        print(f"PASS {name}")
    except Exception as e:  # noqa: BLE001
        print(f"FAIL {name}: {type(e).__name__}: {e}")
        failed = True
sys.exit(1 if failed else 0)
