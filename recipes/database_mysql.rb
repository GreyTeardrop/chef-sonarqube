include_recipe 'mysql::server'
include_recipe 'database::mysql'

mysql_connection = {
    :host     => 'localhost',
    :username => 'root',
    :password => node[:mysql][:server_root_password]
}

mysql_database 'sonar' do
  connection     mysql_connection
  action         :create
end

mysql_database_user node[:sonar][:jdbc_username] do
  connection     mysql_connection
  host           'localhost'
  password       node[:sonar][:jdbc_password]
  action         :create
  notifies       :restart, 'service[sonar]'
end

mysql_database_user "grant #{node[:sonar][:jdbc_username]}@localhost" do
  connection     mysql_connection
  database_name  'sonar'
  host           'localhost'
  username       node[:sonar][:jdbc_username]
  password       node[:sonar][:jdbc_password]
  action         :grant
  notifies       :restart, 'service[sonar]'
end

mysql_database_user "grant #{node[:sonar][:jdbc_username]}@%" do
  connection     mysql_connection
  database_name  'sonar'
  host           '%'
  username       node[:sonar][:jdbc_username]
  password       node[:sonar][:jdbc_password]
  action         :grant
  notifies       :restart, 'service[sonar]'
end
