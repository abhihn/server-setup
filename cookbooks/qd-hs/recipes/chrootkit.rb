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