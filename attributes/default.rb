# General settings
default[:sonar][:dir]                    = '/opt/sonar'
default[:sonar][:version]                = '3.7.4'
default[:sonar][:checksum]               = '624658f5727863a60d6ffc85d3f1caea'
default[:sonar][:os_kernel]              = 'linux-x86-64'
default[:sonar][:mirror]                 = 'http://dist.sonar.codehaus.org'
default[:sonar][:plugins_repo]           = 'http://repository.codehaus.org/org/codehaus/sonar-plugins'
default[:sonar][:plugins_dir]            = 'extensions/plugins'
default[:sonar][:downloads_dir]          = 'extensions/downloads'
default[:sonar][:plugins]                = {}

# Web settings
# The default listen port is 9000, the default context path is / and Sonar listens by default to all network interfaces : '0.0.0.0'.
# Once launched, the Sonar web server is available on http://localhost:9000. Parameters can be changed into the file conf/sonar.properties.
# Here is an example to listen to http://localhost:80/sonar:
default[:sonar][:web_host]               = '0.0.0.0'
default[:sonar][:web_port]               = '9000'
default[:sonar][:web_domain]             = 'sonar.example.com'
default[:sonar][:web_context]            = '/'
default[:sonar][:web_template]           = 'default'

# Database settings
# @see conf/sonar.properties for examples for different databases
default[:sonar][:jdbc_username]          = 'sonar'
default[:sonar][:jdbc_password]          = 'sonar'
default[:sonar][:jdbc_url]               = 'jdbc:h2:tcp://localhost:9092/sonar'

# Wrapper settings eg. for performance improvements
# @see http://docs.codehaus.org/display/SONAR/Performances
default[:sonar][:java_additional]        = '-server'
default[:sonar][:java_initmemory]        = '256'
default[:sonar][:java_maxmemory]         = '512'
default[:sonar][:java_maxpermsize]       = '128m'
default[:sonar][:java_command]           = 'java'
default[:sonar][:logfile_maxsize]        = '0'
default[:sonar][:syslog_loglevel]        = 'NONE'

default[:sonar][:options]                = {}
