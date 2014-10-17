#
# Cookbook Name:: ad-nativex
# Recipe:: promotetodomaincontroller
#
# Copyright 2014, NativeX
#
# All rights reserved - Do Not Redistribute
#



# Promote to Domain Controller
ad = Chef::EncryptedDataBagItem.load("credentials", "ad")
nativex_ad_domaincontroller "#{node['ad-nativex']['name']}" do
  action :create
  type "replica" 
  domain_pass ad["ad_password"]
  domain_user ad["ad_username"]
  site_name "#{node['ad-nativex']['site_name']}"
  safe_mode_pass "#{node['ad-nativex']['safe_mode_pass']}"
end

