ad-nativex Cookbook
===================
This cookbook installs Active Directory Domain Services on Windows 2012 including all necessary roles and features.
This cookbook is also reposible for joining Windows and Linux machines to the specified domain.

Requirements
============

Platform
--------

* CentOS 6.6 and 7
* Windows Server 2008 R2 (features only)
* Windows Server 2012 Family

Cookbooks
---------

- Windows - Official windows cookbook from opscode https://github.com/opscode-cookbooks/windows.git
- Powershell - Official powershell cookbook from opscode https://github.com/opscode-cookbooks/powershell.git
- chef-sugar - Official chef-sugar cookbook from sethvargo https://github.com/sethvargo/chef-sugar.git

Usage
==========
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

### Actions
- :create: Installs a forest, domain, or domain controller
- :delete: Removes a domain controller from domain
- :join: Joins computer to domain
- :unjoin: Removes computer from domain

### Attribute Parameters

- name: name attribute.  Name of the forest/domain to operate against.
- type: type of install. Valid values: forest, domain, read-only.
- safe_mode_pass: safe mode administrative password.
- domain_user: User account to join the domain.
- domain_pass: User password to join the domain.
- options: additional options as needed by AD DS Deployment Cmdlets
    http://technet.microsoft.com/en-us/library/hh974719.aspx.
    Single parameters use nil for key value, see example below.

### Examples

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

### Actions
- :create: Adds computers to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the computer object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options


### Examples

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

### Actions
- :create: Adds groups to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the group object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options


### Examples

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

### Actions
- :create: Adds organizational units to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the Organization Unit object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options


### Examples

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

### Actions
- :create: Adds users to Active Directory
- :modify: Modifies an existing object of a specific type in the directory.
- :move:  Rename an object without moving it in the directory tree, or move an object from its current location in the directory to a new location within a single domain controller.
- :delete:  Remove objects of the specified type from Active Directory.

### Attribute Parameters

- name: name attribute.  Name of the user object.
- domain_name: FQDN
- ou: Organization Unit path where object is located.
- options: ability to pass additional options
- reverse: allows the reversing of "First Name Last Name" to "Last Name, First Name"

### Examples

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

Recipes
=======

#### sssd_ldap
This recipe is based of of tas50's cookbook "sssd_ldap" found at https://github.com/tas50/chef-sssd_ldap.git
It has been modified to include additional options for Nativex. sssd_ldap installs and configures SSSD for LDAP
authentication.

Attribute Parameters
----------
| Attribute | Value | Comment |
| -------------  | -------------  | -------------  |
| ['authconfig_params'] | '--enablesssd --enablesssdauth --enablelocauthorize --enablemkhomedir --enablekrb5 --update' | authconfig parameters for automatically modifying PAM configuration files |
| ['pam_reconnection_retries'] | 3 | Connection attempts during PAM authentication |
| ['id_provider'] | 'ldap' | |
| ['auth_provider'] | 'krb5' | |
| ['chpass_provider'] | 'krb5' | |
| ['sudo_provider'] | 'ldap' | |
| ['enumerate'] | 'true' | |
| ['cache_credentials'] | 'true' | |
| ['ldap_schema'] | 'rfc2307bis' | |
| ['ldap_uri'] | 'ldap://something.yourcompany.com' | |
| ['ldap_search_base'] | 'dc=yourcompany,dc=com' | |
| ['ldap_user_search_base'] | 'ou=People,dc=yourcompany,dc=com' | |
| ['ldap_user_object_class'] | 'user' | |
| ['ldap_user_name'] | 'sAMAccountName' | |
| ['ldap_id_mapping'] | true | Set to false to use POSIX attributes on the AD |
| ['override_homedir'] | nil | |
| ['shell_fallback'] | '/bin/bash' | |
| ['ldap_group_search_base'] | 'ou=Groups,dc=yourcompany,dc=com' | |
| ['ldap_group_object_class'] | 'group' | |
| ['ldap_id_use_start_tls'] | 'true' | |
| ['ldap_force_upper_case_realm'] | 'true' | Forces automatic upcase of realm |
| ['ldap_tls_reqcert'] | 'never' | |
| ['ldap_tls_cacert'] | '/etc/pki/tls/certs/ca-bundle.crt' or '/etc/ssl/certs/ca-certificates.crt' | defaults for RHEL and others respectively |
| ['ldap_default_bind_dn'] | 'cn=bindaccount,dc=yourcompany,dc=com' | if you have a domain that doesn't require binding set this attributes to nil
| ['ldap_default_authtok'] | 'bind_password' | if you have a domain that doesn't require binding set this to nil |
| ['access_provider'] | nil | Should be set to 'ldap' |
| ['ldap_access_filter'] | nil| Can use simple LDAP filter such as 'uid=abc123' or more expressive LDAP filters like '(&(objectClass=employee)(department=ITSupport))' |
| ['dyndns_update'] | 'true' | Set to true to enable dynamic DNS updates |
| ['dyndns_refresh_interval'] | '43200' | Frequency in seconds to refresh DNS record |
| ['dyndns_update_ptr'] | 'true' | Set to true to also update DNS pointer record |
| ['dyndns_ttl'] | '3600' | Time to live in seconds |
| ['min_id'] | '1' | default, used to ignore lower uid/gid's |
| ['max_id'] | '0' | default, used to ignore higher uid/gid's |
| ['ldap_sudo'] | false | Adds ldap enabled sudoers (true/false) |
| ['debug_level'] | 0 | (Valid values 1-10) Enables debug entries in /var/log/sssd/* |

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
