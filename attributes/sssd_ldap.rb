default['ad-simplyadrian']['sssd_ldap']['authconfig_params'] = '--enablesssd --enablesssdauth --enablelocauthorize '\
                                                            '--enablemkhomedir --enablekrb5 --update'
default['ad-simplyadrian']['sssd_ldap']['pam'] = {
    :reconnection_retries => 3,
    :offline_credentials_expiration => 2,
    :offline_failed_login_attempts => 3,
    :offline_failed_login_delay => 15
}

default['ad-simplyadrian']['sssd_ldap']['id_provider'] = 'ad' # Change to 'ldap' if ad fails
default['ad-simplyadrian']['sssd_ldap']['auth_provider'] = 'ad' # Change to 'krb5' if ad fails
default['ad-simplyadrian']['sssd_ldap']['chpass_provider'] = 'ad' # Change to 'krb5' if ad fails
default['ad-simplyadrian']['sssd_ldap']['sudo_provider'] = 'ad' # Change to 'ldap' if ad fails
default['ad-simplyadrian']['sssd_ldap']['cache_credentials'] = true
default['ad-simplyadrian']['sssd_ldap']['enumerate'] = true

default['ad-simplyadrian']['sssd_ldap']['ldap_schema'] = 'ad'
default['ad-simplyadrian']['sssd_ldap']['ldap_uri'] = 'ldap://something.yourcompany.com'
default['ad-simplyadrian']['sssd_ldap']['ad_server'] = nil # Optional, if not specified sssd, will use DNS for lookup
default['ad-simplyadrian']['sssd_ldap']['ad_backup_server'] = nil # Optional, ad_server must be specified first
default['ad-simplyadrian']['sssd_ldap']['ad_hostname'] = nil # Optional

default['ad-simplyadrian']['sssd_ldap']['ldap_tls_reqcert'] = 'never'
default['ad-simplyadrian']['sssd_ldap']['ldap_tls_cacert'] = value_for_platform_family(
                                                            'rhel' => '/etc/pki/tls/certs/ca-bundle.crt',
                                                            'default' => '/etc/ssl/certs/ca-certificates.crt'
                                                        )
default['ad-simplyadrian']['sssd_ldap']['ldap_id_use_start_tls'] = false
default['ad-simplyadrian']['sssd_ldap']['ldap_force_upper_case_realm'] = true

default['ad-simplyadrian']['sssd_ldap']['ldap_search_base'] = 'dc=yourcompany,dc=com'
default['ad-simplyadrian']['sssd_ldap']['ldap_user_search_base'] = 'ou=People,dc=yourcompany,dc=com'
default['ad-simplyadrian']['sssd_ldap']['ldap_user_object_class'] = 'user'
default['ad-simplyadrian']['sssd_ldap']['ldap_user_name'] = 'sAMAccountName'
default['ad-simplyadrian']['sssd_ldap']['ldap_id_mapping'] = true # Set to false to use POSIX attributes on the AD side
default['ad-simplyadrian']['sssd_ldap']['override_homedir'] = nil
default['ad-simplyadrian']['sssd_ldap']['shell_fallback'] = '/bin/bash'

default['ad-simplyadrian']['sssd_ldap']['ldap_group_search_base'] = 'ou=Groups,dc=yourcompany,dc=com'
default['ad-simplyadrian']['sssd_ldap']['ldap_group_object_class'] = 'group'

# If you have a domain that doesn't require binding set these two attributes to nil
default['ad-simplyadrian']['sssd_ldap']['ldap_default_bind_dn'] = nil
default['ad-simplyadrian']['sssd_ldap']['ldap_default_authtok'] = nil

# Can use simple LDAP filter such as 'uid=abc123' or more expressive LDAP filters
# like '(&(objectClass=employee)(department=ITSupport))'
default['ad-simplyadrian']['sssd_ldap']['access_provider'] = 'ad' # 'ad', 'ldap', or 'krb5'
default['ad-simplyadrian']['sssd_ldap']['ldap_access_filter'] = nil
default['ad-simplyadrian']['sssd_ldap']['ldap_access_order'] = 'expire'
default['ad-simplyadrian']['sssd_ldap']['ldap_account_expire_policy'] = 'ad'

# Dynamic DNS config
default['ad-simplyadrian']['sssd_ldap']['dyndns_update'] = true
default['ad-simplyadrian']['sssd_ldap']['dyndns_refresh_interval'] = 43200
default['ad-simplyadrian']['sssd_ldap']['dyndns_update_ptr'] = true
default['ad-simplyadrian']['sssd_ldap']['dyndns_ttl'] = 3600

default['ad-simplyadrian']['sssd_ldap']['min_id'] = '1'
default['ad-simplyadrian']['sssd_ldap']['max_id'] = '0'
default['ad-simplyadrian']['sssd_ldap']['ldap_sudo'] = false
default['ad-simplyadrian']['sssd_ldap']['sbus_timeout'] = 30

# Debug
default['ad-simplyadrian']['sssd_ldap']['debug_level'] = 0
