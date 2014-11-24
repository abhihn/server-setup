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