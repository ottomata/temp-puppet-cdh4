# == Class cdh4::hadoop::nodemanager
#
class cdh4::hadoop::nodemanager {
  require cdh4::hadoop

  package { ['hadoop-yarn-nodemanager', 'hadoop-mapreduce']:
    ensure => 'installed',
  }

  # NodeManager (YARN TaskTracker)
  service { 'hadoop-yarn-nodemanager':
    ensure  => 'running',
    enable  => true,
    alias   => 'nodemanager',
    require => [Package['hadoop-yarn-nodemanager', 'hadoop-mapreduce']],
  }
}
