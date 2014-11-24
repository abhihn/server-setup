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


ruby_block "insert_line_if_no_match" do
  block do
    file = Chef::Util::FileEdit.new("/etc/pam.d/system-auth")
    file.insert_line_if_no_match("auth        required      pam_tally2.so         file=/var/log/tallylog deny=3 unlock_time=1200", "auth        required      pam_tally2.so  file=/var/log/tallylog deny=3 unlock_time=1200")
    file.insert_line_if_no_match("account     required      pam_tally2.so", "account     required      pam_tally2.so")
    file.write_file
  end
end