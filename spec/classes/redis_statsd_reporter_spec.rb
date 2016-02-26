require 'spec_helper'

describe 'redis_statsd_reporter', :type => :class do

  ['Debian', 'RedHat'].each do |osfamily|
    context "using #{osfamily}" do
      let(:facts) { {
        :osfamily => osfamily
      } }

      it { should contain_class('redis_statsd_reporter') }
      it { should contain_class('redis_statsd_reporter::params') }
      it { should contain_redis_statsd_reporter__config }
      it { should contain_package('redis_statsd_reporter').with_ensure('present') }
      it { should contain_service('redis-statsd-reporter').with_ensure('running') }
      it { should contain_service('redis-statsd-reporter').with_enable(true) }

      it { should contain_file('/etc/redis-statsd-reporter') }
      it { should contain_file('/etc/redis-statsd-reporter/redis.json') }
      it { should contain_file('/etc/redis-statsd-reporter/statsd.json') }
      it { should contain_file('/etc/default/redis-statsd-reporter') }
      it { should contain_file('/var/log/redis-statsd-reporter') }
      it { should contain_file('/usr/local/sbin/redis-statsd-reporter') }

      if osfamily == 'Debian'
        it { should contain_file('/etc/init/redis-statsd-reporter.conf') }
      end

      if osfamily == 'RedHat'
        it { should contain_file('/etc/init.d/redis-statsd-reporter') }
      end

      describe 'stopping the statsd service' do
	let(:params) {{
	  :service_ensure => 'stopped',
        }}
        it { should contain_service('redis-statsd-reporter').with_ensure('stopped') }
      end

      describe 'disabling the statsd service' do
	let(:params) {{
	  :service_enable => false,
        }}
        it { should contain_service('redis-statsd-reporter').with_enable(false) }
      end

      describe 'disabling the management of the statsd service' do
	let(:params) {{
	  :manage_service => false,
        }}
        it { should_not contain_service('redis-statsd-reporter') }
      end
     end
  end

end
