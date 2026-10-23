import unittest

from build_whats_new import build_history


def release(tag, **values):
    return {"tag_name": tag, "name": f"Release {tag}", "body": "Notes", **values}


class ReleaseHistoryTests(unittest.TestCase):
    def test_numeric_newest_first_and_ten_only(self):
        history = build_history([release(f"v0.3.{number}") for number in range(90, 102)])
        self.assertEqual(history["schema"], 1)
        self.assertEqual([row["tag_name"] for row in history["releases"]], [f"v0.3.{n}" for n in range(101, 91, -1)])

    def test_major_minor_sort_before_patch(self):
        history = build_history([release("v0.3.999"), release("v1.0.0"), release("v0.4.0")])
        self.assertEqual([r["tag_name"] for r in history["releases"]], ["v1.0.0", "v0.4.0", "v0.3.999"])

    def test_drafts_prereleases_invalid_tags_and_bad_rows_are_excluded(self):
        rows = [None, "bad", release("v99.0.0", draft=True), release("v98.0.0", prerelease=True), release("v1.0.0-beta"), release("v01.0.0"), release("0.3.1"), release("v0.3.1")]
        self.assertEqual([r["tag_name"] for r in build_history(rows)["releases"]], ["v0.3.1"])

    def test_duplicate_tags_are_only_included_once(self):
        history = build_history([release("v0.3.1"), release("v0.3.1", body="Duplicate")])
        self.assertEqual(len(history["releases"]), 1)
        self.assertEqual(history["releases"][0]["body"], "Notes")

    def test_null_text_and_safe_metadata(self):
        history = build_history([release("v0.3.1", name=None, body=None, published_at="2026-10-23T00:00:00Z", assets=["ignored"], author={"login": "ignored"})])
        self.assertEqual(history["releases"][0], {"tag_name": "v0.3.1", "name": "", "body": "", "published_at": "2026-10-23T00:00:00Z"})

    def test_bad_text_does_not_mask_a_later_valid_duplicate(self):
        history = build_history([release("v0.3.1", body=99), release("v0.3.1", body="Valid")])
        self.assertEqual(history["releases"][0]["body"], "Valid")

    def test_paginated_input_and_unicode_are_preserved(self):
        history = build_history([[release("v0.3.1", body="Überprüfung\n* Fixed #1")], [release("v0.3.2")]])
        self.assertEqual(history["releases"][1]["body"], "Überprüfung\n* Fixed #1")

    def test_required_current_release_is_present(self):
        self.assertEqual(build_history([release("v0.3.2")], "v0.3.2")["releases"][0]["tag_name"], "v0.3.2")
        with self.assertRaisesRegex(ValueError, "missing"):
            build_history([release("v0.3.2")], "v0.3.3")

    def test_empty_or_malformed_input_is_rejected(self):
        for value in [[], {}, [release("dev")]]:
            with self.subTest(value=value), self.assertRaises(ValueError):
                build_history(value)


if __name__ == "__main__":
    unittest.main()
