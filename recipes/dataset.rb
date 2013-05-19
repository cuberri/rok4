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

package "unzip"

rok4_dataset_full_url = "#{node['rok4']['url']}/#{node['rok4']['dataset']['archive']}.zip"

# download rok4 sample dataset
remote_file "#{Chef::Config[:file_cache_path]}/#{node['rok4']['dataset']['archive']}.zip" do
    source "#{rok4_dataset_full_url}"
    checksum node['rok4']['dataset']['checksum']
    mode "0644"
end

# note : the dataset layer file provided by IGN contains a badass token
# ('CHEMIN_A_REMPLACER') to be replaced by the actual path to the 
# corresponding .pyr. Hence the ugly sed... :'(
bash "unpack-and-copy-dataset" do
    # not_if { ::File.exists?(node['rok4']['binary']) }
    cwd Chef::Config[:file_cache_path]
    code <<-EOF
    rm -fR dataset && mkdir dataset && cd dataset
    unzip ../#{node['rok4']['dataset']['archive']}
    sed -i s/CHEMIN_A_REMPLACER/./g #{node['rok4']['dataset']['archive']}.lay
    cp -R ./* #{node['rok4']['config']['layer_dir']}
    EOF
end
