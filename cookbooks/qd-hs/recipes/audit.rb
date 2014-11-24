package "audit" do
  action :install
end

ruby_block "insert_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/logrotate.d/syslog")
    file.insert_line_if_no_match("/var/log/audit/audit.log", "/var/log/audit/audit.log")
    file.write_file
  end
end

ruby_block "comment_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/audit/audit.rules")
    file.search_file_replace_line("-D", "# -D")
    file.write_file
  end
end

ruby_block "replace_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/anacrontab")
    file.search_file_replace_line("START_HOURS_RANGE=", "START_HOURS_RANGE=0-5")
    file.write_file
  end
end