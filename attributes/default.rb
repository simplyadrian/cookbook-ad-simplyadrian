# Domain Name
default['ad-nativex']['name'] = 'teamfreeze.com'
# OU individual components
default['ad-nativex']['domain_component_level_0'] = 'com'
default['ad-nativex']['domain_component_level_1'] = 'teamfreeze'
default['ad-nativex']['organizational_unit_level_0'] = 'Computer Accounts'
default['ad-nativex']['organizational_unit_level_1'] = 'AWS Servers'
default['ad-nativex']['organizational_unit_level_2'] = 'UnknownRegion'
default['ad-nativex']['organizational_unit_level_3'] = (node['platform_family'] == 'windows' ? 'Windows' : 'Linux')
default['ad-nativex']['organizational_unit_level_4'] = "#{node.chef_environment.split('-').last}"
default['ad-nativex']['organizational_unit_level_5'] = 'One Off Servers'
# OUPath
default['ad-nativex']['oupath'] = "'OU=#{node['ad-nativex']['organizational_unit_level_5']},"\
                                  "OU=#{node['ad-nativex']['organizational_unit_level_4']},"\
                                  "OU=#{node['ad-nativex']['organizational_unit_level_3']},"\
                                  "OU=#{node['ad-nativex']['organizational_unit_level_2']},"\
                                  "OU=#{node['ad-nativex']['organizational_unit_level_1']},"\
                                  "OU=#{node['ad-nativex']['organizational_unit_level_0']},"\
                                  "DC=#{node['ad-nativex']['domain_component_level_1']},"\
                                  "DC=#{node['ad-nativex']['domain_component_level_0']}'"
# Site Name
default['ad-nativex']['site_name'] = 'AMAZON'
# Safe Mode Password
default['ad-nativex']['safe_mode_pass'] = 'Passw0rd'
# AD User
default['ad-nativex']['ad_username'] = 'nil'
# AD Password
default['ad-nativex']['ad_password'] = 'nil'
# Override SSSD attributes, set them to nil. If needed, they can be set in a role or environment.
default['sssd_ldap']['ldap_default_bind_dn'] = nil
default['sssd_ldap']['ldap_default_authtok'] = nil
# Kerberos Key Distribution Center (KDC) servers. In a standard Windows domain, typically these are your DCs
default['ad-nativex']['kdc_servers'] = []
# Dynamic DNS SSSD config
default['ad-nativex']['dyndns_update'] = true
default['ad-nativex']['dyndns_refresh_interval'] = 43200
default['ad-nativex']['dyndns_update_ptr'] = true
default['ad-nativex']['dyndns_ttl'] = 3600