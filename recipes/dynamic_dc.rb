#
# Cookbook Name:: ad-simplyadrian
# Recipe:: dynamic_dc
#
# Copyright 2014, simplyadrian
#
# All rights reserved - Do Not Redistribute
#
# Description:: Using domain_Controllers attributes, determine the DC dynamically based on region and set the cookbook attribute value.

ruby_block 'Dynamic Domain Controllers' do
  block do
    if node['ad-simplyadrian']['sssd_ldap']['ad_server'].nil?
      domain_controllers = node['ad-simplyadrian']['domain_controllers']["#{ec2? ? node['aws']['region'] : 'on-premise'}"]
      unless domain_controllers[:primary].nil?
        node.override['ad-simplyadrian']['sssd_ldap']['ad_server'] = domain_controllers[:primary]
        node.override['ad-simplyadrian']['sssd_ldap']['ad_backup_server'] = domain_controllers[:backup] unless domain_controllers[:backup].nil?
      end
    end

    # Configure kdc_servers if they have not already been specified explicitly
    if node['ad-simplyadrian']['krb5']['kdc_servers'].empty?
      domain_controllers = node['ad-simplyadrian']['domain_controllers']["#{ec2? ? node['aws']['region'] : 'on-premise'}"]
      unless domain_controllers[:primary].nil?
        dcs = (domain_controllers[:primary].split(',') + domain_controllers[:backup].split(','))
        dcs.delete('_srv_')
        node.override['ad-simplyadrian']['krb5']['kdc_servers'] = dcs
      end
    end
  end
  action :run
end

