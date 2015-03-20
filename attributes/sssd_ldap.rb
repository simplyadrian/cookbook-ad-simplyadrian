default['ad-nativex']['sssd']['id_provider'] = 'ldap'
default['ad-nativex']['sssd']['auth_provider'] = 'ldap'
default['ad-nativex']['sssd']['chpass_provider'] = 'ldap'
default['ad-nativex']['sssd']['sudo_provider'] = 'ldap'
default['ad-nativex']['sssd']['enumerate'] = 'true'
default['ad-nativex']['sssd']['cache_credentials'] = 'false'

default['ad-nativex']['sssd']['ldap_schema'] = 'rfc2307bis'
default['ad-nativex']['sssd']['ldap_uri'] = 'ldap://something.yourcompany.com'
default['ad-nativex']['sssd']['ldap_search_base'] = 'dc=yourcompany,dc=com'
default['ad-nativex']['sssd']['ldap_user_search_base'] = 'ou=People,dc=yourcompany,dc=com'
default['ad-nativex']['sssd']['ldap_user_object_class'] = 'posixAccount'
default['ad-nativex']['sssd']['ldap_user_name'] = 'uid'
default['ad-nativex']['sssd']['override_homedir'] = nil
default['ad-nativex']['sssd']['shell_fallback'] = '/bin/bash'

default['ad-nativex']['sssd']['ldap_group_search_base'] = 'ou=Groups,dc=yourcompany,dc=com'
default['ad-nativex']['sssd']['ldap_group_object_class'] = 'posixGroup'

default['ad-nativex']['sssd']['ldap_id_use_start_tls'] = 'true'
default['ad-nativex']['sssd']['ldap_tls_reqcert'] = 'never'
default['ad-nativex']['sssd']['ldap_tls_cacert'] = value_for_platform_family('rhel' => '/etc/pki/tls/certs/ca-bundle.crt', 'default' => '/etc/ssl/certs/ca-certificates.crt')

# if you have a domain that doesn't require binding set these two attributes to nil
default['ad-nativex']['sssd']['ldap_default_bind_dn'] = 'cn=bindaccount,dc=yourcompany,dc=com'
default['ad-nativex']['sssd']['ldap_default_authtok'] = 'bind_password'

default['ad-nativex']['sssd']['authconfig_params'] = '--enablesssd --enablesssdauth --enablelocauthorize --update'

default['ad-nativex']['sssd']['access_provider'] = nil # Should be set to 'ldap'
default['ad-nativex']['sssd']['ldap_access_filter'] = nil # Can use simple LDAP filter such as 'uid=abc123' or more expressive LDAP filters like '(&(objectClass=employee)(department=ITSupport))'

default['ad-nativex']['sssd']['min_id'] = '1'
default['ad-nativex']['sssd']['max_id'] = '0'
default['ad-nativex']['sssd']['ldap_sudo'] = false