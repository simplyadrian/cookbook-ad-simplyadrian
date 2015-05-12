#
# Cookbook Name:: ad-simplyadrian
# Recipe:: joindomain
#
# Copyright 2014, simplyadrian
#
# All rights reserved - Do Not Redistribute
#

# If we're in EC2, then need to dynamically determine the the OU based on region
include_recipe 'ad-simplyadrian::dynamic_ou'
creds = Chef::EncryptedDataBagItem.load("credentials", "ad")
domain = node['ad-simplyadrian']['name']

if centos?

  if File.directory?('/etc/pbis')
    Chef::Log.error('PBIS is installed, skipping adcli/SSSD domain configuration.')
  else

    package 'adcli'

    include_recipe 'ad-simplyadrian::dynamic_dc'

    # Configure Kerberos
    template '/etc/krb5.conf' do
      source 'krb5.conf.erb'
      action :create
    end

    # Add machine to domain
    ruby_block "Joining the #{domain} domain" do
      block do
        domain_info = `adcli info #{domain}`
        if domain_info.include? domain
          cmd = "echo -n #{creds['ad_password']} | adcli join --domain=#{domain} "\
            "--login-user=#{creds['ad_username'].split('@')[0]}@#{domain.upcase} "\
            "--stdin-password --domain-ou=\"#{node['ad-simplyadrian']['oupath']}\" --show-details"
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
    include_recipe 'ad-simplyadrian::sssd_ldap'

  end

elsif windows?

  # Reboot server to commit changes
  include_recipe 'windows::reboot_handler'
  node.default[:windows][:allow_pending_reboots] = false

  # Join defaultdomain.com domain
  ad_simplyadrian_domain "#{node['ad-simplyadrian']['name']}" do
    action :join
    domain_pass creds["ad_password"]
    domain_user creds["ad_username"]
    oupath lazy { "\"#{node['ad-simplyadrian']['oupath']}\"" }
    notifies :request, 'windows_reboot[60]', :delayed
  end

  windows_reboot 60 do
    timeout 60
    reason 'Opscode Chef initiated reboot. Restarting computer in 60 seconds!'
    action :nothing
  end

end
