# == Class redis_statsd_reporter
class redis_statsd_reporter (
  $ensure           = $redis_statsd_reporter::params::ensure,
  $node_module_dir  = $redis_statsd_reporter::params::node_module_dir,
  $nodejs_bin       = $redis_statsd_reporter::params::nodejs_bin,
  $environment      = $redis_statsd_reporter::params::environment,

  $servers          = $redis_statsd_reporter::params::servers,
  $statsd           = $redis_statsd_reporter::params::statsd,
  $configdir        = $redis_statsd_reporter::params::configdir,
  $logfile          = $redis_statsd_reporter::params::logfile,

  $manage_service   = $redis_statsd_reporter::params::manage_service,
  $service_ensure   = $redis_statsd_reporter::params::service_ensure,
  $service_enable   = $redis_statsd_reporter::params::service_enable,

  $config           = $redis_statsd_reporter::params::config,

  $init_location    = $redis_statsd_reporter::params::init_location,
  $init_mode        = $redis_statsd_reporter::params::init_mode,
  $init_provider    = $redis_statsd_reporter::params::init_provider,
  $init_script      = $redis_statsd_reporter::params::init_script,

  $package_name     = $redis_statsd_reporter::params::package_name,
  $package_source   = $redis_statsd_reporter::params::package_source,
  $package_provider = $redis_statsd_reporter::params::package_provider,

  $dependencies     = $redis_statsd_reporter::params::dependencies,
) inherits redis_statsd_reporter::params {

  if $dependencies {
    $dependencies -> Class['redis_statsd_reporter']
  }

  class { 'redis_statsd_reporter::config': }

  package { 'redis_statsd_reporter':
    ensure   => $ensure,
    name     => $package_name,
    provider => $package_provider,
    source   => $package_source
  }

  if $manage_service == true {
    service { 'redis-statsd-reporter':
      ensure    => $service_ensure,
      enable    => $service_enable,
      hasstatus => true,
      provider  => $init_provider,
      subscribe => Class['redis_statsd_reporter::config'],
      require   => [
        Package['redis_statsd_reporter'],
        File['/var/log/redis-statsd-reporter']
      ],
    }
  }
}
