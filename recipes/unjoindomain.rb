#
# Cookbook Name:: ad-nativex
# Recipe:: unjoindomain
#
# Copyright 2014, NativeX
#
# All rights reserved - Do Not Redistribute
#

# Unjoin teamfreeze.com domain
creds = Chef::EncryptedDataBagItem.load("credentials", "ad")
ad_nativex_domain "#{node['ad-nativex']['name']}" do
  action :unjoin
  retries 3
  retry_delay 60
  domain_pass creds["ad_password"]
  domain_user creds["ad_username"]
end
