#!/usr/bin/env python3
"""Build the single public release-history asset from GitHub release JSON."""

import argparse
import json
from pathlib import Path
import re

TAG = re.compile(r"^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$")
LIMIT = 10


def build_history(releases, require_tag=None):
    if not isinstance(releases, list):
        raise ValueError("GitHub releases must be an array")
    # gh api --paginate --slurp returns one array per page.
    rows = [row for page in releases for row in (page if isinstance(page, list) else [page])]
    selected = {}
    for row in rows:
        if not isinstance(row, dict) or row.get("draft") is True or row.get("prerelease") is True:
            continue
        tag = row.get("tag_name")
        if not isinstance(tag, str) or not TAG.fullmatch(tag) or tag in selected:
            continue
        name, body = row.get("name"), row.get("body")
        if (name is not None and not isinstance(name, str)) or (body is not None and not isinstance(body, str)):
            continue
        value = {"tag_name": tag, "name": name or "", "body": body or ""}
        if isinstance(row.get("published_at"), str):
            value["published_at"] = row["published_at"]
        selected[tag] = value
    tags = sorted(selected, key=lambda tag: tuple(map(int, tag[1:].split("."))), reverse=True)[:LIMIT]
    if not tags:
        raise ValueError("No public stable releases found")
    if require_tag and require_tag not in tags:
        raise ValueError(f"Current release {require_tag} is missing from the latest ten")
    return {"schema": 1, "releases": [selected[tag] for tag in tags]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--require-tag")
    args = parser.parse_args()
    try:
        history = build_history(json.loads(args.source.read_text()), args.require_tag)
    except (ValueError, OSError) as error:
        parser.error(str(error))
    args.output.write_text(json.dumps(history, ensure_ascii=False, indent=2) + "\n")
    print(f"Wrote {len(history['releases'])} releases, latest {history['releases'][0]['tag_name']}")


if __name__ == "__main__":
    main()
