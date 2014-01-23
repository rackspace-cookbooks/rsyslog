require 'spec_helper'

describe 'rackspace_rsyslog::default' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04').converge('rackspace_rsyslog::default')
  end

  let(:service_resource) { 'service[rsyslog]' }

  it 'installs the rsyslog part' do
    expect(chef_run).to install_package('rsyslog')
  end

  context "when node[:rackspace_rsyslog'][:config][:relp] is true" do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.set['rackspace_rsyslog']['config']['use_relp'] = true
      end.converge('rackspace_rsyslog::default')
    end

    it 'installs the rsyslog-relp package' do
      expect(chef_run).to install_package('rsyslog-relp')
    end
  end

  context '/etc/rsyslog.d directory' do
    let(:directory) { chef_run.directory('/etc/rsyslog.d') }

    it 'creates the directory' do
      expect(chef_run).to create_directory(directory.path)
    end

    it 'is owned by root:root' do
      expect(directory.owner).to eq('root')
      expect(directory.group).to eq('root')
    end

    it 'has 0755 permissions' do
      expect(directory.mode).to eq('0755')
    end

  end

  context '/var/spool/rsyslog directory' do
    let(:directory) { chef_run.directory('/var/spool/rsyslog') }

    it 'creates the directory' do
      expect(chef_run).to create_directory('/var/spool/rsyslog')
    end

    it 'is owned by root:root' do
      expect(directory.owner).to eq('root')
      expect(directory.group).to eq('root')
    end

    it 'has 0755 permissions' do
      expect(directory.mode).to eq('0755')
    end
  end

  context '/etc/rsyslog.conf template' do
    let(:template) { chef_run.template('/etc/rsyslog.conf') }
    let(:modules) { %w(imuxsock imklog) }

    it 'creates the template' do
      expect(chef_run).to render_file(template.path).with_content('Configuration file for rsyslog v3')
    end

    it 'is owned by root:root' do
      expect(template.owner).to eq('root')
      expect(template.group).to eq('root')
    end

    it 'has 0644 permissions' do
      expect(template.mode).to eq('0644')
    end

    it 'notifies restarting the service' do
      expect(template).to notify(service_resource).to(:restart)
    end

    it 'includes the right modules' do
      modules.each do |mod|
        expect(chef_run).to render_file(template.path).with_content(/^\$ModLoad #{mod}/)
      end
    end

  end

  context '/etc/rsyslog.d/50-default.conf template' do
    let(:template) { chef_run.template('/etc/rsyslog.d/50-default.conf') }

    it 'creates the template' do
      expect(chef_run).to render_file('/etc/rsyslog.d/50-default.conf').with_content('*.emerg    *')
    end

    it 'is owned by root:root' do
      expect(template.owner).to eq('root')
      expect(template.group).to eq('root')
    end

    it 'has 0644 permissions' do
      expect(template.mode).to eq('0644')
    end

    it 'notifies restarting the service' do
      expect(template).to notify(service_resource).to(:restart)
    end

  end

  context 'COOK-3608 maillog regression test' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'redhat', version: '6.3').converge('rackspace_rsyslog::default')
    end

    it 'outputs mail.* to /var/log/maillog' do
      expect(chef_run).to render_file('/etc/rsyslog.d/50-default.conf').with_content('mail.*    -/var/log/maillog')
    end
  end

  context 'rsyslog service' do
    it 'starts and enables the service' do
      expect(chef_run).to enable_service('rsyslog')
    end
  end
end
