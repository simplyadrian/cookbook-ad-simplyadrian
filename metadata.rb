name             'ad-nativex'
maintainer       'NativeX'
maintainer_email 'adrian.herrera@nativex.com'
license          'All rights reserved'
description      'Installs/Configures ad-nativex'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.0.1'
supports         'windows', '>= 6.2'

depends		 'windows'
depends		 'ohai-nativex'
depends    'chef-sugar'
