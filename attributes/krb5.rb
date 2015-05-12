# Kerberos Key Distribution Center (KDC) servers. In a standard Windows domain, typically these are your DCs
default['ad-simplyadrian']['krb5']['kdc_servers'] = []

# SSSD krb5 configuration options
default['ad-simplyadrian']['krb5']['krb5_realm'] = node['ad-simplyadrian']['name'].upcase
default['ad-simplyadrian']['krb5']['dns_lookup'] = false
