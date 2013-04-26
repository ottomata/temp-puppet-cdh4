# == Class cdh4::hadoop::datanode
#
class cdh4::hadoop::datanode {
  require cdh4::hadoop

  # install jobtracker daemon package
  package { 'hadoop-hdfs-datanode':
    ensure => 'installed'
  }

  # install datanode daemon package
  service { 'hadoop-hdfs-datanode':
    ensure  => 'running',
    enable  => true,
    alias   => 'datanode',
  }
}