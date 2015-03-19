name             'ad-nativex'
maintainer       'NativeX'
maintainer_email 'adrian.herrera@nativex.com'
license          'All rights reserved'
description      'Installs/Configures ad-nativex'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.2.0'
supports         'windows', ">= 6.2"

depends		 "windows"
depends		 "ohai-nativex"
depends    "sssd_ldap"
depends    "chef-sugar"
