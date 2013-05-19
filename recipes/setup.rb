#
# Author:: Christophe Uberri <cuberri@gmail.com>
# Cookbook Name:: rok4
# Recipe:: setup
#
# Copyright 2013, Christophe Uberri <cuberri@gmail.com>
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

template "#{node['rok4']['config']['server_file']}" do
  source "server.conf.erb"
  mode "0644"
  variables({
    'log_file_prefix'       => node['rok4']['config']['log_file_prefix'],
    'services_config_file'  => node['rok4']['config']['services_file'],
    'layer_dir'             => node['rok4']['config']['layer_dir'],
    'style_dir'             => node['rok4']['config']['style_dir'],
    'tms_dir'               => node['rok4']['config']['tms_dir'],
    'proj_conf_dir'         => node['rok4']['config']['proj_dir'],
    'server_port'           => node['rok4']['config']['server_binding']
  })
end
