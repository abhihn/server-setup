# See http://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "kpvarma"
client_key               "#{current_dir}/kpvarma.pem"
validation_client_name   "qwinix-learning-validator"
validation_key           "#{current_dir}/qwinix-learning-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/qwinix-learning"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]

# AWS settings
knife[:aws_access_key_id] = "AKIAJZCW7QCNF5M2HFVQ"
knife[:aws_secret_access_key] = "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"
knife[:flavor] = "q4SJ8ravQYVIXdeIzFLap3BqFkUlTpL4z1YATqu0"
knife[:image] = "q4SJ8ravQYVIXdeIzFLap3BqFkUlTpL4z1YATqu0"
knife[:availability_zone] = "q4SJ8ravQYVIXdeIzFLap3BqFkUlTpL4z1YATqu0"
knife[:region] = "q4SJ8ravQYVIXdeIzFLap3BqFkUlTpL4z1YATqu0"
knife[:distro] = "q4SJ8ravQYVIXdeIzFLap3BqFkUlTpL4z1YATqu0"
knife[:template_file] = "q4SJ8ravQYVIXdeIzFLap3BqFkUlTpL4z1YATqu0"
