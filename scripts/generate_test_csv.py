#!/usr/bin/env python3
"""Generate test_data_published.csv and test_data_upcoming.csv.

Usage:  python3 scripts/generate_test_csv.py

Output:
  ~/Downloads/test_data_published.csv  — 18 published tests
  ~/Downloads/test_data_upcoming.csv   — 10 upcoming tests
UTF-8-BOM, readable by Excel / Google Sheets.
"""

import csv
import glob
import json
import os

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DOWNLOADS = os.path.join(os.path.expanduser("~"), "Downloads")

FIELDS = [
    "id",
    "name",
    "description",
    "about",
    "category",
    "question_count",
    "estimated_time_min",
    "sensitivity_level",
    "reliability_badge",
    "author_citation",
    "author_url",
    "adapter_citation",
    "adapter_url",
    "bangla_version_url",
    "bangla_version_scoring_url",
    "bangla_version_doi",
]


def collect_attr(entries):
    """Join citation and url arrays into single pipe-delimited strings."""
    if not entries:
        return "", ""
    citations = [e["citation"] for e in entries]
    urls = [e.get("url", "") for e in entries]
    return " | ".join(citations), " | ".join(urls)


def escape_field(val):
    if val is None:
        return ""
    return val.replace("\n", "\\n")


def write_csv(filename, rows):
    path = os.path.join(DOWNLOADS, filename)
    with open(path, "w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS)
        writer.writeheader()
        writer.writerows(rows)
    print(f"✅  Wrote {len(rows)} rows → {path}")


def load_manifest():
    path = os.path.join(PROJECT_ROOT, "assets/data/tests_manifest.json")
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
    return {item["id"]: item for item in data["tests"]}


def build_published_rows():
    manifest = load_manifest()
    rows = []
    for path in sorted(glob.glob(os.path.join(PROJECT_ROOT, "assets/data", "*_bn.json"))):
        with open(path, encoding="utf-8") as f:
            test = json.load(f)

        tid = test["id"]
        m = manifest.get(tid, {})
        r = test.get("resources") or {}
        author_cit, author_url = collect_attr(test.get("author"))
        adapter_cit, adapter_url = collect_attr(test.get("adapter"))

        rows.append({
            "id": tid,
            "name": test["name"],
            "description": escape_field(m.get("description", "")),
            "about": escape_field(test.get("about", "")),
            "category": m.get("category", ""),
            "question_count": m.get("questionCount", ""),
            "estimated_time_min": m.get("estimatedTimeMinutes", ""),
            "sensitivity_level": m.get("sensitivityLevel", ""),
            "reliability_badge": m.get("reliabilityBadge", ""),
            "author_citation": author_cit,
            "author_url": author_url,
            "adapter_citation": adapter_cit,
            "adapter_url": adapter_url,
            "bangla_version_url": r.get("banglaVersionUrl", ""),
            "bangla_version_scoring_url": r.get("banglaVersionScoringUrl", ""),
            "bangla_version_doi": r.get("banglaVersionDoi", ""),
        })
    return rows


def build_upcoming_rows():
    path = os.path.join(PROJECT_ROOT, "assets/data/upcoming/upcoming_manifest.json")
    with open(path, encoding="utf-8") as f:
        data = json.load(f)

    rows = []
    for item in data["tests"]:
        r = item.get("resources") or {}
        rows.append({
            "id": item["id"],
            "name": item["name"],
            "description": escape_field(item.get("description", "")),
            "about": "",
            "category": item.get("category", ""),
            "question_count": item.get("questionCount", ""),
            "estimated_time_min": item.get("estimatedTimeMinutes", ""),
            "sensitivity_level": item.get("sensitivityLevel", ""),
            "reliability_badge": item.get("reliabilityBadge", ""),
            "author_citation": "",
            "author_url": "",
            "adapter_citation": "",
            "adapter_url": "",
            "bangla_version_url": r.get("banglaVersionUrl", ""),
            "bangla_version_scoring_url": r.get("banglaVersionScoringUrl", ""),
            "bangla_version_doi": r.get("banglaVersionDoi", ""),
        })
    return rows


def main():
    write_csv("test_data_published.csv", build_published_rows())
    write_csv("test_data_upcoming.csv", build_upcoming_rows())


if __name__ == "__main__":
    main()
