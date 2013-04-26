# == Class cdh4::hadoop::worker
#
class cdh4::hadoop::worker {
  require cdh4::hadoop


  cdh4::hadoop::worker::paths { $::cdh4::hadoop::datanode_mounts: }


  class { 'cdh4::hadoop::datanode':
    require => Cdh4::Hadoop::Worker::Paths[$::cdh4::hadoop::datanode_mounts]
  }

  # If we aren't using yarn, then include the jobtracker
  if $::cdh4::hadoop::use_yarn {
    class { 'cdh4::hadoop::nodemanager':
      require => Cdh4::Hadoop::Worker::Paths[$::cdh4::hadoop::datanode_mounts]
    }
  }
  else {
    include cdh4::hadoop::tasktracker
  }
}

# Ensure directories needed for Hadoop Worker nodes
# are created with proper ownership and permissions.
# This has to be a define so that we can pass the 
# $datanode_mounts array as a group.  (Puppet doesn't
# support iteration.)

# TODO: put this in a proper file.  Not sure where yet.
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
    ensure => 'directory',
    owner  => 'hdfs',
    group  => 'hdfs',
    mode   => '0700',
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
}
