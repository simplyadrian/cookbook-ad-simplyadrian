default['ad-nativex']['sssd_ldap']['id_provider'] = 'ad'
default['ad-nativex']['sssd_ldap']['auth_provider'] = 'ldap'
default['ad-nativex']['sssd_ldap']['chpass_provider'] = 'ldap'
default['ad-nativex']['sssd_ldap']['sudo_provider'] = 'ldap'
default['ad-nativex']['sssd_ldap']['enumerate'] = 'true'
default['ad-nativex']['sssd_ldap']['cache_credentials'] = 'true'

default['ad-nativex']['sssd_ldap']['ldap_schema'] = 'rfc2307bis'
default['ad-nativex']['sssd_ldap']['ldap_uri'] = 'ldap://something.yourcompany.com'
default['ad-nativex']['sssd_ldap']['ldap_search_base'] = 'dc=yourcompany,dc=com'
default['ad-nativex']['sssd_ldap']['ldap_user_search_base'] = 'ou=People,dc=yourcompany,dc=com'
default['ad-nativex']['sssd_ldap']['ldap_user_object_class'] = 'user'
default['ad-nativex']['sssd_ldap']['ldap_user_name'] = 'sAMAccountName'
default['ad-nativex']['sssd_ldap']['ldap_id_mapping'] = true # Set to false to use POSIX attributes on the AD side
default['ad-nativex']['sssd_ldap']['override_homedir'] = nil
default['ad-nativex']['sssd_ldap']['shell_fallback'] = '/bin/bash'

default['ad-nativex']['sssd_ldap']['ldap_group_search_base'] = 'ou=Groups,dc=yourcompany,dc=com'
default['ad-nativex']['sssd_ldap']['ldap_group_object_class'] = 'group'

default['ad-nativex']['sssd_ldap']['ldap_id_use_start_tls'] = 'false'
default['ad-nativex']['sssd_ldap']['ldap_tls_reqcert'] = 'never'
default['ad-nativex']['sssd_ldap']['ldap_tls_cacert'] = value_for_platform_family(
                                                          'rhel' => '/etc/pki/tls/certs/ca-bundle.crt',
                                                          'default' => '/etc/ssl/certs/ca-certificates.crt'
                                                        )
# If you have a domain that doesn't require binding set these two attributes to nil
default['ad-nativex']['sssd_ldap']['ldap_default_bind_dn'] = nil
default['ad-nativex']['sssd_ldap']['ldap_default_authtok'] = nil

default['ad-nativex']['sssd_ldap']['authconfig_params'] = '--enablesssd --enablesssdauth --enablelocauthorize '\
                                                            '--enablemkhomedir --update'

# Can use simple LDAP filter such as 'uid=abc123' or more expressive LDAP filters
# like '(&(objectClass=employee)(department=ITSupport))'
default['ad-nativex']['sssd_ldap']['access_provider'] = nil # 'ad', 'ldap', or 'krb5'
default['ad-nativex']['sssd_ldap']['ldap_access_filter'] = nil

default['ad-nativex']['sssd_ldap']['min_id'] = '1'
default['ad-nativex']['sssd_ldap']['max_id'] = '0'
default['ad-nativex']['sssd_ldap']['ldap_sudo'] = false

# Dynamic DNS config
default['ad-nativex']['sssd_ldap']['dyndns_update'] = true
default['ad-nativex']['sssd_ldap']['dyndns_refresh_interval'] = 43200
default['ad-nativex']['sssd_ldap']['dyndns_update_ptr'] = true
default['ad-nativex']['sssd_ldap']['dyndns_ttl'] = 3600

# Debug
default['ad-nativex']['sssd_ldap']['debug_level'] = 5 # TODO: Change to 0
