#
# Cookbook Name:: ad-nativex
# Recipe:: dynamic_dc
#
# Copyright 2014, NativeX
#
# All rights reserved - Do Not Redistribute
#
# Description:: Using domain_Controllers attributes, determine the DC dynamically based on region and set the cookbook attribute value.

ruby_block 'Dynamic Domain Controllers' do
  block do
    if node['ad-nativex']['sssd_ldap']['ad_server'].nil?
      domain_controllers =
          node['ad-nativex']['domain_controllers']["#{node['cloud']['provider'] == 'ec2' ? node['aws']['region'] : 'on-premise'}"]
      unless domain_controllers[:primary].nil?
        node.override['ad-nativex']['sssd_ldap']['ad_server'] = domain_controllers[:primary]
        node.override['ad-nativex']['sssd_ldap']['ad_backup_server'] = domain_controllers[:backup] unless domain_controllers[:backup].nil?
      end
    end

    # Configure kdc_servers if they have not already been specified explicitly
    if node['ad-nativex']['krb5']['kdc_servers'].empty?
      domain_controllers =
          node['ad-nativex']['domain_controllers']["#{node['cloud']['provider'] == 'ec2' ? node['aws']['region'] : 'on-premise'}"]
      unless domain_controllers[:primary].nil?
        dcs = (domain_controllers[:primary].split(',') + domain_controllers[:backup].split(','))
        dcs.delete('_srv_')
        node.override['ad-nativex']['krb5']['kdc_servers'] = dcs
      end
    end
  end
  action :run
end

