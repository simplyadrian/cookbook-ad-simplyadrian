#
# Cookbook Name:: ad-nativex
# Recipe:: dynamic_ou 
#
# Copyright 2014, NativeX
#
# All rights reserved - Do Not Redistribute
#
# Description:: Using Ohai (ohai-nativex) attributes, determine the OU dynamically based on region, and set the cookbook attribute value.

## NOT SURE IF WE REALLY NEED THIS
include_recipe "ohai-nativex::default" if node['cloud']['provider'] == 'ec2'

ruby_block "determine_ec2_region_and_set_ou" do
  block do
    if node['aws']['region']
      node.default['ad-nativex']['oupath'] = "OU=Windows,OU=#{node['aws']['region']},OU=AWS Servers,OU=Computer Accounts,DC=teamfreeze,DC=com"
      Chef::Log.debug("Set ['ad-nativex']['oupath'] to OU=Windows,OU=#{node['aws']['region']},OU=AWS Servers,OU=Computer Accounts,DC=teamfreeze,DC=com")
    else
      Chef::Log.warn("Undefined AWS region! Cannot automatically set the proper OU.")
    end
  end
  action :run
  only_if { node['cloud']['provider'] == 'ec2' }
end
