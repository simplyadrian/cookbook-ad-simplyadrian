# Kerberos Key Distribution Center (KDC) servers. In a standard Windows domain, typically these are your DCs
default['ad-nativex']['krb5']['kdc_servers'] = []

# SSSD krb5 configuration options
default['ad-nativex']['krb5']['krb5_realm'] = node['ad-nativex']['name'].upcase
default['ad-nativex']['krb5']['dns_lookup'] = false
