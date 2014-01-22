require 'spec_helper'

describe 'rackspace_rsyslog::client' do
  context 'when node[:rackspace_rsyslog][:config][:server_ip] is not set' do
    before do
      Chef::Log.stub(:fatal)
      $stdout.stub(:puts)
    end

    it 'exits fatally' do
      expect { ChefSpec::Runner.new.converge('rackspace_rsyslog::client') }.to raise_error(SystemExit)
    end
  end

  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set[:rackspace_rsyslog][:config][:server_ip] = server_ip
    end.converge('rackspace_rsyslog::client')
  end

  let(:server_ip) { "10.#{rand(1..9)}.#{rand(1..9)}.50" }
  let(:service_resource) { 'service[rsyslog]' }

  it 'includes the default recipe' do
    expect(chef_run).to include_recipe('rackspace_rsyslog::default')
  end

  context '/etc/rsyslog.d/49-remote.conf template' do
    let(:template) { chef_run.template('/etc/rsyslog.d/49-remote.conf') }

    it 'creates the template' do
      expect(chef_run).to render_file(template.path).with_content("*.* @@#{server_ip}:514")
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

  context '/etc/rsyslog.d/server.conf file' do
    let(:file) { chef_run.file('/etc/rsyslog.d/server.conf') }

    it 'deletes the file' do
      expect(chef_run).to delete_file(file.path)
    end

    it 'notifies restarting the service' do
      expect(file).to notify(service_resource).to(:reload)
    end

  end
end
