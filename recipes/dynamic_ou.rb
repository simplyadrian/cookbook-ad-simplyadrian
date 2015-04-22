#
# Cookbook Name:: ad-nativex
# Recipe:: dynamic_ou 
#
# Copyright 2014, NativeX
#
# All rights reserved - Do Not Redistribute
#
# Description:: Using ohai-nativex attributes, determine the OU dynamically based on region and set the cookbook attribute value.

include_recipe "ohai-nativex::default" if ec2?

if ec2?

  ruby_block 'Machine is EC2, determine region and OU' do
    block do
      if node['aws']['region']
        node.default['ad-nativex']['organizational_unit_level_2'] = node['aws']['region'].upcase
        oupath = "OU=#{node['ad-nativex']['organizational_unit_level_5']},"\
                    "OU=#{node['ad-nativex']['organizational_unit_level_4']},"\
                    "OU=#{node['ad-nativex']['organizational_unit_level_3']},"\
                    "OU=#{node['ad-nativex']['organizational_unit_level_2']},"\
                    "OU=#{node['ad-nativex']['organizational_unit_level_1']},"\
                    "OU=#{node['ad-nativex']['organizational_unit_level_0']},"\
                    "DC=#{node['ad-nativex']['domain_component_level_1']},"\
                    "DC=#{node['ad-nativex']['domain_component_level_0']}"
        oupath.insert(0, "OU=#{node['ad-nativex']['organizational_unit_level_6']},") unless
            node['ad-nativex']['organizational_unit_level_6'].nil?
        oupath.insert(0, "OU=#{node['ad-nativex']['organizational_unit_level_7']},") unless
            node['ad-nativex']['organizational_unit_level_7'].nil?
        node.default['ad-nativex']['oupath'] = oupath
        Chef::Log.info("Set ['ad-nativex']['oupath'] to #{oupath}")
      else
        Chef::Log.warn('Undefined AWS region! Cannot automatically set the proper OU.')
      end
    end
    action :run
  end

else

  # TODO: Remove hardcoded values if cookbook is open sourced.
  ruby_block 'Machine is on-premise determining OU based on hostname' do
    block do
      ou_level_1 = ou_level_2 = ou_level_3 = false
      hostname = node['hostname'].upcase
      unless windows?
        node.default['ad-nativex']['organizational_unit_level_2'] = 'Linux'
        ou_level_2 = true
      end
      if hostname.include? 'CHD'
        node.default['ad-nativex']['organizational_unit_level_1'] = 'CHD Servers'
        ou_level_1 = true
        if hostname[0,1] == 'D'
          if windows?
            node.default['ad-nativex']['organizational_unit_level_2'] = 'Development Servers'
            ou_level_2 = true
          else
            node.default['ad-nativex']['organizational_unit_level_3'] = 'DevServers'
            ou_level_3 = true
          end
        elsif hostname[0,1] == 'P'
          if window?
            node.default['ad-nativex']['organizational_unit_level_2'] = 'Application Servers'
            ou_level_2 = true
          else
            node.default['ad-nativex']['organizational_unit_level_3'] = 'One Off Servers'
            ou_level_3 = true
          end
        end
      elsif hostname.include? 'SHO'
        node.default['ad-nativex']['organizational_unit_level_1'] = 'SHO Servers'
        ou_level_1 = true
      else
        Chef::Log.warn('Cannot automatically set the proper OU. Using failback OU.')
        ou_level_2 = false
      end
      oupath = "OU=#{node['ad-nativex']['organizational_unit_level_0']},"\
                  "DC=#{node['ad-nativex']['domain_component_level_1']},"\
                  "DC=#{node['ad-nativex']['domain_component_level_0']}"
      oupath.insert(0, "OU=#{node['ad-nativex']['organizational_unit_level_1']},") if ou_level_1
      oupath.insert(0, "OU=#{node['ad-nativex']['organizational_unit_level_2']},") if ou_level_2
      oupath.insert(0, "OU=#{node['ad-nativex']['organizational_unit_level_3']},") if ou_level_3
      node.default['ad-nativex']['oupath'] = oupath
      Chef::Log.info("Set ['ad-nativex']['oupath'] to #{oupath}")
    end
    action :run
  end

end
