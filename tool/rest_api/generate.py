#!/usr/bin/env python3
"""Generate the committed wire client from the locked server document and Tonik.

--write replaces generated output; --check regenerates into a temporary directory
and fails on drift. --bootstrap-toolchain resolves the generator lock explicitly;
ordinary generation requires that exact committed dependency lock.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[2]
PIN = ROOT / "tool/rest_api/contract.lock.json"
IGNORED = {".dart_tool", "pubspec.lock", ".git"}


def rooted(relative):
    result = (ROOT / relative).resolve()
    if not result.is_relative_to(ROOT) or result == ROOT:
        raise ValueError("generation paths must stay inside the repository")
    return result


def document(pin):
    data = rooted(pin["server"]["document"]).read_bytes()
    if hashlib.sha256(data).hexdigest() != pin["server"]["sha256"]:
        raise ValueError("server document differs from its locked checksum")
    spec = json.loads(data)
    if spec.get("info", {}).get("version") != pin["server"]["version"]:
        raise ValueError("server document differs from its locked release version")
    operations = [
        op.get("operationId")
        for path in spec["paths"].values()
        for method, op in path.items()
        if method in {"get", "post", "put", "patch", "delete", "head", "options"}
    ]
    if not operations or not all(operations) or len(operations) != len(set(operations)):
        raise ValueError("server operations must have unique operation IDs")
    return rooted(pin["server"]["document"]), operations


def files(directory):
    if not directory.is_dir():
        return {}
    return {
        str(path.relative_to(directory)): path.read_bytes()
        for path in directory.rglob("*")
        if path.is_file()
        and not any(part in IGNORED for part in path.relative_to(directory).parts)
    }


def differences(expected, actual):
    return sorted(name for name in expected.keys() | actual.keys() if expected.get(name) != actual.get(name))


def toolchain_lock(data, generator):
    entry = re.search(r"(?m)^  tonik:\n((?:    .*\n)+)", data)
    if entry is None:
        raise ValueError("generator dependency lock has no Tonik entry")
    block = entry.group(1)
    sha = re.search(r"sha256: [\"']?([0-9a-f]{64})", block)
    version = re.search(r"version: [\"']?([0-9.]+)", block)
    if sha is None or version is None or sha.group(1) != generator["archive_sha256"] or version.group(1) != generator["version"]:
        raise ValueError("generator dependency lock differs from the pinned Tonik release")


def generate(pin, write=False, bootstrap=False):
    source, operations = document(pin)
    generator = pin["generator"]
    if generator["package"] != "tonik" or generator["backend"] != "http":
        raise ValueError("the decided generator is Tonik with the http backend")
    if not re.fullmatch(r"\d+\.\d+\.\d+", generator["version"]):
        raise ValueError("pin one exact Tonik version")
    version = subprocess.check_output(["dart", "--version"], text=True, stderr=subprocess.STDOUT)
    if f"Dart SDK version: {generator['dart_version']} " not in version:
        raise ValueError("use the Dart SDK pinned with the generator")
    lock = rooted(generator["toolchain_lock"])
    target = rooted(pin["output"]["directory"])
    package = pin["output"]["package"]
    if not re.fullmatch(r"[a-z][a-z0-9_]*", package):
        raise ValueError("invalid generated package name")
    if target != ROOT / "packages" / package:
        raise ValueError("generated output must be its named package directory")

    with tempfile.TemporaryDirectory(prefix="restmail-codegen-") as temporary:
        temp = Path(temporary)
        tool = temp / "tool"
        tool.mkdir()
        (tool / "pubspec.yaml").write_text(
            "name: restmail_codegen\npublish_to: none\n"
            f"environment:\n  sdk: '^{generator['dart_version']}'\n"
            f"dependencies:\n  tonik: '{generator['version']}'\n"
        )
        if lock.exists():
            toolchain_lock(lock.read_text(), generator)
            shutil.copyfile(lock, tool / "pubspec.lock")
        elif not bootstrap:
            raise ValueError("generator dependency lock missing; bootstrap explicitly in GitHub")
        command = ["dart", "pub", "get"]
        if not bootstrap:
            command.append("--enforce-lockfile")
        subprocess.run(command, cwd=tool, check=True)
        resolved = (tool / "pubspec.lock").read_text()
        toolchain_lock(resolved, generator)
        if bootstrap:
            lock.write_text(resolved)
        output = temp / "output"
        subprocess.run(
            ["dart", "run", "tonik", "--spec", str(source), "--package-name", package,
             "--backend", "http", "--output-dir", str(output), "--workers", "2"],
            cwd=tool, check=True, env={**os.environ, "TONIK_WORKERS": "2"},
        )
        generated = output / package
        if not (generated / "pubspec.yaml").is_file():
            raise ValueError("Tonik produced no package")
        expected = files(generated)
        changes = differences(expected, files(target))
        if write:
            if target.exists():
                shutil.rmtree(target)
            shutil.copytree(generated, target)
        elif changes:
            raise ValueError("generated client drift:\n" + "\n".join(changes[:30]))
        print(json.dumps({"generator": f"tonik {generator['version']}", "server": pin["server"]["revision"],
                          "operations": len(operations), "files": len(expected), "mode": "write" if write else "check"}))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    parser.add_argument("--bootstrap-toolchain", action="store_true")
    args = parser.parse_args()
    if args.bootstrap_toolchain and not args.write:
        parser.error("bootstrap requires --write")
    generate(json.loads(PIN.read_text()), write=args.write, bootstrap=args.bootstrap_toolchain)


if __name__ == "__main__":
    main()
