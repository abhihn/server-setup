Server Setup
=============

A Chef CookBook for doing a base line server setup for web applications in Qwinix.

Here are the steps one should follow to try this cookbook.

Step 1: Spin Up a CentOS Node
=============================

We need to spin up the target server node to run all of our cookbooks.

1. Open https://learn.getchef.com/

On Left side of the page, you will see Windows Server, Ubuntu and Chef Fundamental Series.

2. Click on "Red Hat Enterprise Linux / CentOS"

3. Click on "Launch a CentOS Virtual Machine" under the Get a "Linux machine" heading

This will open up a new tab where you will see "Your dedicated hands-on environment is just a click away."

3. Click on "Start Using This Environment".

This button will highlight only when the server is ready for you.

Step 2: Login to the server
=============================

Now you will see something like this :

CentOS 6.5 Server
Description: OS: CentOS 6.5 x64
Spec: 16 GB HD / 1 GB RAM
OS: Linux
State:  Running
More details
View VM

1. Click More Details

VM Details
External Address: uvo11okm8lv9qcu0ueh.vm.cld.sr  Click to copy to clipboard
Internal IP:
10.160.34.98
Total Memory: 1024 MB
Disk Size:  16 GB
CPU:  1
The machine was prepared in 14 seconds
Credentials (show password)
Auto-login: root (local user)
Username: root
Password: ******

Click on the show password
you can also revert the whole VM if you want to wipe of everything and come back to the initial stage.

Login to the server

ssh root@uvo11okm8lv9qcu0ueh.vm.cld.sr
Enter Password

Step 3: Bootstrap the newly created node.

knife bootstrap uvo1sg5d4fxjfb8amsb.vm.cld.sr --sudo -x root -P Lo1CNOge3F -N kpv-node

options:

-x root means bootstrap as user root
-P is the password
-N is the node name (node name is required when you add the run list), no resitrictions on the name, put anything.

Now go to https://manage.opscode.com/organizations/qwinix-learning/nodes and you will see the newly bootstrapped node.


Step 4:

Upload the cookbook you have in your repo to the chef node server
knife cookbook upload qwinix-app-setup

Step 5:

We need to create a runlist on our chef node
knife node run_list add kpv-node qwinix-app-setup





The chef-repo
===============
All installations require a central workspace known as the chef-repo. This is a place where primitive objects--cookbooks, roles, environments, data bags, and chef-repo configuration files--are stored and managed.

The chef-repo should be kept under version control, such as [git](http://git-scm.org), and then managed as if it were source code.

Knife Configuration
-------------------
Knife is the [command line interface](http://docs.getchef.com/knife.html) for Chef. The chef-repo contains a .chef directory (which is a hidden directory by default) in which the Knife configuration file (knife.rb) is located. This file contains configuration settings for the chef-repo.

The knife.rb file is automatically created by the starter kit. This file can be customized to support configuration settings used by [cloud provider options](http://docs.getchef.com/plugin_knife.html) and custom [knife plugins](http://docs.getchef.com/plugin_knife_custom.html).

Also located inside the .chef directory are .pem files, which contain private keys used to authenticate requests made to the Chef server. The USERNAME.pem file contains a private key unique to the user (and should never be shared with anyone). The ORGANIZATION-validator.pem file contains a private key that is global to the entire organization (and is used by all nodes and workstations that send requests to the Chef server).

More information about knife.rb configuration options can be found in [the documentation for knife](http://docs.getchef.com/config_rb_knife.html).

Cookbooks
---------
A cookbook is the fundamental unit of configuration and policy distribution. A sample cookbook can be found in `cookbooks/starter`. After making changes to any cookbook, you must upload it to the Chef server using knife:

    $ knife upload cookbooks/starter

For more information about cookbooks, see the example files in the `starter` cookbook.

Roles
-----
Roles provide logical grouping of cookbooks and other roles. A sample role can be found at `roles/starter.rb`.

Getting Started
-------------------------
Now that you have the chef-repo ready to go, check out [Learn Chef](https://learn.getchef.com/) to proceed with your workstation setup. If you have any questions about Chef you can always ask [our support team](https://www.getchef.com/support/tickets/new) for a helping hand.
