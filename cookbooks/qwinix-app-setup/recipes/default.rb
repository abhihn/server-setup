# Cookbook Name:: qwinix-app-setup
# Recipe:: default
# Copyright 2014, Qwinix Technologies Pvt Ltd
# All rights reserved - do Not Redistribute
#

# ------------------------
# Yum Update
# ------------------------

execute 'yum ­-y update'

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

# ------------------------
# SELINUX
# ------------------------

# Disable SELINUX enforcement
execute "disable selinux enforcement" do
  only_if "which selinuxenabled && selinuxenabled"
  command "setenforce 0"
  action :run
  notifies :create, "template[/etc/selinux/config]"
end

# create / update the config file
template "/etc/selinux/config" do
  source "selinux/config.erb"
  variables(
    :selinux => "disabled",
    :selinuxtype => "targeted"
  )
  action :nothing
end

# ------------------------
# NTP
# ------------------------

package "ntp" do
  action :install
end

service "ntpd" do
  action :start
end

execute "chkconfig ntpd on" do
  command "chkconfig ntpd on"
end

# ------------------------
# Malware
# ------------------------

# cd /tmp
# wget http://www.rfxn.com/downloads/maldetect-current.tar.gz

maldet_version = node["maldetect"]["version"]
remote_file "#{Chef::Config[:file_cache_path]}/maldetect-current.tar.gz" do
  action :create
  source node["maldetect"]["installation-source-file"]
  checksum node["maldetect"]["checksum"]
  owner "root"
  group "root"
end

# tar xfz maldetect-current.tar.gz
execute "unpack maldetect" do
  cwd Chef::Config[:file_cache_path]
  command "tar xfz maldetect-current.tar.gz"
  not_if {::File.directory?("#{Chef::Config[:file_cache_path]}/maldetect-#{maldet_version}")}
end

# cd maldetect-1.4.1/
# ./install.sh
execute "install maldetect" do
  cwd "#{Chef::Config[:file_cache_path]}/maldetect-1.4.2"
  command "./install.sh"
  # not_if {::File.read("/usr/local/maldetect/VERSION").strip == maldet_version}
end

ruby_block "modify_line" do
  block do
    file = Chef::Util::FileEdit.new("/usr/local/maldetect/conf.maldet")
    file.search_file_replace_line("email_alert=", "email_alert=1")
    file.search_file_replace_line("email_sub=", "email_sub='Malware Detect Alert from $(hostname)'")
    file.search_file_replace_line("email_addr=", "email_addr='root@localhost'")
    file.search_file_replace_line("quar_hits=", "quar_hits=0")
    file.search_file_replace_line("quar_clean=", "quar_clean=1")
    file.write_file
  end
end

# ------------------------
# Aide
# ------------------------

# Install the aide package
package "aide" do
  action :install
end

aide = "/etc/cron.daily/aide"
unless File.exists?(aide)
  file "/etc/cron.daily/aide" do
  owner   "root"
  group   "root"
  action  :create
  # FIXME - Use a template for aide file
  content <<-aide.gsub(/^ {4}/, '')
    #!/bin/bash
    /usr/sbin/aide -C | /bin/mail -s "AIDE report for $(hostname)" root@localhost
    aide
  end
end

aide = "/etc/cron.weekly/aide"
unless File.exists?(aide)
  file "/etc/cron.weekly/aide" do
    owner   "root"
    group   "root"
    action  :create
    content <<-aide.gsub(/^ {4}/, '')
      #!/bin/bash
      /usr/sbin/aide -u | /bin/mail -s "AIDE Database updated on $(hostname)" root@localhost
      cp -p /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
    aide
  end
end

execute "chmod +x /etc/cron.daily/aide"
execute "chmod +x /etc/cron.weekly/aide"

# Database initialization
bash "Configure_AIDE" do
  user "root"
  code <<-EOH
    aide --init
    mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
  EOH
end

# Add job to crontab
ruby_block "add_line_crontab" do
  block do
    file = Chef::Util::FileEdit.new("/etc/crontab")
    file.insert_line_if_no_match("00 20 * * * /usr/sbin/aide --check", "00 20 * * * /usr/sbin/aide --check")
    file.write_file
  end
end

# Install and configure chkrootkit
remote_file "#{Chef::Config[:file_cache_path]}/webtatic_repo_latest.rpm" do
    source "http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
    action :create
end

rpm_package "chkrootkit" do
    source "#{Chef::Config[:file_cache_path]}/webtatic_repo_latest.rpm"
    action :install
end 

package "chkrootkit" do
  action :install
end



chkrootkit = "/etc/cron.daily/chkrootkit"
unless File.exists?(chkrootkit)
file "/etc/cron.daily/chkrootkit" do
owner   "root"
group   "root"
action  :create
content <<-chkrootkit.gsub(/^ {4}/, '')

#!/bin/bash

/usr/sbin/chkrootkit | /bin/mail -s "ChkRootKit report for $(hostname)" root@localhost


 chkrootkit
end
end

execute "chmod +x /etc/cron.daily/chkrootkit"
