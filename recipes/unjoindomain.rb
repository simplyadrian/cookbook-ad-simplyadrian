#
# Cookbook Name:: nativex-ad
# Recipe:: unjoindomain
#
# Copyright 2014, NativeX
#
# All rights reserved - Do Not Redistribute
#

# Unjoin teamfreeze.com domain
ad = Chef::EncryptedDataBagItem.load("credentials", "ad")
nativex_ad_domain "#{node['nativex-ad']['name']}" do
  action :unjoin
  retries 3
  retry_delay 60
  domain_pass ad["ad_password"]
  domain_user ad["ad_username"]
end
