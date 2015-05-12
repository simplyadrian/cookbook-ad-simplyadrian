#
# Cookbook Name:: ad-simplyadrian
# Recipe:: unjoindomain
#
# Copyright 2014, simplyadrian
#
# All rights reserved - Do Not Redistribute
#
creds = Chef::EncryptedDataBagItem.load("credentials", "ad")
domain = node['ad-simplyadrian']['name']

if centos?

  # Remove machine from domain
  ruby_block "Un-joining the #{domain} domain" do
    block do
      domain_info = `adcli info #{domain}`
      if domain_info.include? domain
        cmd = "echo -n #{creds['ad_password']} | adcli delete-computer --domain=#{domain} "\
          "--login-user=#{creds['ad_username'].split('@')[0]}@#{domain.upcase} --stdin-password"
        unjoin_domain = `#{cmd}`
        Chef::Log.info(unjoin_domain)
      else
        Chef::Log.error('Could not query domain')
        raise
      end
    end
    action :run
    only_if { `klist -k | head`.include? domain.upcase }
  end

  file "/etc/krb5.keytab" do
    action :delete
    only_if { `klist -k | head`.include? domain.upcase }
  end

elsif windows?

  # Unjoin defaultdomain.com domain
  creds = Chef::EncryptedDataBagItem.load("credentials", "ad")
  ad_simplyadrian_domain "#{node['ad-simplyadrian']['name']}" do
    action :unjoin
    retries 3
    retry_delay 60
    domain_pass creds["ad_password"]
    domain_user creds["ad_username"]
  end

end