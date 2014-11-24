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