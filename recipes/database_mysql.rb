include_recipe "mysql::server"

# Setup sonar user
grants_path = "/opt/sonar/extras/database/mysql/create_database.sql"

template grants_path do
  source "create_mysql_database.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  action :create
  notifies :restart, resources(:service => "sonar")
end

execute "mysql-install-application-privileges" do
  command "/usr/bin/mysql -u root #{node[:mysql][:server_root_password].empty? ? '' : '-p' }#{node[:mysql][:server_root_password]} < #{grants_path}"
end

include_recipe "backup"

backup_install node.name
backup_generate_config node.name

backup_generate_model "mysql" do
  description "Our shard"
  backup_type "database"
  database_type "MySQL"
  split_into_chunks_of 2048
  store_with({"engine" => "S3", "settings" => { "s3.access_key_id" => "BN588NGSSFPKQHD1NX21", "s3.secret_access_key" => "8abEbk+jZyx3c9Td2etAMO031bkXmqQEGjET8WcE", "s3.bucket" => "backups", "s3.path" => "sonar", "s3.keep" => 5, "s3.fog_options" => {  :host => 's3.eden.klm.com', :scheme => 'http', :port => 80 } } } )
  options({"db.host" => "\"localhost\"", "db.username" => "\"#{node[:sonar][:jdbc_username]}\"", "db.password" => "\"#{node[:sonar][:jdbc_password]}\"", "db.name" => "\"sonar\""})
  action :backup
end