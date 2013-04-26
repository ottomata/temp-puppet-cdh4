# == Class cdh4::hadoop::historyserver
#
class cdh4::hadoop::historyserver {
  require cdh4::hadoop

  package { 'hadoop-mapreduce-historyserver':
    ensure => 'installed',
  }

  service { 'hadoop-mapreduce-historyserver':
    ensure    => 'running',
    enable    => true,
    alias     => 'historyserver',
    require   => Package['hadoop-mapreduce-historyserver'],
    # TODO: This subscribe?  not sure.
    subscribe => File["${::cdh4::hadoop::config_directory}/mapred-site.xml"],
  }
}