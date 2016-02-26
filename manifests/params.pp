# == Class: redis_statsd_reporter::params
class redis_statsd_reporter::params {
  $ensure           = 'present'
  $node_module_dir  = '/usr/lib/node_modules'
  $nodejs_bin       = '/usr/bin/node'
  $environment      = []

  $servers          = []
  $statsd           = { }
  $configdir        = '/etc/redis-statsd-reporter'
  $logfile          = '/var/log/redis-statsd-reporter/redis-statsd-reporter.log'

  $manage_service   = true
  $service_ensure   = 'running'
  $service_enable   = true

  $config           = { }

  $dependencies     = undef

  $package_name     = 'redis-statsd-reporter'
  $package_source   = undef
  $package_provider = 'npm'

  case $::osfamily {
    'RedHat', 'Amazon': {
      $init_location = '/etc/init.d/redis-statsd-reporter'
      $init_mode     = '0755'
      $init_provider = 'redhat'
      $init_script   = 'puppet:///modules/redis_statsd_reporter/reporter-init-rhel'
    }
    'Debian': {
      $init_location = '/etc/init/redis-statsd-reporter.conf'
      $init_mode     = '0644'
      $init_provider = 'upstart'
      $init_script   = 'puppet:///modules/redis_statsd_reporter/reporter-upstart'
    }
    default: {
      fail('Unsupported OS Family')
    }
  }
}
