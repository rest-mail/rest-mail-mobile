#!/usr/bin/env python3
"""Validate the pinned admin parity manifest without network or dependencies.

Schema expansion is also used by the local snapshot generator. The manifest
records declared contracts and source references, not inferred runtime success.
"""
import argparse
import json
import re
from pathlib import Path


HTTP_METHODS = {'get', 'post', 'put', 'patch', 'delete', 'head', 'options'}
ASSESSMENTS = {'needs_field_review', 'documented_and_unit_tested'}


def resolve(document, value):
    """Resolve one local JSON pointer, preserving siblings of a reference."""
    if not isinstance(value, dict) or '$ref' not in value:
        return value
    ref = value['$ref']
    if not ref.startswith('#/'):
        raise ValueError(f'External reference is not pinned: {ref}')
    target = document
    for part in ref[2:].split('/'):
        target = target[part.replace('~1', '/').replace('~0', '~')]
    return {**target, **{k: v for k, v in value.items() if k != '$ref'}}


def schema_fields(document, schema, path='$', seen=frozenset()):
    """List nested fields, including explicitly opaque or recursive shapes."""
    if not schema:
        return [{'path': path, 'type': 'unspecified', 'opaque': True}]
    ref = schema.get('$ref')
    if ref in seen:
        return [{'path': path, 'type': 'recursive', 'ref': ref, 'opaque': True}]
    nested_seen = seen | {ref} if ref else seen
    schema = resolve(document, schema)
    fields = []
    props = schema.get('properties', {})
    for name, value in props.items():
        fields.extend(schema_fields(document, value, f'{path}.{name}', nested_seen))
    if 'items' in schema:
        fields.extend(schema_fields(document, schema['items'], f'{path}[]', nested_seen))
    for keyword in ('allOf', 'oneOf', 'anyOf'):
        for variant in schema.get(keyword, []):
            fields.extend(schema_fields(document, variant, path, nested_seen))
    additional = schema.get('additionalProperties')
    if additional is True or isinstance(additional, dict):
        fields.extend(schema_fields(document, additional if isinstance(additional, dict) else {}, f'{path}.*', nested_seen))
    if not fields:
        kind = schema.get('type', 'unspecified')
        entry = {'path': path, 'type': kind}
        for key in ('format', 'enum', 'minimum', 'maximum', 'minLength', 'maxLength', 'pattern', 'nullable'):
            if key in schema:
                entry[key] = schema[key]
        if kind in ('object', 'array', 'unspecified'):
            entry['opaque'] = True
        fields.append(entry)
    # allOf/oneOf can repeat a field; retain distinct constraints, not duplicates.
    return list({json.dumps(f, sort_keys=True): f for f in fields}.values())


def operation_contract(document, path_item, operation):
    parameters = {}
    for raw in path_item.get('parameters', []) + operation.get('parameters', []):
        parameter = resolve(document, raw)
        parameters[(parameter['in'], parameter['name'])] = parameter
    body = resolve(document, operation.get('requestBody', {}))
    content = body.get('content', {}).get('application/json', {})
    responses = {}
    for status, raw in operation.get('responses', {}).items():
        response = resolve(document, raw)
        media = response.get('content', {}).get('application/json')
        responses[status] = {'description': response.get('description', ''), 'fields': schema_fields(document, media.get('schema', {})) if media is not None else [], 'has_json_body': media is not None}
    return {
        'parameters': list(parameters.values()),
        'body_required': body.get('required', False),
        'body_schema': content.get('schema'),
        'body_fields': schema_fields(document, content['schema']) if 'schema' in content else [],
        'responses': responses,
    }


def validate(manifest):
    errors = []
    if manifest.get('schema_version') != 1:
        errors.append('Unsupported schema_version')
    expected = manifest.get('production_routes', [])
    operations = manifest.get('operations', [])
    if len(expected) != 81 or len(set(expected)) != 81:
        errors.append('Pinned production route inventory must contain 81 unique routes')
    observed = [f"{op.get('method')} {op.get('path')}" for op in operations]
    if len(observed) != len(set(observed)):
        errors.append('Duplicate operation route')
    if set(observed) != set(expected):
        errors.append('Operations differ from pinned production route inventory')
    ids = [op.get('operationId') for op in operations]
    if not all(ids) or len(ids) != len(set(ids)):
        errors.append('Operation IDs must be nonempty and unique')
    for op in operations:
        name = op.get('operationId', '?')
        if '/admin/test/' in op.get('path', ''):
            errors.append(f'{name}: test-only route counted as production')
        for key in ('request_assessment', 'response_assessment'):
            if op.get(key) not in ASSESSMENTS:
                errors.append(f'{name}: missing explicit {key}')
        contract = op.get('contract', {})
        if not contract.get('responses'):
            errors.append(f'{name}: response contract missing')
        declared = {p['name'] for p in contract.get('parameters', []) if p.get('in') == 'path'}
        if declared != set(re.findall(r'\{([^}]+)\}', op.get('path', ''))):
            errors.append(f'{name}: path parameters differ from route')
        for source_name in ('server', 'mobile_client'):
            source = op.get(source_name, {})
            if not re.fullmatch(r'[0-9a-f]{40}', source.get('revision', '')):
                errors.append(f'{name}: {source_name} revision is not pinned')
            if not source.get('path') or not source.get('line'):
                errors.append(f'{name}: {source_name} source location missing')
        if not op.get('mobile_ui'):
            errors.append(f'{name}: UI call-site evidence missing')
        if not op.get('permissions', {}).get('scope_rule'):
            errors.append(f'{name}: route scope rule missing')
        if op.get('overall_parity') is not False:
            errors.append(f'{name}: source discovery must not certify overall parity')
        if 'documented_and_unit_tested' in (op.get('request_assessment'), op.get('response_assessment')) and not op.get('field_mapping_document'):
            errors.append(f'{name}: field-level assessment needs a mapping document')
    return errors


def report(manifest):
    ops = manifest['operations']
    return {
        'production_operations': len(ops),
        'request_fields_requiring_review': [o['operationId'] for o in ops if o['request_assessment'] == 'needs_field_review'],
        'response_fields_requiring_review': [o['operationId'] for o in ops if o['response_assessment'] == 'needs_field_review'],
        'void_clients_with_success_json': [o['operationId'] for o in ops if o['mobile_client']['return_type'] == 'void' and any(v['has_json_body'] for k, v in o['contract']['responses'].items() if k.startswith('2'))],
        'opaque_success_contracts': [o['operationId'] for o in ops if any(f.get('opaque') for k, v in o['contract']['responses'].items() if k.startswith('2') for f in v['fields'])],
        'overall_parity_certified': False,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('manifest', type=Path)
    parser.add_argument('--report', action='store_true')
    args = parser.parse_args()
    data = json.loads(args.manifest.read_text())
    errors = validate(data)
    if errors:
        raise SystemExit('\n'.join(errors))
    print(json.dumps(report(data) if args.report else {'valid': True, 'production_operations': len(data['operations']), 'overall_parity_certified': False}, indent=2))


if __name__ == '__main__':
    main()
