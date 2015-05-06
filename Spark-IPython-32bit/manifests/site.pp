node default {

    Exec {
        path => [
            '/usr/local/sbin',
            '/usr/local/bin',
            '/usr/sbin',
            '/usr/bin',
            '/sbin',
            '/bin'
        ]
    }

    $home = "/home/vagrant"

    # Configure apt

    # Install some required packages

    package {[
            "pkg-config",
            "openjdk-7-jre-headless",
            "python-pip",
            "git",
            "libzmq-dev",
            "exuberant-ctags",
            "python-dev",
            "python-matplotlib"
        ]:
        ensure => installed,
    }

    class { ["mooc::spark"]:
        home_directory => $home,
        owner          => vagrant,
        group          => vagrant,
    }

    python::pip { 'ipython':
        pkgname       => 'ipython[notebook]',
        ensure        => '3.1'
    }

    python::pip { 'pyzmq':
        pkgname       => 'pyzmq',
    }

    python::pip { 'jinja2':
        pkgname       => 'jinja2',
    }

    python::pip { 'tornado':
        pkgname       => 'tornado',
    }

    python::pip { 'jsonschema':
        pkgname       => 'jsonschema',
    }
}
