ruby_block "insert_line_if_no_match" do
  block do
    file = Chef::Util::FileEdit.new("/etc/ssh/sshd_config")
    file.insert_line_if_no_match("ListenAddress 0.0.0.0", "ListenAddress        0.0.0.0")
    file.insert_line_if_no_match("PermitRootLogin no", "PermitRootLogin no")
    file.write_file
  end
end