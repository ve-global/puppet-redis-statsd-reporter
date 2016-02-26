case $operatingsystem {
  /^(Debian|Ubuntu)$/: { include apt }
  'RedHat', 'CentOS':  { include epel }
  default: { notify { 'unsupported os!': }}
}

class { 'nodejs': manage_package_repo => true, repo_url_suffix => 'node_5.x', }->
class { 'redis_statsd_reporter':
  servers => [
    {
      host   => 'localhost',
      port   => 6379,
      prefix => 'foo.bar.redis.yay',
      tags   => {
        foo => 'bar'
      }
    }
  ],
  statsd  => {
    host     => 'localhost',
    port     => 8125,
    interval => 10
  }
}
