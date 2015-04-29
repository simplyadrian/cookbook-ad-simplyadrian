ad-nativex CHANGELOG
====================

This file is used to list changes made in each version of the ad-nativex cookbook.

3.0.1
-----
- [Jesse Hauf] - Fixed with windows ou path

3.0.1
-----
- [Jesse Hauf] - Fixed bug in dynamic_ou where windows? was spelled window?

3.0.0
-----
- [Jesse Hauf] - Added linux support, specifically CentOS. Installs and configures adcli, sssd, PAM, and krb5
- [Jesse Hauf] - Added sssd_ldap recipe and attribute parameters to configure SSSD
- [Jesse Hauf] - Added dynamic_dc recipe and attribute parameters dynamically determine proper AD domain controller based on region
- [Jesse Hauf] - Updated dynamic_ou to support on premise servers
- [Jesse Hauf] - Added support for removing Linux machine from domain

2.2.0
-----
- [Adrian Herrera] - Removed the AD credential provider

2.1.1
-----
- [Adrian Herrera] - Added rename recipe and removed the rename function from the joindomain recipe. [ISE-323]

2.0.1
-----
- [Adrian Herrera] - Removed record provider as it was redundant. Leveraging the "creds" common functionality found in
    the chef system. [ISE-298]

1.0.1
-----
- [Derek Bromenshenkel] - Fixed handling of multiple environments in OU path [ISE-346]

1.0.0
-----
- [NativeX Dev Ops Team] - Initial release of ad-nativex

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences
between markdown on github and standard markdown.
