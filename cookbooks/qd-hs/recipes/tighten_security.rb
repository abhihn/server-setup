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
    file.write_file
  end
end