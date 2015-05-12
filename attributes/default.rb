# Domain Name
default['ad-simplyadrian']['name'] = 'defaultdomain.com'
# OU individual components
default['ad-simplyadrian']['domain_component_level_0'] = 'com'
default['ad-simplyadrian']['domain_component_level_1'] = 'defaultdomain'
default['ad-simplyadrian']['organizational_unit_level_0'] = 'Computer Accounts'
default['ad-simplyadrian']['organizational_unit_level_1'] = 'AWS Servers'
default['ad-simplyadrian']['organizational_unit_level_2'] = 'UnknownRegion'
default['ad-simplyadrian']['organizational_unit_level_3'] = (node['platform_family'] == 'windows' ? 'Windows' : 'Linux')
default['ad-simplyadrian']['organizational_unit_level_4'] = "#{node.chef_environment.split('-').last.capitalize}"
default['ad-simplyadrian']['organizational_unit_level_5'] = 'One Off Servers'
default['ad-simplyadrian']['organizational_unit_level_6'] = nil
default['ad-simplyadrian']['organizational_unit_level_7'] = nil
# OUPath
default['ad-simplyadrian']['oupath'] = "'OU=#{node['ad-simplyadrian']['organizational_unit_level_5']},"\
                                  "OU=#{node['ad-simplyadrian']['organizational_unit_level_4']},"\
                                  "OU=#{node['ad-simplyadrian']['organizational_unit_level_3']},"\
                                  "OU=#{node['ad-simplyadrian']['organizational_unit_level_2']},"\
                                  "OU=#{node['ad-simplyadrian']['organizational_unit_level_1']},"\
                                  "OU=#{node['ad-simplyadrian']['organizational_unit_level_0']},"\
                                  "DC=#{node['ad-simplyadrian']['domain_component_level_1']},"\
                                  "DC=#{node['ad-simplyadrian']['domain_component_level_0']}'"
# Site Name
default['ad-simplyadrian']['site_name'] = 'AMAZON'
# Safe Mode Password
default['ad-simplyadrian']['safe_mode_pass'] = 'Passw0rd'
# AD User
default['ad-simplyadrian']['ad_username'] = 'nil'
# AD Password
default['ad-simplyadrian']['ad_password'] = 'nil'
