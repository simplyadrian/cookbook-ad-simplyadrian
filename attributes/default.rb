# Domain Name
default['ad-nativex']['name'] = 'teamfreeze.com'
# OU
default['ad-nativex']['ou'] = 'Computer Account'
# OUPath
case node['aws']['region']
when 'us-east-1'
	then default['ad-nativex']['oupath'] = "OU=Windows,OU=#{node['aws']['region']},OU=AWS Servers,OU=Computer Accounts,DC=teamfreeze,DC=com"
when 'us-west-1'
	then default['ad-nativex']['oupath'] = "OU=Windows,OU=#{node['aws']['region']},OU=AWS Servers,OU=Computer Accounts,DC=teamfreeze,DC=com"
when 'us-west-2'
	then default['ad-nativex']['oupath'] = "OU=Windows,OU=#{node['aws']['region']},OU=AWS Servers,OU=Computer Accounts,DC=teamfreeze,DC=com"
else
	puts "Unknown region or OU"
end
# Site Name
default['ad-nativex']['site_name'] = 'AMAZON'
# Safe Mode Password
default['ad-nativex']['safe_mode_pass'] = 'Passw0rd'
# AD User
default['ad-nativex']['ad_username'] = 'nil'
# AD Password
default['ad-nativex']['ad_password'] = 'nil'
