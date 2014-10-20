# Cookbook Name:: qwinix-app-setup
# Recipe:: default
# Copyright 2014, Qwinix Technologies Pvt Ltd
# All rights reserved - do Not Redistribute
#

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


# ------------------------
# CHKROOTKIT
# ------------------------

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

# ------------------------
# POSTFIX
# ------------------------

# Default mail server in linux

ruby_block "replace_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/postfix/main.cf")
    file.search_file_replace_line("inet_interfaces =", "inet_interfaces = localhost")
    file.search_file_replace_line("inet_protocols =", "inet_protocols = ipv4")
    file.search_file_replace_line("relayhost =", "aspmx.l.google.com:25")
    file.write_file
  end
end

file "/root/.forward" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create_if_missing
end

ruby_block "add_line" do
  block do
    file = Chef::Util::FileEdit.new("/root/.forward")
    file.insert_line_if_no_match("root@qwinixtech.com", "root@qwinixtech.com")
    file.write_file
  end
end

# Enable Auto start
execute "chkconfig postfix on"

# Start Postfix mail daemon
execute "service postfix start"

# Cookbook Name:: audit installation module

package "audit" do
  action :install
end

ruby_block "insert_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/logrotate.d/syslog")
    file.insert_line_if_no_match("/var/log/audit/audit.log", "/var/log/audit/audit.log")

# Cookbook Name:: banner

file "/etc/motd" do
owner   "root"
group   "root"
action  :create
content <<-MOTD.gsub(/^ {4}/, '')

