# == Class: redis_statsd_reporter::config
class redis_statsd_reporter::config (
  $servers                           = $redis_statsd_reporter::servers,
  $statsd                            = $redis_statsd_reporter::statsd,
  $configdir                         = $redis_statsd_reporter::configdir,
  $config                            = $redis_statsd_reporter::config,

  $environment = $redis_statsd_reporter::environment,
  $nodejs_bin  = $redis_statsd_reporter::nodejs_bin,
  $reporterjs  = "${redis_statsd_reporter::node_module_dir}/redis-statsd-reporter/index.js",
  $logfile     = $redis_statsd_reporter::logfile,
) {

  file { $configdir:
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }->
  file { "${configdir}/redis.json":
    content => template('redis_statsd_reporter/redis.json.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }->
  file { "${configdir}/statsd.json":
    content => template('redis_statsd_reporter/statsd.json.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }

  file { $redis_statsd_reporter::init_location:
    source => $redis_statsd_reporter::init_script,
    mode   => $redis_statsd_reporter::init_mode,
    owner  => 'root',
    group  => 'root',
  }

  file {  '/etc/default/redis-statsd-reporter':
    content => template('redis_statsd_reporter/reporter-defaults.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/var/log/redis-statsd-reporter':
    ensure => directory,
    mode   => '0755',
    owner  => 'nobody',
    group  => 'root',
  }

  file { '/usr/local/sbin/redis-statsd-reporter':
    source => 'puppet:///modules/redis_statsd_reporter/reporter-wrapper',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

}
