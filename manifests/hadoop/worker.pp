# == Class cdh4::hadoop::worker
# Wrapper class for Hadoop Worker node services:
# - DataNode
# - NodeManager (YARN)
# OR
# - TaskTracker (MRv1)
#
# This class will attempt to create and manage the required
# local worker directories defined in the $datanode_mounts array.
# You must make sure that the paths defined in $datanode_mounts are
# formatted and mounted properly yourself; The CDH4 module does not
# manage them.
#
class cdh4::hadoop::worker {
  require cdh4::hadoop

  cdh4::hadoop::worker::paths { $::cdh4::hadoop::datanode_mounts: }

  class { 'cdh4::hadoop::datanode':
    require => Cdh4::Hadoop::Worker::Paths[$::cdh4::hadoop::datanode_mounts],
  }

  # YARN uses NodeManager.
  if $::cdh4::hadoop::use_yarn {
    class { 'cdh4::hadoop::nodemanager':
      require => Cdh4::Hadoop::Worker::Paths[$::cdh4::hadoop::datanode_mounts],
    }
  }
  # MRv1 uses TaskTracker.
  else {
    class { 'cdh4::hadoop::tasktracker':
      require => Cdh4::Hadoop::Worker::Paths[$::cdh4::hadoop::datanode_mounts],
    }
  }
}



# == Define cdh4::hadoop::worker::paths
#
# Ensures directories needed for Hadoop Worker nodes
# are created with proper ownership and permissions.
# This has to be a define so that we can pass the
# $datanode_mounts array as a group.  (Puppet doesn't
# support iteration.)
#
# == Parameters:
# $basedir   - base path for directory creation.  Default: $title
# $use_yarn  - Boolean.  Create YARN or MRv1 directories.  Default: $::cdh4::hadoop::use_ar
#
#
# TODO: Put this in a proper file.  Not sure where yet.
#       manifests/hadoop/worker/paths.pp???
#
define cdh4::hadoop::worker::paths($basedir = $title) {
  require cdh4::hadoop

  # hdfs, hadoop, and yarn users
  # are all added by packages
  # installed by cdh4::hadoop

  # make sure mounts exist
  file { $basedir:
    ensure  => 'directory',
    owner   => 'hdfs',
    group   => 'hdfs',
    mode    => '0755',
  }

  # Assume that $dfs_data_path is two levels.  e.g. hdfs/dn
  # We need to manage the parent directory too.
  $dfs_data_path_parent = inline_template("<%= File.dirname('${::cdh4::hadoop::dfs_data_path}') %>")
  # create DataNode directories
  file { ["${basedir}/${dfs_data_path_parent}", "${basedir}/${::cdh4::hadoop::dfs_data_path}"]:
    ensure  => 'directory',
    owner   => 'hdfs',
    group   => 'hdfs',
    mode    => '0700',
    require => File[$basedir],
  }

  if $::cdh4::hadoop::use_yarn {
    # create yarn local directories
    file { ["${basedir}/yarn", "${basedir}/yarn/local", "${basedir}/yarn/logs"]:
      ensure  => 'directory',
      owner   => 'yarn',
      group   => 'yarn',
      mode    => '0755',
    }
  }
  else {
    # Create MRv1 local directories.
    # See: http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_11_3.html
    file { ["${basedir}/mapred", "${basedir}/mapred/local"]:
      ensure  => 'directory',
      owner   => 'mapred',
      group   => 'hadoop',
      mode    => '0755',
    }
  }
}
