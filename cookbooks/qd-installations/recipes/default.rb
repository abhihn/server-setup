# Cookbook Name:: qd-installations
# Recipe:: default
# Copyright 2014, Qwinix Technologies Pvt Ltd
# All rights reserved - do Not Redistribute

# ------------------------
# Yum Update
# ------------------------

execute 'yum -y update'

# ------------------------
# Install Common Utilities
# ------------------------

# Install Wget
package 'wget' do
  action :install
end

# Installing Logwatch
package 'logwatch' do
  action :install
end

# Installing Git
package "git" do
  action :install
end

# Installing GCC and other dependancies
package "gcc" do
  action :install
end

package "make" do
  action :install
end

package "libcurl-devel" do
  action :install
end

package "gcc-c++" do
  action :install
end