#
# Cookbook Name:: ad-nativex
# Recipe:: promotetodomaincontroller
#
# Copyright 2014, NativeX
#
# All rights reserved - Do Not Redistribute
#



# Promote to Domain Controller
creds = Chef::EncryptedDataBagItem.load("credentials", "ad")
ad_nativex_domaincontroller "#{node['ad-nativex']['name']}" do
  action :create
  type "replica" 
  domain_pass creds["ad_password"]
  domain_user creds["ad_username"]
  site_name "#{node['ad-nativex']['site_name']}"
  safe_mode_pass "#{node['ad-nativex']['safe_mode_pass']}"
end