==========================^[[1;32mW A R N I N G^[[0m=======================================
This computer system is the property of the Qwinix Inc. It is for authorized use only. 
Unauthorized or improper use of this system may result in administrative disciplinary 
action and/or civil charges/criminal penalties. By continuing to use this system you 
indicate your awareness of and consent to these terms and conditions of use.

LOG OFF IMMEDIATELY if you do not agree to the conditions stated in this warning.
=======================================================================================

  MOTD
end

file "/etc/issue" do
owner   "root"
group   "root"
action  :create
content <<-MOTD.gsub(/^ {4}/, '')

==============================^[[1;32mW A R N I N G^[[0m===============================
This computer system is the property of the Qwinix Inc. It is for authorized use only. 
Unauthorized or improper use of this system may result in administrative disciplinary 
action and/or civil charges/criminal penalties. By continuing to use this system you 
indicate your awareness of and consent to these terms and conditions of use.

LOG OFF IMMEDIATELY if you do not agree to the conditions stated in this warning.
=======================================================================================


  MOTD
end

file "/etc/issue.net" do
owner   "root"
group   "root"
action  :create
content <<-MOTD.gsub(/^ {4}/, '')

==============================^[[1;32mW A R N I N G^[[0m==============================
This computer system is the property of the Qwinix Inc. It is for authorized use only. 
Unauthorized or improper use of this system may result in administrative disciplinary 
action and/or civil charges/criminal penalties. By continuing to use this system you 
indicate your awareness of and consent to these terms and conditions of use.

LOG OFF IMMEDIATELY if you do not agree to the conditions stated in this warning.
======================================================================================

  MOTD
#Updating the Bash-Doc

execute "yum -y update bash"
# ------------------------
# Creating USERS and GROUP
# ------------------------
# Create deploy user

user "deploy" do
supports :manage_home => true
comment "Deploy User"
home "/home/deploy"
shell "/bin/bash"
password "$1$CBtdXK6u$jXiDMrjjuv2EeRnGxhyl/1"
end

# Create deploy group

group "deploy" do
action :create
members "deploy"
append true
end

# Create or update sudoers file.

template "/etc/sudoers" do
source "sudoers.erb"
mode '0440'
owner 'root'
group 'root'
variables({
:sudoers_groups => node[:authorization][:sudo][:groups],
:sudoers_users => node[:authorization][:sudo][:users]
})
# Disable Services
# ------------------------

ruby_block "modify_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/sysctl.conf")
    file.insert_line_if_no_match("# Disable ipv6", "# Disable ipv6")
    file.insert_line_if_no_match("net.ipv6.conf.all.disable_ipv6 = 1", "net.ipv6.conf.all.disable_ipv6 = 1")
    file.insert_line_if_no_match("net.ipv6.conf.default.disable_ipv6 = 1", "net.ipv6.conf.default.disable_ipv6 = 1")
    file.insert_line_if_no_match("# Disable response to ping", "# Disable response to ping")
    file.insert_line_if_no_match("net.ipv4.icmp_echo_ignore_all = 1", "net.ipv4.icmp_echo_ignore_all = 1")
    file.insert_line_if_no_match("# Disable response to broadcasts", "# Disable response to broadcasts")
    file.insert_line_if_no_match("net.ipv4.icmp_echo_ignore_broadcasts = 1", "net.ipv4.icmp_echo_ignore_broadcasts = 1")
    file.insert_line_if_no_match("# Enable bad error message protection", "# Enable bad error message protection")
    file.insert_line_if_no_match("net.ipv4.icmp_ignore_bogus_error_responses = 1", "net.ipv4.icmp_ignore_bogus_error_responses = 1")
    file.insert_line_if_no_match("# Don't accept source routed packets", "# Don't accept source routed packets")
    file.insert_line_if_no_match("net.ipv4.conf.all.accept_source_route = 0", "net.ipv4.conf.all.accept_source_route = 0")
    file.insert_line_if_no_match("# Disable ICMP redirect acceptance", "# Disable ICMP redirect acceptance")
    file.insert_line_if_no_match("net.ipv4.conf.all.accept_redirects = 0", "net.ipv4.conf.all.accept_redirects = 0")
    file.insert_line_if_no_match("# Log spoofed packets, source routed packets, redirect packets", "# Log spoofed packets, source routed packets, redirect packets")
    file.insert_line_if_no_match("net.ipv4.conf.all.log_martians = 1", "net.ipv4.conf.all.log_martians = 1")

#Change ssh config
ruby_block "insert_line_if_no_match" do
  block do
    file = Chef::Util::FileEdit.new("/etc/ssh/sshd_config")
    file.insert_line_if_no_match("ListenAddress 0.0.0.0", "ListenAddress 0.0.0.0")
    file.insert_line_if_no_match("PermitRootLogin no", "PermitRootLogin no")
    file.write_file
  end
end

ruby_block "comment_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/audit/audit.rules")
    file.search_file_replace_line("-D", "# -D")
#Chnage Password policy

ruby_block "modify line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/login.defs")
    file.search_file_replace_line("PASS_MAX_DAYS  99999", "PASS_MAX_DAYS   30")
    file.search_file_replace_line("PASS_MIN_DAYS  0", "PASS_MIN_DAYS   7")
    file.search_file_replace_line("PASS_MIN_LEN 5", "PASS_MIN_LEN    10")
    file.search_file_replace_line("PASS_WARN_AGE  7", "PASS_WARN_AGE   7")
file.write_file
  end
end



ruby_block "modify line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/pam.d/password-auth")
    file.search_file_replace_line("password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok", "password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=13")
    file.search_file_replace_line("password    required      pam_deny.so", "password    required     pam_cracklib.so retry=2 minlen=10 difok=6 dcredit=1 ucredit=1 lcredit=1 ocredit=1")
    file.write_file
  end
end

ruby_block "replace_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/anacrontab")
    file.search_file_replace_line("START_HOURS_RANGE=", "START_HOURS_RANGE=0-5")
    file.write_file
  end

ruby_block "insert_line_if_no_match" do
  block do
    file = Chef::Util::FileEdit.new("/etc/pam.d/system-auth")
    file.insert_line_if_no_match("auth        required      pam_tally2.so  file=/var/log/tallylog deny=3 unlock_time=1200", "auth        required      pam_tally2.so  file=/var/log/tallylog deny=3 unlock_time=1200")
    file.insert_line_if_no_match("account     required      pam_tally2.so", "account     required      pam_tally2.so")
    file.write_file
  end
end
