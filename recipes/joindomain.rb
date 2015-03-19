#
# Cookbook Name:: ad-nativex
# Recipe:: joindomain
#
# Copyright 2014, NativeX
#
# All rights reserved - Do Not Redistribute
#

# If we're in EC2, then need to dynamically determine the the OU based on region
include_recipe 'ad-nativex::dynamic_ou' if node['cloud']['provider'] == 'ec2' # TODO: Dynamic OU should support instances outside of ec2
creds = Chef::EncryptedDataBagItem.load("credentials", "ad")
domain = node['ad-nativex']['name']

if centos?

  include_recipe 'sssd_ldap::default'

  package 'adcli' do
    :install
  end

  template '/etc/krb5.conf' do
    source 'krb5.conf.erb'
    action :create
    variables({
                  :krb5_domain => domain,
                  :krb5_kdc_servers => node['ad-nativex']['kdc_servers']
              })
  end

  ruby_block "Joining the #{domain} domain" do
    block do
      domain_info = `adcli info #{domain}`
      if domain_info.include? domain
        cmd = "echo -n #{creds['ad_password']} | adcli join --domain=#{domain} "\
          "--login-user=#{creds['ad_username'].split('@')[0]}@#{domain.upcase} "\
          "--stdin-password --domain-ou=#{node['ad-nativex']['oupath']} --show-details"
        join_domain = `#{cmd}`
        Chef::Log.info(join_domain)
      else
        Chef::Log.error('Could not find domain')
        raise
      end
    end
    action :run
    not_if { `klist -k | head`.include? domain.upcase }
  end

  #include 'policy-nativex'

elsif windows?

  # Reboot server to commit changes
  include_recipe 'windows::reboot_handler'
  node.default[:windows][:allow_pending_reboots] = false

  # Join teamfreeze.com domain
  ad_nativex_domain "#{node['ad-nativex']['name']}" do
    action :join
    domain_pass creds["ad_password"]
    domain_user creds["ad_username"]
    oupath lazy { "#{node['ad-nativex']['oupath']}" }
    notifies :request, 'windows_reboot[60]', :delayed
  end

  windows_reboot 60 do
    timeout 60
    reason 'Opscode Chef initiated reboot. Restarting computer in 60 seconds!'
    action :nothing
  end

end
