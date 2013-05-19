#
# Author:: Christophe Uberri <cuberri@gmail.com>
# Cookbook Name:: rok4
# Recipe:: default
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

#-------------------------------------------------------------------------------
# ROK4 INSTALL
#-------------------------------------------------------------------------------

# only source install is supported so far
# TODO : deb/rpm based
default['rok4']['install_method'] = 'source'

default['rok4']['url']      = 'http://www.rok4.org/data/'
default['rok4']['version']  = '0.13.1'
default['rok4']['checksum'] = '75de560a2a6f6d1d4aad7030c413d068369140de137684310addb3674cf8d541'

default['rok4']['symlink_dir'] = "/usr/local/rok4/current"
default['rok4']['install_dir'] = "/usr/local/rok4/#{rok4['version']}"
default['rok4']['binary']      = "#{rok4['install_dir']}/bin/rok4"
default['rok4']['build_rok4']  = 'TRUE'
default['rok4']['build_be4']   = 'FALSE'
default['rok4']['unittest']    = 'FALSE'
default['rok4']['build_type']  = 'Release'
default['rok4']['debug_build'] = 'FALSE'
default['rok4']['generator']   = 'Unix Makefiles' # http://www.cmake.org/cmake/help/cmake2.6docs.html#section_Generators

# cmake options      : http://www.cmake.org/Wiki/CMake_Useful_Variables
# rok4 build options : http://www.rok4.org/documentation/rok4-installation
default['rok4']['cmake_options'] = [
    "-G \"#{rok4['generator']}\"",
    "-DCMAKE_INSTALL_PREFIX=#{rok4['install_dir']}",
    "-DCMAKE_BUILD_TYPE=#{rok4['build_type']}",
    "-DBUILD_ROK4=#{rok4['build_rok4']}",
    "-DBUILD_BE4=#{rok4['build_be4']}",
    "-DUNITTEST=#{rok4['unittest']}",
    "-DDEBUG_BUILD=#{rok4['debug_build']}"
]

#-------------------------------------------------------------------------------
# ROK4 DEFAULT CONFIG
#-------------------------------------------------------------------------------
default['rok4']['config']['server_file']     = "#{rok4['symlink_dir']}/config/server.conf"
default['rok4']['config']['services_file']   = "#{rok4['symlink_dir']}/config/services.conf"
default['rok4']['config']['layer_dir']       = "#{rok4['symlink_dir']}/config/layers"
default['rok4']['config']['style_dir']       = "#{rok4['symlink_dir']}/config/styles"
default['rok4']['config']['tms_dir']         = "#{rok4['symlink_dir']}/config/tileMatrixSet"
default['rok4']['config']['proj_dir']        = "#{rok4['symlink_dir']}/config/proj"
default['rok4']['config']['server_binding']  = ":9000"
default['rok4']['config']['log_file_prefix'] = "/var/tmp/rok4"

#-------------------------------------------------------------------------------
# ROK4 SAMPLE DATASET
#-------------------------------------------------------------------------------

default['rok4']['dataset']['archive']  = 'SCAN1000_JPG_LAMB93_FXX'
default['rok4']['dataset']['checksum'] = '67e7f9e4b4d260da9733559252e1c9d35b7c25fb4f95f9c4bb2a9ba993430062'
