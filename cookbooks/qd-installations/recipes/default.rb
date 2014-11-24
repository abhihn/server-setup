# Cookbook Name:: qd-installations
# Recipe:: default
# Copyright 2014, Qwinix Technologies Pvt Ltd
# All rights reserved - do Not Redistribute

# Yum Update
execute 'yum -y update'

# Bash Update
execute "yum -y update bash"

# ------------------------
# Apex Folder
# ------------------------

# Configuring the apex folder for putting all the applications
directory "/apps" do
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  not_if { Dir.exist?("/apps") }
end