ad-nativex Cookbook
===================
This cookbook installs Active Directory Domain Services on Windows 2012 including all necessary roles and features.
This cookbook is also responsible for joining Windows and Linux machines to the specified domain.

Requirements
------------

### Platform

* CentOS 6.6 and 7
* Windows Server 2008 R2 (features only)
* Windows Server 2012 Family

### Cookbooks

- Windows - Official windows cookbook from opscode https://github.com/opscode-cookbooks/windows.git
- ohai-nativex - Ohai cookbook from NativeX https://github.com/nativex/cookbook-ohai-nativex
- chef-sugar - Official chef-sugar cookbook from sethvargo https://github.com/sethvargo/chef-sugar.git

Usage
-----
#### ad-nativex::default
The ad-nativex::default recipe will add a supported Linux or Windows platform to the domain.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ad-nativex]"
  ]
}
```

#### ad-nativex::installdomaincontroller
The ad-nativex::installdomaincontroller recipe installs the required roles and features to support a domain controller.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ad-nativex::installdomaincontroller]"
  ]
}
```

Resource/Provider
=================

`domain`
--------

#### Actions
- :create: Installs a forest, domain, or domain controller
- :delete: Removes a domain controller from domain
- :join: Joins computer to domain
- :unjoin: Removes computer from domain

#### Attribute Parameters

- name: name attribute.  Name of the forest/domain to operate against.
- type: type of install. Valid values: forest, domain, read-only.
- safe_mode_pass: safe mode administrative password.
- domain_user: User account to join the domain.
- domain_pass: User password to join the domain.
- options: additional options as needed by AD DS Deployment Cmdlets
    http://technet.microsoft.com/en-us/library/hh974719.aspx.
    Single parameters use nil for key value, see example below.

#### Examples

    # Create Contoso.com forest
    ad-nativex_domain_controller "contoso.com" do
      action :create
      type "forest"
      safe_mode_pass "Passw0rd"
    end

    # Create Contoso.com forest with DNS, Win2008 Operational Mode
    ad-nativex_domain_controller "contoso.com" do
      action :create
      type "forest"
      safe_mode_pass "Passw0rd"
      options ({ "ForestMode" => "Win2008",
                 "InstallDNS" => nil
               })
    end

    # Remove Domain Controller
    ad-nativex_domain_controller "contoso.com" do
      action :delete
      local_pass "Passw0rd"
    end

    # Join Contoso.com domain
    ad-nativex_domain "contoso.com" do
      action :join
      domain_pass "Passw0rd"
      domain_user "Administrator"
    end

    # Unjoin Contoso.com domain
    ad-nativex_domain "contoso.com" do
      action :unjoin
      domain_pass "Passw0rd"
      domain_user "Administrator"
    end

`contact`
---------

#### Actions
- :create: Adds computers to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

#### Attribute Parameters

- name: name attribute.  Name of the computer object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options


#### Examples

    # Create contact "Bob Smith" in the Users OU with firstname "Bob" and lastname "Smith"
    ad-nativex_contact "Bob Smith" do
      action :create
      domain_name "contoso.com"
      ou "users"
      options ({ "fn" => "Bob", 
                 "ln" => "Smith"
               })
    end

`group`
-------

#### Actions
- :create: Adds groups to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

#### Attribute Parameters

- name: name attribute.  Name of the group object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options


#### Examples

    # Create group "IT" in the Users OU
    ad-nativex_group "IT" do
      action :create
      domain_name "contoso.com"
      ou "users"
    end

    # Create group "IT" in the Users OU with Description "Information Technology Security Group"
    ad-nativex_group "IT" do
      action :create
      domain_name "contoso.com"
      ou "users"
      options ({ "desc" => "Information Technology Security Group"
               })
    end

`ou`
----

#### Actions
- :create: Adds organizational units to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

#### Attribute Parameters

- name: name attribute.  Name of the Organization Unit object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options


#### Examples

    # Create Organizational Unit "Departments" in the root
    ad-nativex_ou "Departments" do
      action :create
      domain_name "contoso.com"
    end

    # Create Organizational Unit "IT" in the "Department" OUroot
    ad-nativex_ou "IT" do
      action :create
      domain_name "contoso.com"
      ou "Departments"
    end

`users`
-------

#### Actions
- :create: Adds users to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

Recipes
-------

#### default
Runs the 'joindomain' recipe.

#### dynamic_ou
Dynamically constructs the full OU path when to place machine in when it is joined to an AD domain. Used by the
join domain recipe.

#### installdomaincontroller
Installs an AD domain controller.

#### joindomain
Runs by default. Joins a Linux or Windows machine to an AD domain and configures AD authentication.

#### promotedomaincontroller
Configures an AD domain controller.

#### renamecomputer
Renames a Windows computer.

