#
# Cookbook Name:: ad-nativex
# Recipe:: sssd_ldap
#
# Copyright 2013-2014, Limelight Networks, Inc.
# Used under the Apache License, Version 2.0. Modified for NativeX
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Original works: https://github.com/tas50/chef-sssd_ldap
#

package 'sssd' do
  action :install
end

package 'libsss-sudo' do
  package_name value_for_platform(
                   'debian' => { '< 8.0' => 'libsss-sudo0' },
                   'ubuntu' => { '< 13.04' => 'libsss-sudo0' }
               )

  action :install
  only_if { platform_family?('debian') && node['ad-nativex']['sssd_ldap']['ldap_sudo'] }
end

# Only run on RHEL
if platform_family?('rhel')

  # authconfig allows cli based intelligent manipulation of the pam.d files
  package 'authconfig' do
    action :install
  end

  # https://bugzilla.redhat.com/show_bug.cgi?id=975082
  ruby_block 'nsswitch sudoers' do
    block do
      edit = Chef::Util::FileEdit.new '/etc/nsswitch.conf'
      edit.insert_line_if_no_match(/^sudoers:/, 'sudoers: files')

      if node['ad-nativex']['sssd_ldap']['ldap_sudo']
        # Add sss to the line if it's not there.
        edit.search_file_replace(/^sudoers:([ \t]*(?!sss\b)\w+)*[ \t]*$/, '\0 sss')
      else
        # Remove sss from the line if it is there.
        edit.search_file_replace(/^(sudoers:.*)\bsss[ \t]*/, '\1')
      end

      edit.write_file
    end

    action :nothing
  end

  # Have authconfig enable SSSD in the pam files
  execute 'authconfig' do
    command "authconfig #{node['ad-nativex']['sssd_ldap']['authconfig_params']}"
    notifies :run, 'ruby_block[nsswitch sudoers]', :immediately
    action :nothing
  end
end

# sssd automatically modifies the PAM files with pam-auth-update and /etc/nsswitch.conf, so all that's left is to configure /etc/sssd/sssd.conf
template '/etc/sssd/sssd.conf' do
  source 'sssd.conf.erb'
  owner 'root'
  group 'root'
  mode '0600'

  if platform_family?('rhel')
    # this needs to run immediately so it doesn't happen after sssd
    # service block below, or sssd won't start when recipe completes
    notifies :run, 'execute[authconfig]', :immediately
  end

  notifies :restart, 'service[sssd]'
end

# NSCD and SSSD don't play well together.
# https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/usingnscd-sssd.html
package 'nscd' do
  action :remove
end

service 'sssd' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart if node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 13.04
end
