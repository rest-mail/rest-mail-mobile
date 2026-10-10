#!/usr/bin/env python3
"""Point the Runner target, and only it, at an explicit provisioning profile.

Build settings handed to `xcodebuild` on the command line reach every target in
the build. Since Flutter moved its plugins to Swift Package Manager targets,
that is fatal: a SwiftPM target refuses a profile it was never built to carry,
and the archive fails before it compiles anything. Writing the settings into
the Runner target's own Release configuration keeps them where they belong and
leaves the plugins signing the way they expect to.

The same thing fastlane's update_code_signing_settings does, without taking a
Ruby toolchain on for it.

Usage: scope_manual_signing.py <profile name> [pbxproj path]
"""

import re
import sys
from pathlib import Path

AUTOMATIC = "CODE_SIGN_STYLE = Automatic;"


def main() -> int:
    if not 2 <= len(sys.argv) <= 3:
        return fail(__doc__.strip().splitlines()[-1])

    profile = sys.argv[1]
    path = Path(sys.argv[2] if len(sys.argv) == 3 else "ios/Runner.xcodeproj/project.pbxproj")
    text = path.read_text()

    # The target names its configurations by id; find the Release one's.
    configs = re.search(
        r'/\* Build configuration list for PBXNativeTarget "Runner" \*/ = \{'
        r".*?buildConfigurations = \((.*?)\);",
        text,
        re.S,
    )
    if configs is None:
        return fail("no build configuration list for the Runner target")

    release = re.search(r"([0-9A-F]{24}) /\* Release \*/", configs.group(1))
    if release is None:
        return fail("the Runner target has no Release configuration")

    # Rewrite that configuration alone, leaving every other target untouched.
    opening = f"\t\t{release.group(1)} /* Release */ = {{"
    try:
        start = text.index(opening)
        end = text.index("\n\t\t};\n", start)
    except ValueError:
        return fail(f"configuration {release.group(1)} is not shaped as expected")

    block = text[start:end]
    if AUTOMATIC not in block:
        return fail(
            "expected the Runner target's Release configuration to sign "
            "automatically; it already says something else, so this script "
            "would be guessing at what to change"
        )

    patched = block.replace(
        AUTOMATIC,
        "CODE_SIGN_STYLE = Manual;\n"
        '\t\t\t\tCODE_SIGN_IDENTITY = "Apple Distribution";\n'
        f'\t\t\t\tPROVISIONING_PROFILE_SPECIFIER = "{profile}";',
    )
    path.write_text(text[:start] + patched + text[end:])

    print(f"Runner/Release now signs manually with '{profile}'")
    return 0


def fail(message: str) -> int:
    print(f"error: {message}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
