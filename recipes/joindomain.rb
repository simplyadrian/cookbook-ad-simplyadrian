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
ad = Chef::EncryptedDataBagItem.load("credentials", "ad")
ad_nativex_domain "#{node['ad-nativex']['name']}" do
  action :join
  domain_pass ad["ad_password"]
  domain_user ad["ad_username"]
  oupath lazy { "#{node['ad-nativex']['oupath']}" }
end

# rename computer
ad = Chef::EncryptedDataBagItem.load("credentials", "ad")
ad_nativex_rename "#{node.name}" do
  action :rename
  domain_pass ad["ad_password"]
  domain_user ad["ad_username"]
  hostname "#{node.name}"
  notifies :request, 'windows_reboot[60]', :delayed
  not_if {"#{node.name}" == node['hostname']}
end

windows_reboot 60 do
  timeout 60
  reason 'Opscode Chef initiated reboot. Restarting computer in 60 seconds!'
  action :nothing
end
