#
# Cookbook Name:: ad-nativex
# Recipe:: adjoindomain
#
# Copyright 2014, NativeX
#
# All rights reserved - Do Not Redistribute
#

# If we're in EC2, then need to dynamically determine the the OU based on region
include_recipe 'ad-nativex::dynamic_ou' if node['cloud']['provider'] == 'ec2'

# Reboot server to commit changes
include_recipe 'windows::reboot_handler'
node.default[:windows][:allow_pending_reboots] = false

# Join teamfreeze.com domain
creds = Chef::EncryptedDataBagItem.load("credentials", "ad")
ad_nativex_domain "#{node['ad-nativex']['name']}" do
  action :join
  domain_pass creds["ad_password"]
  domain_user creds["ad_username"]
  oupath lazy { "#{node['ad-nativex']['oupath']}" }
  notifies :request, 'windows_reboot[60]', :delayed
end

windows_reboot 60 do
  timeout 60
  reason 'Opscode Chef initiated reboot. Restarting computer in 60 seconds!'
  action :nothing
end
