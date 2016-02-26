# puppet-redis-statsd-reporter

[![Build Status](https://travis-ci.org/andyroyle/puppet-redis-statsd-reporter.png)](https://travis-ci.org/andyroyle/puppet-redis-statsd-reporter) [![Puppet Forge](http://img.shields.io/puppetforge/v/andyroyle/redis-statsd-reporter.svg?style=flat)](https://forge.puppetlabs.com/andyroyle/redis-statsd-reporter)

## Description

This Puppet module will install [redis-statsd-reporter](https://github.com/andyroyle/puppet-redis-statsd-reporter/) on Debian or RedHat.

## Installation

`puppet module install --modulepath /path/to/puppet/modules andyroyle-redis-statsd-reporter`

## Requirements

This module assumes nodejs & npm is installed on the host, but will not do it for you. I recommend using [puppet/nodejs](https://github.com/puppet-community/puppet-nodejs) to set this up.

## Usage
```puppet
    class { 'redis-statsd-reporter':
      servers => [
        {
          host => 'my.redis.1.domain.com',
          port => 6379,                 # default 6379
          tags => {                     # tags are only supported by influxdb backend
            foo => 'bar'
          },
          prefix => 'foo.bar.redis.yay' # prefix to apply to the metric name
        }
      ],
      statsd => {
        host: 'localhost',
        port: 8125,
        interval => 10 # interval in seconds to send metrics
      }
    }
```

## Testing

```
bundle install
bundle exec librarian-puppet install
vagrant up
```

## Custom Nodejs Environment

Use the `$environment` parameter to add custom environment variables or run scripts in the `/etc/default/redis-statsd-reporter` file:

```
class { 'redis-statsd-reporter':
  # ...
  environment  => [
    'PATH=/opt/my/path:$PATH',
  ]
}
```

## This looks familiar
Module structure largely copy-pasted from [puppet-statsd](https://github.com/justindowning/puppet-statsd)
