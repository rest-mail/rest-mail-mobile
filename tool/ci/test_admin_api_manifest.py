import copy
import json
import unittest
from pathlib import Path

from admin_api_manifest import operation_contract, report, resolve, schema_fields, validate


class ManifestTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.snapshot = json.loads((Path(__file__).resolve().parents[2] / 'docs/admin-api-parity.json').read_text())

    def test_all_production_operations_are_mapped_without_certifying_parity(self):
        self.assertEqual(validate(self.snapshot), [])
        self.assertEqual(len(self.snapshot['operations']), 81)
        self.assertFalse(report(self.snapshot)['overall_parity_certified'])
        stats = next(o for o in self.snapshot['operations'] if o['operationId'] == 'getDashboardStats')
        self.assertEqual(len(stats['contract']['responses']['200']['fields']), 18)

    def test_missing_operation_fails(self):
        doc = copy.deepcopy(self.snapshot)
        doc['operations'].pop()
        self.assertTrue(any('inventory' in e for e in validate(doc)))

    def test_duplicate_operation_fails(self):
        doc = copy.deepcopy(self.snapshot)
        doc['operations'].append(doc['operations'][0])
        self.assertTrue(any('Duplicate' in e for e in validate(doc)))

    def test_wrong_path_parameters_fail(self):
        doc = copy.deepcopy(self.snapshot)
        op = next(o for o in doc['operations'] if '{' in o['path'])
        op['contract']['parameters'] = []
        self.assertTrue(any('path parameters' in e for e in validate(doc)))

    def test_unpinned_source_fails(self):
        doc = copy.deepcopy(self.snapshot)
        doc['operations'][0]['mobile_client']['revision'] = 'main'
        self.assertTrue(any('not pinned' in e for e in validate(doc)))

    def test_missing_ui_evidence_fails(self):
        doc = copy.deepcopy(self.snapshot)
        doc['operations'][0]['mobile_ui'] = []
        self.assertTrue(any('UI call-site' in e for e in validate(doc)))

    def test_source_discovery_cannot_certify_parity(self):
        doc = copy.deepcopy(self.snapshot)
        doc['operations'][0]['overall_parity'] = True
        self.assertTrue(any('must not certify' in e for e in validate(doc)))

    def test_field_assessment_requires_a_mapping(self):
        doc = copy.deepcopy(self.snapshot)
        doc['operations'][0]['response_assessment'] = 'documented_and_unit_tested'
        self.assertTrue(any('mapping document' in e for e in validate(doc)))

    def test_schema_refs_arrays_and_constraints_are_expanded(self):
        doc = {'components': {'schemas': {'Thing': {'type': 'object', 'properties': {'name': {'type': ['string', 'null'], 'maxLength': 20}}}}}}
        fields = schema_fields(doc, {'type': 'array', 'items': {'$ref': '#/components/schemas/Thing'}})
        self.assertEqual(fields, [{'path': '$[].name', 'type': ['string', 'null'], 'maxLength': 20}])

    def test_recursive_and_dynamic_shapes_are_explicit(self):
        doc = {'components': {'schemas': {'Tree': {'type': 'object', 'properties': {'child': {'$ref': '#/components/schemas/Tree'}}}}}}
        fields = schema_fields(doc, {'$ref': '#/components/schemas/Tree'})
        self.assertTrue(fields[0]['opaque'])
        self.assertEqual(fields[0]['type'], 'recursive')
        self.assertEqual(schema_fields({}, {'type': 'object', 'additionalProperties': True}), [{'path': '$.*', 'type': 'unspecified', 'opaque': True}])

    def test_operation_parameters_override_shared_parameters(self):
        shared = {'parameters': [{'in': 'query', 'name': 'limit', 'schema': {'type': 'integer', 'maximum': 10}}]}
        operation = {'parameters': [{'in': 'query', 'name': 'limit', 'schema': {'type': 'integer', 'maximum': 20}}], 'responses': {'204': {'description': 'Deleted'}}}
        contract = operation_contract({}, shared, operation)
        self.assertEqual(contract['parameters'][0]['schema']['maximum'], 20)
        self.assertEqual(contract['responses']['204']['fields'], [])
        self.assertFalse(contract['responses']['204']['has_json_body'])

    def test_external_reference_is_rejected(self):
        with self.assertRaises(ValueError):
            resolve({}, {'$ref': 'https://example.test/moving-schema.json'})

    def test_report_identifies_response_acknowledgements_for_review(self):
        result = report(self.snapshot)
        self.assertEqual(set(result['void_clients_with_success_json']), {'deleteCustomFilter', 'deletePipeline', 'bounceQueueEntry', 'retryQueueEntry'})
        self.assertIn('testFilter', result['opaque_success_contracts'])


if __name__ == '__main__':
    unittest.main()
