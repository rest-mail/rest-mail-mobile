#!/usr/bin/env python3
"""Every version of the app App Store Connect knows, one per line.

Apple's own record of what was released: a marketing version that has had a
TestFlight build is a pre-release version, and one that went to the App Store
is an App Store version. It counts builds uploaded from anywhere, not only from
this pipeline, so tool/ci/version_check.sh asks it before an upload.

Reads the same App Store Connect API key the upload uses:

    APP_STORE_CONNECT_KEY_ID, APP_STORE_CONNECT_ISSUER_ID,
    APP_STORE_CONNECT_PRIVATE_KEY (the .p8 text), BUNDLE_ID

Needs PyJWT with its crypto extra (pip install 'pyjwt[crypto]').
"""

import json
import os
import sys
import time
import urllib.parse
import urllib.request

import jwt

API = os.environ.get("APP_STORE_CONNECT_API", "https://api.appstoreconnect.apple.com")


def token() -> str:
    """A short-lived ES256 token, as App Store Connect asks for one."""
    now = int(time.time())
    return jwt.encode(
        {
            "iss": os.environ["APP_STORE_CONNECT_ISSUER_ID"],
            "iat": now,
            "exp": now + 10 * 60,  # Apple refuses anything over 20 minutes
            "aud": "appstoreconnect-v1",
        },
        os.environ["APP_STORE_CONNECT_PRIVATE_KEY"],
        algorithm="ES256",
        headers={"kid": os.environ["APP_STORE_CONNECT_KEY_ID"], "typ": "JWT"},
    )


def get(url: str, bearer: str) -> dict:
    request = urllib.request.Request(url, headers={"Authorization": f"Bearer {bearer}"})
    with urllib.request.urlopen(request, timeout=30) as response:
        return json.load(response)


def every(path: str, query: dict, bearer: str):
    """Every item of a paged list, following Apple's links.next."""
    url = f"{API}{path}?{urllib.parse.urlencode(query)}"
    while url:
        page = get(url, bearer)
        yield from page.get("data", [])
        url = page.get("links", {}).get("next")


def main() -> int:
    bearer = token()
    bundle = os.environ["BUNDLE_ID"]
    apps = list(every("/v1/apps", {"filter[bundleId]": bundle}, bearer))
    if len(apps) != 1:
        print(f"App Store Connect has {len(apps)} apps with bundle id {bundle}", file=sys.stderr)
        return 1
    app = apps[0]["id"]

    versions = set()
    for item in every(
        "/v1/preReleaseVersions",
        {"filter[app]": app, "filter[platform]": "IOS", "fields[preReleaseVersions]": "version", "limit": 200},
        bearer,
    ):
        versions.add(item["attributes"]["version"])
    for item in every(
        f"/v1/apps/{app}/appStoreVersions",
        {"fields[appStoreVersions]": "versionString", "limit": 200},
        bearer,
    ):
        versions.add(item["attributes"]["versionString"])

    for version in sorted(versions):
        print(version)
    return 0


if __name__ == "__main__":
    sys.exit(main())
