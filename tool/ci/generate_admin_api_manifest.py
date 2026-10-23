import sys,json,re,subprocess,datetime,argparse
from pathlib import Path
import yaml
repo=Path(__file__).resolve().parents[2]
parser=argparse.ArgumentParser(description='Refresh the pinned source map from explicitly supplied worktrees; requires PyYAML only for generation.')
parser.add_argument('--server-root', type=Path, required=True)
parser.add_argument('--mobile-worktrees-root', type=Path, required=True)
parser.add_argument('--state', type=Path, required=True)
parser.add_argument('--initial-server-audit', type=Path, required=True)
parser.add_argument('--initial-mobile-audit', type=Path, required=True)
args=parser.parse_args()
sys.path.insert(0,str(repo/'tool/ci'))
from admin_api_manifest import operation_contract,validate,report
server=args.server_root
state=json.loads(args.state.read_text())
audit=json.loads(args.initial_server_audit.read_text())
spec=yaml.safe_load((server/'openapi.yaml').read_text())
revision=lambda p: subprocess.check_output(['git','rev-parse','HEAD'],cwd=p,text=True).strip()
server_rev=revision(server)
route_text=(server/'internal/api/routes.go').read_text()
routes={}
for number,line in enumerate(route_text.splitlines(),1):
 m=re.search(r'\.(Get|Post|Put|Patch|Delete)\("(/api/v1/admin/[^\"]+)",\s*([^\)]+)\)',line)
 if m and '/admin/test/' not in m[2]: routes[(m[1].upper(),m[2])]=(number,line.strip())
expected={(r['method'].upper(),r['path']) for r in audit['admin_routes'] if not r['test_only']}
assert set(routes)==expected,(set(routes)-expected,expected-set(routes))
caps=dict(re.findall(r'(Cap\w+)\s*=\s*"([^\"]+)"',(server/'internal/api/middleware/capabilities.go').read_text()))
method_overrides={
 'getDashboardStats':'stats','listRoles':'roles','listCapabilities':'capabilityDefinitions','listGrants':'grants','createGrant':'createGrant','deleteGrant':'deleteGrant','listMyGrants':'myGrants','activateGrant':'activateGrant','deactivateGrant':'deactivateGrant','makeGrantEligible':'makeGrantEligible',
 'getDomain':'domain','getMailbox':'adminMailbox','getAlias':'alias','endMailboxSessions':'endMailboxSessions','createPipeline':'createPipeline','testPipeline':'testPipeline','testFilter':'testFilter','createCustomFilter':'createCustomFilter','validateCustomFilter':'validateCustomFilter','getCustomFilter':'customFilter','testCustomFilter':'testCustomFilter',
 'bulkRetryQueue':'bulkRetryQueue','bulkBounceQueue':'bulkBounceQueue','bulkDeleteQueue':'bulkDeleteQueue','listSuppressions':'suppressions','clearSuppression':'clearSuppression','getDomainRelay':'domainRelay','setDomainRelay':'setDomainRelay','getDKIMRotation':'dkimRotation','setDKIMRotation':'setDkimRotation','setDKIMKey':'setDkimKey','getCertificate':'certificate','createCertificate':'uploadCertificate','unbanIP':'unbanIP'}