#### sssd_ldap
This recipe is based of of tas50's cookbook "sssd_ldap" found at https://github.com/tas50/chef-sssd_ldap.git
It has been modified to include additional options for Nativex. sssd_ldap installs and configures SSSD for LDAP
authentication.

#### unjoindomain
Removes a Windows or Linux computer from the domain.

Attribute Parameters
--------------------

### default
| Attribute | Value | Comment |
| -------------  | -------------  | -------------  |
| ['name'] | teamfreeze.com | AD domain name. |
| ['domain_component_level_[0-2]'] | 'com', 'teamfreeze', nil | OU path distinguished names. |
| ['organizational_unit_level_[0-7]'] | 'Computer Accounts', 'AWS Servers', 'UnknownRegion', 'Windows' or 'Linux', environment suffix (-*), 'One Off Servers', nil, nil | OU path organizational units |
| ['site_name'] | AMAZON | |
| ['safe_mode_pass'] | | |
| ['ad_username'] | | Account for joining machines to AD domain. |
| ['ad_password'] | | |

### krb5
| Attribute | Value | Comment |
| -------------  | -------------  | -------------  |
| ['kdc_servers'] | [] | Kerberos Key Distibution Center servers (typically your AD domain controllers). |
| ['krb5_realm'] | node['ad-nativex']['name'].upcase | Kerberos realm (typically your AD domain). |
| ['dns_lookup'] | false | If set to true, krb5 will search for Kerberos servers automatically. |

### sssd_ldap
| Attribute | Value | Comment |
| -------------  | -------------  | -------------  |
| ['authconfig_params'] | '--enablesssd --enablesssdauth --enablelocauthorize --enablemkhomedir --enablekrb5 --update' |
    authconfig parameters for automatically modifying PAM configuration files |
| ['pam'][:reconnection_retries] | 3 | Connection attempts during PAM authentication. |
| ['pam'][:offline_credentials_expiration] | 2 | If the authentication provider is offline, specifies for how long to\
                                                allow cached log-ins (in days). This value is measured from the last\
                                                successful online log-in. Set to 0 for no limit. |
| ['pam'][:offline_failed_login_attempts] | 3 | If the authentication provider is offline, specifies how many failed
                                                log in attempts are allowed. Set to 0 for no limit. |
| ['pam'][:offline_failed_login_delay] | 15 | Specifies the time in minutes after the value of
                                                offline_failed_login_attempts has been reached before a new log in
                                                attempt is possible. If set to 0, the user cannot authenticate offline
                                                if the value of offline_failed_login_attempts has been reached. Only a
                                                successful online authentication can re-enable offline authentication.
                                                If not specified, defaults to 5. |
| ['id_provider'] | 'ad' | Valid options 'ad' or 'ldap' |
| ['auth_provider'] | 'ad' | Sets the authentication provider used for the domain. Typically set the same as
                                                'id_provider'. Valid options 'ad', 'krb5', or 'ldap'. |
| ['chpass_provider'] | 'ad' | The provider which should handle change password operations for the domain. Valid options
                                                'ad', 'krb5', or 'ldap'. Set to 'none' to disallow password changes
                                                explicitly. |
| ['ldap_sudo'] | false | If set to true, adds and configures ldap enabled sudoers. Must also specify 'sudo_provider' |
| ['sudo_provider'] | 'ad' | The SUDO provider used for the domain. Valid options 'ad' or 'ldap'. |
| ['enumerate'] | 'true' | Allows group enumeration with id command. While the first enumeration is running, requests
                                                for the complete user or group lists may return no results until it
                                                completes. Set to false for performance increase in larger environments. |
| ['cache_credentials'] | 'true' | Specifies whether to store user credentials in the local SSSD domain database cache. |
| ['ldap_schema'] | 'ad' | Specifies the Schema Type in use on the target LDAP server. Depending on the selected schema,
                                                the default attribute names retrieved from the servers may vary. Valid
                                                options 'rfc2307b', 'rfc2307bis' (uses common name for groups), or 'ad'. |
| ['ldap_uri'] | 'ldap://something.yourcompany.com' | Specifies the comma-separated list of URIs of the LDAP servers to
                                                which SSSD should connect in the order of preference. Format:
                                                ldap[s]://<host>[:port] |
| ['ad_server'] | nil | The comma-separated list of IP addresses or hostnames of the AD servers to which SSSD should
                                                connect in order of preference. |
| ['ad_backup_server'] | nil | The comma-separated list of backup IP addresses or hostnames of the AD servers to which
                                                SSSD should connect in order of preference. |
| ['ad_hostname'] | nil | Optional. May be set on machines where the hostname does not reflect the fully qualified name
                                                used in the Active Directory domain to identify this host. |
