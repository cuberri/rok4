#
# Author:: Christophe Uberri <cuberri@gmail.com>
# Cookbook Name:: rok4
# Recipe:: source
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

# rok4 build deps
rok4_dev_packages = %w{build-essential gettext nasm automake cmake}

# be4 build deps
# be4_dev_packages = %w{...}
# todo : probably depends on cpan recipes to manage perl and co

rok4_dev_packages.each do |dev_pkg|
    package dev_pkg
end

# set some vars for convenience
cmake_options = node['rok4']['cmake_options'].join(" ")
version = node['rok4']['version']
rok4_archive = "rok4-#{version}.tar.bz2"
rok4_full_url = "#{node['rok4']['url']}/#{rok4_archive}"
rok4_symlink_dir = node['rok4']['symlink_dir']
rok4_install_dir = node['rok4']['install_dir']

# download rok4
remote_file "#{Chef::Config[:file_cache_path]}/#{rok4_archive}" do
    not_if { ::File.exists?(node['rok4']['binary']) }
    source "#{rok4_full_url}"
    checksum node['rok4']['checksum']
    mode "0644"
end

# rok4 build doc : http://www.rok4.org/documentation/rok4-installation
bash "build-and-install-rok4" do
    not_if { ::File.exists?(node['rok4']['binary']) }
    cwd Chef::Config[:file_cache_path]
    code <<-EOF
    rm -fR rok4
    tar -jxf #{rok4_archive}
    cd rok4 && mkdir build && cd build
    cmake .. #{cmake_options} && make && make install
    EOF
end

link "#{node['rok4']['symlink_dir']}" do
    to "#{node['rok4']['install_dir']}"
end
