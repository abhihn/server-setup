package "ntp" do
  action :install
end

service "ntpd" do
  action :start
end

execute "chkconfig ntpd on" do
  command "chkconfig ntpd on"
end