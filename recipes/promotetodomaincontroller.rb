#
# Cookbook Name:: ad-simplyadrian
# Recipe:: promotetodomaincontroller
#
# Copyright 2014, simplyadrian
#
# All rights reserved - Do Not Redistribute
#



# Promote to Domain Controller
creds = Chef::EncryptedDataBagItem.load("credentials", "ad")
ad_simplyadrian_domaincontroller "#{node['ad-simplyadrian']['name']}" do
  action :create
  type "replica" 
  domain_pass creds["ad_password"]
  domain_user creds["ad_username"]
  site_name "#{node['ad-simplyadrian']['site_name']}"
  safe_mode_pass "#{node['ad-simplyadrian']['safe_mode_pass']}"
end

