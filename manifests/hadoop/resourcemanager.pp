# == Class cdh4::hadoop::resourcemanager
# Installs and starts ResourceManager daemon.
# (ResourceManager is analagous to JobTracker in MRv1).
class cdh4::hadoop::resourcemanager {
  require cdh4::hadoop

  if !$::cdh4::hadoop::use_yarn  {
    fail('Cannot use Hadoop YARN ResourceManager unless cdh4::hadoop::use_yarn is false.')
  }

  package { 'hadoop-yarn-resourcemanager':
    ensure => 'installed'
  }

  service { 'hadoop-yarn-resourcemanager':
    ensure  => 'running',
    enable  => true,
    alias   => 'resourcemanager',
    require => Package['hadoop-yarn-resourcemanager'],
  }
}