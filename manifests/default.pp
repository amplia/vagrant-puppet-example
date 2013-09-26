################################################
# Vagrant Smart M2M                            #
################################################
#                                              #
# OS          : Centos                         #
# Groovy      : Installed by Vagrant folder    #
#                                              #
#####       Puppet      ########################
#                                              #
# Java                                         #
# SmartM2M RPM                                 #
# Configure SmartM2M RPM                       #
#                                              #
################################################


########## Java installation ##########

class { 
  'java': distribution => 'jre',
  notify => File_line["java_home"]
}


########## Set JAVA_HOME ##########

file_line { 'java_home':
   path => '/home/vagrant/.bashrc',
   line => 'JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64',
   notify => File_line["java_export"]
}

file_line { 'java_export':
   path => '/home/vagrant/.bashrc',
   line => 'export JAVA_HOME',
   notify => File_line["groovy_home"]
}


######################################## TODO groovy installation ########################################

########## Set GROOVY_HOME ##########
file_line { 'groovy_home':
   path => '/home/vagrant/.bashrc',
   line => 'GROOVY_HOME=/vagrant/groovy-2.0.1',
   notify => File_line["groovy_export"]
}

file_line { 'groovy_export':
   path => '/home/vagrant/.bashrc',
   line => 'export GROOVY_HOME',
   notify => File_line["groovy_path"]
}

file_line { 'groovy_path':
   path => '/home/vagrant/.bashrc',
   line => 'PATH=$GROOVY_HOME/bin:$PATH',
   notify => Package["SmartM2M RPM"]
}


########## Smart M2M installation ##########

package { 'SmartM2M RPM': 
    provider => rpm, 
    ensure => installed, 
    source => 'http://172.19.18.2/rpm-1.1.0/globalm2m-assembler-platform-1.1.0-rpm.rpm',
    notify => File["GlobalPermission"]
}


########## Smart M2M configuration ##########

file { "GlobalPermission":
  path => '/GLOBALM2M',
    owner => vagrant,
    group => vagrant,
    recurse => true,
  notify => Exec["restore_jars"]
}

#### This part doesn't work #############################################################################
exec { "restore_jars":
    command => "/vagrant/groovy-2.0.1/bin/groovy restore.groovy",
    path    => "/GLOBALM2M/m2msupervision-platform",
    user => "vagrant"
}
#### END This part doesn't work #########################################################################

