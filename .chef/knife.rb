# See http://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "tponnambalam"
client_key               "#{current_dir}/tponnambalam.pem"
validation_client_name   "tsandbox-validator"
validation_key           "#{current_dir}/tsandbox-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/tsandbox"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]


<<<<<<< HEAD
# AWS settings
#knife[:aws_access_key_id] = "AKIAJZCW7QCNF5M2HFVQ"
#knife[:aws_secret_access_key] = "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"
#knife[:flavor] = "q4SJ8ravQYVIXdeIzFLap3BqFkUlTpL4z1YATqu0"
#knife[:image] = "q4SJ8ravQYVIXdeIzFLap3BqFkUlTpL4z1YATqu0"
#knife[:availability_zone] = "q4SJ8ravQYVIXdeIzFLap3BqFkUlTpL4z1YATqu0"
#knife[:region] = "q4SJ8ravQYVIXdeIzFLap3BqFkUlTpL4z1YATqu0"
#knife[:distro] = "q4SJ8ravQYVIXdeIzFLap3BqFkUlTpL4z1YATqu0"
#knife[:template_file] = "q4SJ8ravQYVIXdeIzFLap3BqFkUlTpL4z1YATqu0"
=======
>>>>>>> master
