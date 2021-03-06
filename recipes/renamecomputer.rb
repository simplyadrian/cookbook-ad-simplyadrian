#
# Cookbook Name:: ad-simplyadrian
# Recipe:: renamecomputer 
#
# Copyright 2014, simplyadrian
#
# All rights reserved - Do Not Redistribute
#

# Reboot server to commit changes
include_recipe 'windows::reboot_handler'
node.default[:windows][:allow_pending_reboots] = false

# rename computer
creds = Chef::EncryptedDataBagItem.load("credentials", "ad")
ad_simplyadrian_rename "#{node.name}" do
  action :rename
  domain_pass creds["ad_password"]
  domain_user creds["ad_username"]
  hostname "#{node.name}"
  notifies :request, 'windows_reboot[60]', :delayed
  not_if {"#{node.name}" == node['hostname']} 
end 

windows_reboot 60 do
  timeout 60
  reason 'Opscode Chef initiated reboot. Restarting computer in 60 seconds!'
  action :nothing
end

