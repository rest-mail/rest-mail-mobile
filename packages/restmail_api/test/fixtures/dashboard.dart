// DashboardStats, QueueStats, MessageVolumeData, RecentActivity and
// InboundTransportSecurity from server internal/api/handlers/stats.go.
const dashboardFixture = <String, Object?>{
  'domainCount': 7,
  'mailboxCount': 13,
  'queueStats': {'pending': 17, 'processing': 3, 'failed': 2},
  'messageVolume': [
    {'date': 'Oct 22', 'count': 91},
    {'date': 'Oct 23', 'count': 42},
  ],
  'recentActivity': [
    {
      'id': 'domain-31',
      'type': 'domain_created',
      'description':
          'Domain mail.for-a-long-organisation.example.test was created',
      'timestamp': '2026-10-23T04:00:00Z',
    },
  ],
  'inboundTransportSecurity': {
    'totalInboundMX': 120,
    'overTLS': 101,
    'plaintext': 19,
    'tlsPercent': 84.2,
    'plaintextPercent': 15.8,
    'plaintextAuthPass': 11,
    'plaintextAuthFail': 8,
  },
};
