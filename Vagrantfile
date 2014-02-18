# We'll mount the Chef::Config[:file_cache_path] so it persists between
# Vagrant VMs
host_cache_path = File.expand_path("../.cache", __FILE__)
guest_cache_path = "/tmp/vagrant-cache"

Vagrant.require_plugin "vagrant-openstack-plugin"

# ensure the cache path exists
FileUtils.mkdir(host_cache_path) unless File.exist?(host_cache_path)

Vagrant.configure("2") do |config|
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest
  config.vm.box      = 'dummy'
  config.ssh.username = "ubuntu"
  config.ssh.private_key_path = '~/.ssh/eindbaas-key'


  config.vm.provider :openstack do |os|
    os.username     = "vagrant"          # e.g. "#{ENV['OS_USERNAME']}"
    os.api_key      = "vagrant"           # e.g. "#{ENV['OS_PASSWORD']}"
    os.flavor       = /mx.small/                # Regex or String
    os.image        = /Ubuntu Server 13.04/                 # Regex or String
    os.endpoint     = "http://172.21.42.2:5000/v2.0/tokens"      # e.g. "#{ENV['OS_AUTH_URL']}/tokens"
    os.keypair_name = "eindbaas-key"      # as stored in Nova
    os.name         = "sonar-dev"
    os.server_name  = "sonar-dev"
    os.floating_ip  = "172.21.42.159"      # optional (The floating IP to assign for this instance)
  end

  config.vm.provision :chef_solo do |chef|
    chef.provisioning_path = guest_cache_path
    chef.log_level         = :debug

    chef.json = {
        "java" => {
            'install_flavor' => 'openjdk',
            'jdk_version' => '7'
        },
        "mysql" => {
            "server_root_password" => "iloverandompasswordsbutthiswilldo",
            "server_repl_password" => "iloverandompasswordsbutthiswilldo",
            "server_debian_password" => "iloverandompasswordsbutthiswilldo",
            "bind_address" => "0.0.0.0",
            "tunable" => {
                "wait_timeout" => "28800"
            }
        },
        "sonar" => {
            "web_port" => "80",
            "web_domain" => "sonar.eden.klm.com",
            "jdbc_url" => "jdbc:mysql://localhost:3306/sonar?useUnicode=true&characterEncoding=utf8",
            "jdbc_driverClassName" => "com.mysql.jdbc.Driver",
            "options" => {
                "sonar.authenticator.class" => "org.sonar.plugins.crowd.CrowdAuthenticator",
                "sonar.authenticator.ignoreStartupFailure" => "true",
                "sonar.authenticator.createUsers" => "true",
                "crowd.url" => "https://www9.klm.com/corporate/pse/crowd/services/",
                "crowd.password" => "sonar"
            }
        }
    }

    chef.run_list = %w{
      recipe[apt]
      recipe[java]
      recipe[sonar]
      recipe[sonar::plugins]
      recipe[sonar::database_mysql]
    }
  end

  config.vm.synced_folder host_cache_path, guest_cache_path
end