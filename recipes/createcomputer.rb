#
# Cookbook Name:: ad-nativex
# Recipe:: createcomputer 
#
# Copyright 2014, NativeX
#
# All rights reserved - Do Not Redistribute
#

# Create computer "workstation1" in the Computers OU with description of "Computer"
ad = Chef::EncryptedDataBagItem.load("credentials", "ad")
nativex_ad_computer node['hostname'] do
  action :create
  domain_name "#{node['ad-nativex']['name']}"
  ou "#{node['ad-nativex']['ou']}"
  options ({ "desc" => node['fqdn'], "u" => ad["ad_username"], "p" => ad["ad_password"]})
end
