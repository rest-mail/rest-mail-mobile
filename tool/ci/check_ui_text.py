"""Reject untranslated literals in UI constructors, fields and defaults.

The initial migration also audited helper functions, backend errors and native
resources. This guard covers common direct UI entry points without inspecting or
rewriting any runtime server or user content.
"""

from pathlib import Path
import re
import sys


LITERAL = r"(?:'((?:\\.|[^'\\])*)'|\"((?:\\.|[^\"\\])*)\")"
DISPLAY = re.compile(
    r"(?:\b(?:Text|SectionLabel|AdminField|AdminMessage)\s*\(\s*"
    r"|\b(?:label|labelText|title|subtitle|hint|hintText|tooltip|message|helperText|intro|description|name|tagline)\s*:\s*"
    r"|\bthis\.(?:title|label|action|intro)\s*=\s*)" + LITERAL,
    re.MULTILINE,
)

# These are proper names, protocol syntax, sample identities and input examples.
TECHNICAL = {
    "rest-mail", "REST Mail", "REST MAIL", "TLS", "STARTTLS", "HTTPS · REST",
    "API", "DKIM", "SPF", "DMARC", "MTA-STS", "DANE", "PDF",
    "DR", "NO", "Dana Ruiz", "Nadia Oakline", "file.pdf", "name", "mail", "Message-ID",
}


def untranslated(source):
    for match in DISPLAY.finditer(source):
        text = match[1] if match[1] is not None else match[2]
        if not re.search(r"[A-Za-z]", text):
            continue
        if text in TECHNICAL or re.fullmatch(r"[a-z]\w*(?:\.\w+)+", text):
            continue
        if text.startswith(("-----BEGIN ", "https://", "http://", "/api/", "mx.")):
            continue
        if text.startswith('require "fileinto";') or re.fullmatch(r"(?:\d+(?:\.\d+)?(?:ns|us|ms|s|m|h))+", text):
            continue
        if "@" in text and (not re.search(r"\s", text) or "${" in text):
            continue
        # A string containing only interpolated values and punctuation is data.
        words = re.sub(r"\$(?:\{[^{}]*\}|[A-Za-z_]\w*)", "", text)
        words = re.sub(r"\$\{[^}]*$", "", words)
        if re.fullmatch(r"[\s\d:;,·%-]*(?:ns|us|ms|s|B|KB|MB|GB|TB)[\s\d:;,·%-]*", words):
            continue
        if not re.search(r"[A-Za-z]", words):
            continue
        line = source.count("\n", 0, match.start()) + 1
        yield line, text


def main():
    files = list(Path("lib/ui").rglob("*.dart")) + [
        Path("lib/theme/packs.dart"), Path("lib/state/interface_prefs.dart")
    ]
    failures = 0
    for path in files:
        for line, text in untranslated(path.read_text()):
            print(f"{path}:{line}: move app text into a language pack: {text}")
            failures += 1
    if failures:
        return 1
    print(f"Checked direct UI text in {len(files)} Dart files.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
