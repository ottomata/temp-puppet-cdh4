# == Class cdh4::hadoop::jobtracker
#
class cdh4::hadoop::jobtracker {
  require cdh4::hadoop

  if $::cdh4::hadoop::use_yarn {
    fail('Cannot use Hadoop MRv1 JobTrackker if cdh4::hadoop::use_yarn is true.')
  }

  # install jobtracker daemon package
  package { 'hadoop-0.20-mapreduce-jobtracker':
    ensure => installed
  }

  service { 'hadoop-0.20-mapreduce-jobtracker':
    ensure  => 'running',
    enable  => true,
    alias   => 'jobtracker',
    require => Package['hadoop-0.20-mapreduce-jobtracker'],
  }
}