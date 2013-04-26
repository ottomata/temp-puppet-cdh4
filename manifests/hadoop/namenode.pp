# == Class cdh4::hadoop::namenode
#
class cdh4::hadoop::namenode {
  require cdh4::hadoop

  # install namenode daemon package
  package { 'hadoop-hdfs-namenode':
    ensure => installed
  }

  # All files here require namenode package
  File {
    require => Package['hadoop-hdfs-namenode'],
  }

  file { "${::cdh4::hadoop::config_directory}/hosts.exclude":
    ensure => 'present',
  }

  # Ensure that the namenode directory has the correct permissions.
  # NOTE! You should create, mount and hdfs format this directory
  # manually yourself.
  # To format the dfs_name_dir, run:
  #   sudo -u hdfs hadoop namenode -format
  file { $::cdh4::hadoop::dfs_name_dir:
    ensure => 'directory',
    owner  => 'hdfs',
    group  => 'hdfs',
    mode   => '0700',    
  }

  service { 'hadoop-hdfs-namenode': 
    ensure  => 'running',
    enable  => true,
    alias   => 'namenode',
    require => [File["${::cdh4::hadoop::config_directory}/hosts.exclude"], File[$::cdh4::hadoop::dfs_name_dir]],
  }
}