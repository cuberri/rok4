Description
===========

This cookbook installs [rok4](http://www.rok4.org/) (a wms/wmts open-source 
server).

The install process basically follows the directives from the rok4 website.
The sole difference resides in the target install directory which is always 
named with the version being installed. A `current` symlink is then created 
pointing to that version.

Example :

    vagrant@rok4:~$ ls -l /usr/local/rok4
    total 4
    drwxr-xr-x 9 root staff 4096 May 19 02:19 0.13.1
    lrwxrwxrwx 1 root staff   22 May 19 02:19 current -> /usr/local/rok4/0.13.1

Requirements
============

## Platform

* Debian >= 7

**NOTE**

Debian 7 is the unique supported platform so far due to some dependencies 
which resides in the unstable repo on other Debian distros... It was easier 
(and more fun) to bootstrap a Debian 7 than to make Chef updating apt sources :P

Attributes
==========

This cookbook includes many attributes. See `attributes/default.rb` for default 
values.

The most common/useful ones are listed here :

* `node['rok4']['install_method']` - Installation method. Install from source
is the unique way so far but it seems to have a deb/rpm cmake task, so this 
attribute is here just in case. Default `source`

* `node['rok4']['install_dir']` - The location where rok4 will be installed. 
Default `/usr/local/rok4/#{rok4['version']}`

* `node['rok4']['symlink_dir']` - The symlink to be created pointing to the 
rok4 version being installed. Default `/usr/local/rok4/current`

* `node['rok4']['build_rok4']` - Whether to build rok4 or not. It could seem
quite obvious but you can build be4 without rok4 and vice versa. Default `TRUE`

* `node['rok4']['build_be4']` - Whether to build be4 or not. See the previous
note. Default `FALSE`


Recipes
=======

## default

Include the default recipe in a run list to get rok4 installed.

Be aware that rok4 need some configuration tweaks in order to work properly.
If you run rok4 without doing that work, you'd probably get an error such as :

    vagrant@rok4:/usr/local/rok4/0.13.1/bin$ ./rok4
    Starting ROK4 server[27003]
    Chargement des parametres techniques depuis ../config/server.conf
    Can't load the file../config/server.conf
    ERREUR FATALE : Impossible d'interpreter le fichier de configuration du serveur ../config/server.conf

For convenience, the `setup` and `dataset` recipes have been made to provide a 
rok4 complete testing environment.

## setup

This recipe sets up a rok4 configuration based on the attributes defined in 
`attributes/default.rb`. It simply creates the `/usr/local/rok4/current/config/server.conf`
file used by rok4 to bootstrap.

## dataset

This recipe copies a dataset archive from the [rok4](http://www.rok4.org) website 
and extracts it accordingly to the rok4 config parameters.

**Important note on the default configured dataset**

As it is mentioned on the [rok4](http://www.rok4.org) website :

> Il s’agit d’un jeu de données issu du SCAN 1000® de l’IGN en projection 
> Lambert 93 et compressé en JPEG. Ces données ne peuvent être utilisées 
> pour un usage commercial.

For the non-french readers :P, that means the dataset is derived from a 
copyrighted IGN product, and it **can not** be used for commercial purposes.

Usage
=====

Simply include the `rok4` recipe where you would like rok4 installed.

## chef-solo sample

    run_list(
      "recipe[rok4]"
    )

## vagrant example with rok4 setup and dataset creation

A complete Vagrantfile example :

    # Vagrantfile
    Vagrant::Config.run do |config|
      config.vm.box = "debian70"

      config.vm.host_name = "rok4"

      config.vm.forward_port 22, 2223

      # plugin : https://github.com/dotless-de/vagrant-vbguest
      config.vbguest.auto_update = true
      config.vbguest.no_remote = true

      config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = ["./cookbooks"]
        chef.add_recipe "rok4-tests"
      end
    end

The rok4-tests recipe basically include rok4 ones :

    # rok4-tests.rb
    include_recipe "rok4"
    include_recipe "rok4::setup"
    include_recipe "rok4::dataset"



Development
===========

* rok4 is being developed by IGN (Institut National de l'Information Géographique 
et Forestière). See [rok4 website](http://www.rok4.org/) for details.

* this cookbook has been made to ease rok4 development and testing on a Vagrant 
box. Some work is to be done to test the cookbook itself and to support more 
platforms. Feel free to contribute, I can't imagine I'm the one guy who plays 
with rok4... oh wait... :D

License and Author
==================

* Author: Christophe Uberri (<cuberri@gmail.com>)

Copyright: 2013, Christophe Uberri

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
