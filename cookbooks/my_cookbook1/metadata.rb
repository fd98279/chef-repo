name             'my_cookbook1'
maintainer       'sravz'
maintainer_email 'sampat.p@gmail.com'
license          'All rights reserved'
description      'Installs/Configures my_cookbook1'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
depends "chef-client"
depends "apt"
depends "ntp"
