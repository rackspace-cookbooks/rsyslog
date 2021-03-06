#
# Cookbook Name:: rackspace_rsyslog
# Recipe:: default
#
# Copyright 2009-2013, Opscode, Inc.
# Copyright 2014, Rackspace, US Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package 'rsyslog'
package 'rsyslog-relp' if node['rackspace_rsyslog']['config']['use_relp']

directory "#{node['rackspace_rsyslog']['config']['config_prefix']}/rsyslog.d" do
  owner 'root'
  group 'root'
  mode  '0755'
end

directory '/var/spool/rsyslog' do
  owner 'root'
  group 'root'
  mode  '0755'
end

# Our main stub which then does its own rsyslog-specific
# include of things in /etc/rsyslog.d/*
template "#{node['rackspace_rsyslog']['config']['config_prefix']}/rsyslog.conf" do
  cookbook node['rackspace_rsyslog']['templates']['rsyslog.conf']
  source  'rsyslog.conf.erb'
  owner   'root'
  group   'root'
  mode    '0644'
  notifies :restart, "service[#{node['rackspace_rsyslog']['service_name']}]"
end

template "#{node['rackspace_rsyslog']['config']['config_prefix']}/rsyslog.d/50-default.conf" do
  cookbook node['rackspace_rsyslog']['templates']['50-default.conf']
  source  '50-default.conf.erb'
  owner   'root'
  group   'root'
  mode    '0644'
  notifies :restart, "service[#{node['rackspace_rsyslog']['service_name']}]"
end

service node['rackspace_rsyslog']['service_name'] do
  supports restart: true, reload: true, status: true
  action   [:enable, :start]
end
