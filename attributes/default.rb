# Domain Name
default['ad-nativex']['name'] = 'teamfreeze.com'
# OU individual components
default['ad-nativex']['domain_component_level_0'] = 'com'
default['ad-nativex']['domain_component_level_1'] = 'teamfreeze'
default['ad-nativex']['organizational_unit_level_0'] = 'Computer Accounts'
default['ad-nativex']['organizational_unit_level_1'] = 'AWS Servers'
default['ad-nativex']['organizational_unit_level_2'] = 'UnknownRegion'
default['ad-nativex']['organizational_unit_level_3'] = 'Windows'
default['ad-nativex']['organizational_unit_level_4'] = "#{node['environment']}"
default['ad-nativex']['organizational_unit_level_5'] = 'One Off Servers'
# OUPath
default['ad-nativex']['oupath'] = "OU=#{node['ad-nativex']['organizational_unit_level_5']},"\
                                  "OU=#{node['ad-nativex']['organizational_unit_level_4']},"\
                                  "OU=#{node['ad-nativex']['organizational_unit_level_3']},"\
                                  "OU=#{node['ad-nativex']['organizational_unit_level_2']},"\
                                  "OU=#{node['ad-nativex']['organizational_unit_level_1']},"\
                                  "OU=#{node['ad-nativex']['organizational_unit_level_0']},"\
                                  "DC=#{node['ad-nativex']['domain_component_level_1']},"\
                                  "DC=#{node['ad-nativex']['domain_component_level_0']}"
# Site Name
default['ad-nativex']['site_name'] = 'AMAZON'
# Safe Mode Password
default['ad-nativex']['safe_mode_pass'] = 'Passw0rd'
# AD User
default['ad-nativex']['ad_username'] = 'nil'
# AD Password
default['ad-nativex']['ad_password'] = 'nil'
