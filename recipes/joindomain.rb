#
# Cookbook Name:: ad-nativex
# Recipe:: joindomain
#
# Copyright 2014, NativeX
#
# All rights reserved - Do Not Redistribute
#

# If we're in EC2, then need to dynamically determine the the OU based on region
include_recipe 'ad-nativex::dynamic_ou'
creds = Chef::EncryptedDataBagItem.load("credentials", "ad")
domain = node['ad-nativex']['name']

if centos?

  package 'adcli'

  # Configure Kerberos
  template '/etc/krb5.conf' do
    source 'krb5.conf.erb'
    action :create
    variables({
      :krb5_domain => domain,
      :krb5_kdc_servers => node['ad-nativex']['krb5']['kdc_servers']
    })
  end

  # And machine to domain
  ruby_block "Joining the #{domain} domain" do
    block do
      domain_info = `adcli info #{domain}`
      if domain_info.include? domain
        cmd = "echo -n #{creds['ad_password']} | adcli join --domain=#{domain} "\
          "--login-user=#{creds['ad_username'].split('@')[0]}@#{domain.upcase} "\
          "--stdin-password --domain-ou=\"#{node['ad-nativex']['oupath']}\" --show-details"
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

  # Enable create home directory on logon
  package 'oddjob-mkhomedir'
  service 'oddjobd' do
    action [:enable, :start]
  end

  # Configure SSSD
  include_recipe 'ad-nativex::sssd_ldap'

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
