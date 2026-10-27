import copy
import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import generate


class GenerationInputs(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.patch = patch.object(generate, "ROOT", self.root)
        self.patch.start()
        self.addCleanup(self.patch.stop)
        self.spec = {"info": {"version": "1.0.0"}, "paths": {"/items": {"get": {"operationId": "getItems"}}}}
        self.file = self.root / "openapi.json"
        self.file.write_text(json.dumps(self.spec))
        self.pin = {"server": {"document": "openapi.json", "version": "1.0.0", "sha256": hashlib.sha256(self.file.read_bytes()).hexdigest()}}

    def test_document_requires_the_exact_locked_bytes(self):
        path, operations = generate.document(self.pin)
        self.assertEqual(path, self.file)
        self.assertEqual(operations, ["getItems"])
        self.file.write_text("{}")
        with self.assertRaisesRegex(ValueError, "checksum"):
            generate.document(self.pin)

    def test_release_version_must_match(self):
        self.pin["server"]["version"] = "2.0.0"
        with self.assertRaisesRegex(ValueError, "version"):
            generate.document(self.pin)

    def test_new_or_changed_operations_are_not_an_old_fixed_inventory(self):
        self.spec["paths"]["/new"] = {"post": {"operationId": "newOperation"}}
        self.file.write_text(json.dumps(self.spec))
        self.pin["server"]["sha256"] = hashlib.sha256(self.file.read_bytes()).hexdigest()
        self.assertEqual(generate.document(self.pin)[1], ["getItems", "newOperation"])

    def test_output_paths_cannot_escape_repository(self):
        with self.assertRaises(ValueError):
            generate.rooted("../elsewhere")

    def test_drift_includes_missing_extra_and_changed_files(self):
        self.assertEqual(generate.differences({"missing": b"", "changed": b"a"}, {"extra": b"b", "changed": b"b"}), ["changed", "extra", "missing"])

    def test_generator_archive_and_version_are_locked(self):
        pin = {"version": "0.10.0", "archive_sha256": "a" * 64}
        lock = 'packages:\n  tonik:\n    description:\n      sha256: "' + "a" * 64 + '"\n    version: "0.10.0"\nsdks:\n'
        generate.toolchain_lock(lock, pin)
        for key, value in (("version", "0.11.0"), ("archive_sha256", "b" * 64)):
            wrong = copy.deepcopy(pin)
            wrong[key] = value
            with self.assertRaisesRegex(ValueError, "pinned"):
                generate.toolchain_lock(lock, wrong)


if __name__ == "__main__":
    unittest.main()