| ['ldap_search_base'] | 'dc=yourcompany,dc=com' | The default base DN to use for performing LDAP user operations. |
| ['ldap_user_search_base'] | 'ou=People,dc=yourcompany,dc=com' | User base DN, search scope and LDAP filter to restrict
                                                LDAP searches for this attribute type. |
| ['ldap_user_object_class'] | 'user' | The LDAP object that corresponds to a user. |
| ['ldap_user_name'] | 'sAMAccountName' | The LDAP attribute that corresponds to the user's login name. |
| ['ldap_id_mapping'] | true | Set to false to use POSIX attributes on the AD. |
| ['override_homedir'] | nil | Overrides LDAP attribute for creating users home directory. |
| ['shell_fallback'] | '/bin/bash' | Fallback if LDAP attribute for shell is not set. |
| ['ldap_group_search_base'] | 'ou=Groups,dc=yourcompany,dc=com' | Group base DN, search scope and LDAP filter to
                                                restrict LDAP searches for this attribute type. |
| ['ldap_group_object_class'] | 'group' | The LDAP object that corresponds to a group. |
| ['ldap_id_use_start_tls'] | 'true' | Specifies that the id_provider connection must also use tls to protect the channel. |
| ['ldap_force_upper_case_realm'] | 'true' | Forces automatic upcase of realm name. |
| ['ldap_tls_reqcert'] | 'never' | Specifies what checks to perform on server certificates in a TLS session, if any. |
| ['ldap_tls_cacert'] | '/etc/pki/tls/certs/ca-bundle.crt' or '/etc/ssl/certs/ca-certificates.crt' | Defaults for RHEL
                                                and others respectively. |
| ['ldap_default_bind_dn'] | 'cn=bindaccount,dc=yourcompany,dc=com' | If you have a domain that doesn't require binding
                                                set this attributes to nil. |
| ['ldap_default_authtok'] | 'bind_password' | If you have a domain that doesn't require binding set this to nil. |
| ['access_provider'] | 'ad' | If using access_provider = ldap and ldap_access_order = filter (default), this option is
                                                mandatory. It specifies an LDAP search filter criteria that must be met
                                                for the user to be granted access on this host. |
| ['ldap_access_filter'] | nil| If 'access_provider' is specified, can use simple LDAP filter such as 'uid=abc123'
                                                or more expressive LDAP filters like
                                                '(&(objectClass=employee)(department=ITSupport))' |
| ['ldap_access_order'] | 'expire' | If 'access_provider' is specified, comma separated list of access control options.
                                                see SSSD man page for filter details. |
| ['ldap_account_expire_policy'] | 'ad' | If 'access_provider' is specified, with this option a client side evaluation
                                                of access control attributes can be enabled. |
| ['dyndns_update'] | 'true' | Set to true to enable dynamic DNS updates. |
| ['dyndns_refresh_interval'] | '43200' | Frequency in seconds to refresh DNS record. |
| ['dyndns_update_ptr'] | 'true' | Set to true to also update DNS pointer record. |
| ['dyndns_ttl'] | '3600' | Time to live in seconds |
| ['min_id'] | '1' | Specifies the UID and GID range for the domain. If a domain contains entries that are outside that
                                                range, they are ignored. Used to ignore lower uid/gid's. |
| ['max_id'] | '0' | Specifies the UID and GID range for the domain. If a domain contains entries that are outside that
                                                range, they are ignored. Used to ignore higher uid/gid's. Set to 0 for
                                                unlimited. |
| ['sbus_timeout'] | 30 | SSSD message bus timeout in seconds. Set to 0 for unlimited. |
| ['debug_level'] | 0 | (Valid values 1-10) Enables debug entries in /var/log/sssd/*. Set to 0 to disable. |

More details on options at: http://linux.die.net/man/5/sssd-ldap and http://linux.die.net/man/5/sssd-ad

Examples
--------

    # Create user "Joe Smith" in the Users OU
    ad-nativex_user "Joe Smith" do
      action :create
      domain_name "contoso.com"
      ou "users"
      options ({ "samid" => "JSmith",
             "upn" => "JSmith@contoso.com",
             "fn" => "Joe",
             "ln" => "Smith",
             "display" => "Smith, Joe",
             "disabled" => "no",
             "pwd" => "Passw0rd"
           })
    end

CA Certificates
---------------

If you manage your own CA then the easiest way to inject the certificate for system-wide use is as follows:

### RHEL

    cp ca.crt /etc/pki/ca-trust/source/anchors
    update-ca-trust enable
    update-ca-trust extract

### Debian

    cp ca.crt /usr/local/share/ca-certificates
    update-ca-certificates

License and Authors
-------------------

Authors:: Adrian Herrera, Derek Bromenshenkel, Jesse Hauf, Tim Smith (sssd_ldap)

License:: Apache 2.0