original={r['operationId']:r.get('mobile_client_method') for r in json.loads(args.initial_mobile_audit.read_text())['operations']}
source_groups=[
 (114,'wt-mobile-overview',{'getDashboardStats'}),
 (102,'wt-mobile-queue',{'listQueue','getQueueStats','bulkRetryQueue','bulkBounceQueue','bulkDeleteQueue','getQueueEntry','retryQueueEntry','bounceQueueEntry','deleteQueueEntry'}),
 (105,'wt-mobile-filters',{'listPipelines','createPipeline','updatePipeline','deletePipeline','testPipeline','testFilter','listCustomFilters','createCustomFilter','validateCustomFilter','getCustomFilter','updateCustomFilter','deleteCustomFilter','testCustomFilter'}),
 (106,'wt-mobile-bans',{'listBans','createBan','deleteBan','unbanIP'}),
 (109,'wt-mobile-admin-reports',{'getDeliveryLogs','listPipelineLogs','getPipelineAnalytics','getMessageTrace','listTlsReports','listAuditEntries','verifyAuditLog'}),
 (104,'wt-mobile-certificates',{'listCertificates','getCertificate','createCertificate','deleteCertificate'}),
 (111,'wt-mobile-mta-sts',{'getMtaStsPolicy','setMtaStsPolicy','deleteMtaStsPolicy'}),
 (112,'wt-mobile-sender-lists',{'listAllowlist','addToAllowlist','removeFromAllowlist','listBlocklist','addToBlocklist','removeFromBlocklist'}),
]
cache={};ops=[];missing=[]
for (method,path),(lineno,guard) in sorted(routes.items()):
 operation=spec['paths'][path][method.lower()];oid=operation['operationId']
 pr,tree=108,'wt-mobile-scoped-access'
 for number,name,ids in source_groups:
  if oid in ids: pr,tree=number,name;break
 root=args.mobile_worktrees_root/tree
 if tree not in cache:
  text=(root/'packages/restmail_api/lib/src/client.dart').read_text()
  declarations=list(re.finditer(r'^  Future<(.+?)>\s+(\w+)\(',text,re.M))
  methods={}
  for i,m in enumerate(declarations):
   end=declarations[i+1].start() if i+1<len(declarations) else len(text)
   methods[m[2]]={'line':text.count('\n',0,m.start())+1,'return_type':m[1],'fragment':text[m.start():end]}
  cache[tree]=(revision(root),methods)
 rev,methods=cache[tree];symbol=method_overrides.get(oid) or original.get(oid)
 if symbol not in methods: raise ValueError((oid,symbol,tree))
 api=methods[symbol]
 ui=[]
 for source in sorted((root/'lib').rglob('*.dart')):
  t=source.read_text()
  for match in re.finditer(r'\.\s*'+re.escape(symbol)+r'\s*\(',t):
   ui.append({'path':str(source.relative_to(root)),'line':t.count('\n',0,match.start())+1,'revision':rev})
 if not ui: missing.append((oid,symbol,tree))
 need=re.search(r'(needs\w*)\(middleware\.(Cap\w+)\)',guard)
 scope={'needs':'global:*','needsOnList':'scoped collection; handler filters before count/paging; createAlias checks destination domain','needsOnDomain':'resource domain','needsOnMailbox':'resource mailbox','needsOnAlias':'alias source domain'}
 rules={'scope_rule':scope[need[1]] if need else 'own interactive session; handler validates grant ownership','capability':caps[need[2]] if need else None,'session_only':'middleware.SessionOnly' in guard,'additional_handler_checks':'Consult pinned handler for live grants, CanGrant, 2FA, validation, rate limits and credential ceiling; route gate alone is not complete authorization evidence.'}
 contract=operation_contract(spec,spec['paths'][path],operation)
 link=lambda repository,sha,file,line:f'https://github.com/rest-mail/{repository}/blob/{sha}/{file}#L{line}'
 entry={'operationId':oid,'method':method,'path':path,'server':{'revision':server_rev,'path':'internal/api/routes.go','line':lineno,'link':link('rest-mail-server',server_rev,'internal/api/routes.go',lineno),'guard':guard},'permissions':rules,'declared_security':operation.get('security',[]),'contract':contract,'mobile_client':{'revision':rev,'branch_source':tree,'pull_request':pr,'path':'packages/restmail_api/lib/src/client.dart','line':api['line'],'symbol':symbol,'return_type':api['return_type'],'link':link('rest-mail-mobile',rev,'packages/restmail_api/lib/src/client.dart',api['line']),'literal_json_keys':sorted(set(re.findall(r"'([a-z][a-z0-9_]*)'\s*:",api['fragment'])))},'mobile_ui':[{**u,'link':link('rest-mail-mobile',rev,u['path'],u['line'])} for u in ui],'request_assessment':'needs_field_review','response_assessment':'needs_field_review','ui_runtime_assessment':'requires exact-head Flutter CI evidence','integration_assessment':'Source spans pending PRs; not all branches are on main. The source revision is not a release or deployment claim.','overall_parity':False}
 if oid=='getDashboardStats' and state.get('operation_coverage',{}).get(oid,{}).get('head')==rev:
  entry.update(request_assessment='documented_and_unit_tested',response_assessment='documented_and_unit_tested',field_mapping_document={'revision':rev,'path':'docs/mobile-overview.md'},local_test_evidence=state['overview_parity_progress']['verification'])
 ops.append(entry)
manifest={'schema_version':1,'generated_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'purpose':'Pinned production admin contract and mobile source map; explicit verification backlog, not parity certification.','server_repository':'rest-mail/rest-mail-server','server_revision':server_rev,'server_openapi_path':'openapi.yaml','mobile_repository':'rest-mail/rest-mail-mobile','production_routes':sorted(f'{method} {path}' for method,path in expected),'operations':ops,'limitations':['OpenAPI is a declared contract; opaque success shapes are reported and still require handler/DTO comparison.','Literal JSON keys and UI call sites are lexical discovery only, not proof every field is wired or every screen works.','Source revisions span feature PRs; integration, scope correctness and exact-head CI must be verified separately.','Scoped API key lifecycle and refresh/auth operations are outside this81-operation admin inventory and remain part of the broader objective.']}
errors=validate(manifest)
if errors: raise SystemExit('\n'.join(errors))
(repo/'docs/admin-api-parity.json').write_text(json.dumps(manifest,indent=2,default=str)+'\n')
print('MISSING_UI',missing)
print('VALIDATION',validate(manifest))
print(json.dumps(report(manifest),indent=2))
