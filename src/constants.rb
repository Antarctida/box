# Default Port Forwarding
PHALCON_DEFAULT_PORTS = [
  { guest: 80,     host: 8000 },
  { guest: 443,    host: 44_300 },
  { guest: 3306,   host: 33_060 },
  { guest: 5432,   host: 54_320 },
  { guest: 8025,   host: 8025 },
  { guest: 27_017, host: 27_017 }
].freeze

PHALCON_DEFAULT_IP = '192.168.50.4'.freeze

PHALCON_DEFAULT_PROVIDER = 'virtualbox'.freeze

PHALCON_VERSION = '2.0.0'.freeze

PHALCON_BOX_VERSION = '1.0.1'.freeze
