Exec { path => "/bin:/usr/bin", }

class mooc::spark($home_directory, $owner, $group) {
    # install spark from the tarball.
    File {
        owner => $owner,
        group => $group,
    }

    file {
        "$home_directory/apache-mirror-selector.py":
            ensure  => present,
            source  => "puppet:///modules/mooc/spark/apache-mirror-selector.py",
    }

    file {
        "$home_directory/spark_notebook.py":
            ensure  => present,
            source  => "puppet:///modules/mooc/spark/spark_notebook.py",
    }

    exec { acquire_spark:
        command => "wget -q `python $home_directory/apache-mirror-selector.py http://www.apache.org/dyn/closer.cgi?path=spark/spark-1.3.1/spark-1.3.1-bin-hadoop2.6.tgz`",
        creates => "$home_directory/spark-1.3.1-bin-hadoop2.6.tgz",
        require => File["$home_directory/apache-mirror-selector.py"]
    }

    exec { untar-spark:
        command => "tar -xzf $home_directory/spark-1.3.1-bin-hadoop2.6.tgz",
        cwd => "/usr/local/bin", # put spark
        creates => "/usr/local/bin/spark-1.3.1-bin-hadoop2.6",
        require => Exec[acquire_spark]
    }

    file { '/etc/profile.d/append-spark-path.sh':
            mode    => 644,
            content  => 'PATH=$PATH:/usr/local/bin/spark-1.3.1-bin-hadoop2.6/bin',
    }

    file { '/etc/profile.d/set-spark-home.sh':
            mode    => 644,
            content  => 'SPARK_HOME=/usr/local/bin/spark-1.3.1-bin-hadoop2.6',
    }

    upstart::job { 'notebook':
                    user           => 'vagrant',
                    group          => 'vagrant',
                    exec           => "python $home_directory/spark_notebook.py",
 
                }

}
