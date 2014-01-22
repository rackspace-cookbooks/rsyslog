#
# Cookbook Name:: rsyslog
# Attributes:: default
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

default[:rackspace_rsyslog][:config][:log_dir]                   = '/srv/rsyslog'
default[:rackspace_rsyslog][:config][:server]                    = false
default[:rackspace_rsyslog][:config][:use_relp]                  = false
default[:rackspace_rsyslog][:config][:relp_port]                 = 20_514
default[:rackspace_rsyslog][:config][:protocol]                  = 'tcp'
default[:rackspace_rsyslog][:config][:port]                      = 514
default[:rackspace_rsyslog][:config][:server_ip]                 = nil
default[:rackspace_rsyslog][:config][:server_search]             = 'role:loghost'
default[:rackspace_rsyslog][:config][:remote_logs]               = true
default[:rackspace_rsyslog][:config][:per_host_dir]              = '%$YEAR%/%$MONTH%/%$DAY%/%HOSTNAME%'
default[:rackspace_rsyslog][:config][:max_message_size]          = '2k'
default[:rackspace_rsyslog][:config][:preserve_fqdn]             = 'off'
default[:rackspace_rsyslog][:config][:high_precision_timestamps] = false
default[:rackspace_rsyslog][:config][:repeated_msg_reduction]    = 'on'
default[:rackspace_rsyslog][:config][:logs_to_forward]           = '*.*'
default[:rackspace_rsyslog][:enable_imklog]                      = true
default[:rackspace_rsyslog][:config][:config_prefix]             = '/etc'

# The most likely platform-specific attributes
default[:rackspace_rsyslog][:service_name]                       = 'rsyslog'
default[:rackspace_rsyslog][:config][:user]                      = 'root'
default[:rackspace_rsyslog][:config][:group]                     = 'adm'
default[:rackspace_rsyslog][:config][:priv_seperation]           = false
default[:rackspace_rsyslog][:config][:modules]                   = %w(imuxsock imklog)

# 50-default template attributes

default[:rackspace_rsyslog][:config][:default_log_dir] = '/var/log'
case node[:platform_family]
when 'rhel'
  # format { facility => destination }
  default[:rackspace_rsyslog][:config][:default_facility_logs] = {
    '*.info;mail.none;authpriv.none;cron.none' => "#{node[:rackspace_rsyslog][:config][:default_log_dir]}/messages",
    'authpriv' => "#{node[:rackspace_rsyslog][:config][:default_log_dir]}/secure",
    'mail.*' => "-#{node[:rackspace_rsyslog][:config][:default_log_dir]}/maillog",
    'cron.*' => "#{node[:rackspace_rsyslog][:config][:default_log_dir]}/cron",
    '*.emerg' => '*',
    'uucp,news.crit' => "#{node[:rackspace_rsyslog][:config][:default_log_dir]}/spooler",
    'local7.' => "#{node[:rackspace_rsyslog][:config][:default_log_dir]}/boot.log"
  }
else
  # format { facility => destination }
  default[:rackspace_rsyslog][:config][:default_facility_logs] = {
    'auth,authpriv.*' => "#{node[:rackspace_rsyslog][:config][:default_log_dir]}/auth.log",
    '*.*;auth,authpriv.none' => "-#{node[:rackspace_rsyslog][:config][:default_log_dir]}/syslog",
    'daemon.*' => "-#{node[:rackspace_rsyslog][:config][:default_log_dir]}/daemon.log",
    'kern.*' => "-#{node[:rackspace_rsyslog][:config][:default_log_dir]}/kern.log",
    'mail.*' => "-#{node[:rackspace_rsyslog][:config][:default_log_dir]}/mail.log",
    'user.*' => "-#{node[:rackspace_rsyslog][:config][:default_log_dir]}/user.log",
    'mail.info' => "-#{node[:rackspace_rsyslog][:config][:default_log_dir]}/mail.info",
    'mail.warn' => "-#{node[:rackspace_rsyslog][:config][:default_log_dir]}/mail.warn",
    'mail.err' => "#{node[:rackspace_rsyslog][:config][:default_log_dir]}/mail.err",
    'news.crit' => "#{node[:rackspace_rsyslog][:config][:default_log_dir]}/news/news.crit",
    'news.err' => "#{node[:rackspace_rsyslog][:config][:default_log_dir]}/news/news.err",
    'news.notice' => "-#{node[:rackspace_rsyslog][:config][:default_log_dir]}/news/news.notice",
    '*.=debug;auth,authpriv.none;news.none;mail.none' => "-#{node[:rackspace_rsyslog][:config][:default_log_dir]}/debug",
    '*.=info;*.=notice;*.=warn;auth,authpriv.none;cron,daemon.none;mail,news.none' => "-#{node[:rackspace_rsyslog][:config][:default_log_dir]}/messages",
    '*.emerg' => '*',
    'daemon.*;mail.*;news.err;*.=debug;*.=info;*.=notice;*.=warn' => '|/dev/xconsole'
  }
end
