#
# Cookbook Name:: nativex-ad
# Recipe:: default
#
# Copyright 2014, NativeX
#
# All rights reserved - Do Not Redistribute
#

# Join teamfreeze.com domain

def ad
  {
  :provider => 'AD',
  :ad_username => new_resource.ad_username,
  :ad_password => new_resource.ad_password,
  :ad_session_token => new_resource.ad_session_token
  }
end
