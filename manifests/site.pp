group { "puppet":
  ensure => "present",
}

include apt

# Installs add-apt-repository commands to the system
package { "python-software-properties":
	ensure => "installed",
}

##########################################################################
package {"openjdk-6-jre-headless":
  ensure => "purged"
}
package {"gcj-jdk":
  ensure => "purged"
}
package{ "gcj-4.6-jdk":
  ensure => "purged"
}

#Add webupd8 to the
apt::ppa { 'ppa:webupd8team/java':
} ->

# Prepare response file
file { "/tmp/oracle-java7-installer.preseed":
	source => '/vagrant/install/java/java.response',
	mode   => 600,
	backup => false,
}  ->

# Install Java
package { "oracle-java7-installer":
	ensure       => "installed",
	responsefile => '/tmp/oracle-java7-installer.preseed'
}

##########################################################################

file { '/etc/timezone':
    ensure => present,
    content => "US/Pacific\n",
}->
exec { 'reconfigure-tzdata':
        user => root,
        group => root,
        command => '/usr/sbin/dpkg-reconfigure --frontend noninteractive tzdata',
}
##########################################################################


##########################################################################
user {
  "linuxuser":
    ensure => "present",
    managehome => true,
    home => "/home/linuxuser"
}->
exec {
  "unpack apache tomcat":
    command => "/bin/tar xvf /vagrant/install/apache-tomcat-7.0.55.tar.gz -C /home/linuxuser",
    creates => "/home/linuxuser/apache-tomcat-7.0.55",
}->
exec {
  "create soft link":
    command => "/bin/ln -s /home/linuxuser/apache-tomcat-7.0.55 /home/linuxuser/apache-tomcat",
    creates => "/home/linuxuser/apache-tomcat"
}->
file {
  "/home/linuxuser/apache-tomcat":
    owner => "linuxuser",
    group => "linuxuser",
    recurse => "true",
    links => "follow"
}->
file {
  "/etc/init.d/apache-tomcat":
    source => "/vagrant/install/apache-tomcat"
}->
file {
  "/home/linuxuser/apache-tomcat/bin/setenv.sh":
    source => "/vagrant/install/setenv.sh",
    owner => "linuxuser",
    group => "linuxuser",
    notify => Service["apache-tomcat"]
}

service {
  "apache-tomcat":
    enable => "true",
	ensure => "running"
}


##########################################################################
#Deploy files here
file {"/home/linuxuser/apache-tomcat/webapps/ROOT":
  source => "/vagrant/deploy/ROOT",
  ensure => directory,
  recurse => true,
  owner => "linuxuser",
  group => "linuxuser",
  notify => Service["apache-tomcat"]
}

file {"/home/linuxuser/apache-tomcat/conf/application.properties":
  source => "/vagrant/deploy/tomcat-config/application.properties",
  owner => "linuxuser",
  group => "linuxuser",
  notify => Service["apache-tomcat"]
}
