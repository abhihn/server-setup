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