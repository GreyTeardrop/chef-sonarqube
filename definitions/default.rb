define :sonar_plugin, :version => '1.0', :repo_url => false do

  repo_location = params[:repo_url] ? params[:repo_url] : node[:sonar][:plugins_repo]

  remote_file "#{node[:sonar][:dir]}/#{node[:sonar][:downloads_dir]}/#{params[:name]}-#{params[:version]}.jar" do
    source "#{repo_location}/#{params[:name]}/#{params[:version]}/#{params[:name]}-#{params[:version]}.jar"
    owner 'root'
    group 'root'
    mode 00644
    notifies :restart, 'service[sonar]'
    not_if { ::File.exists?("#{node[:sonar][:dir]}/#{node[:sonar][:plugins_dir]}/#{params[:name]}-#{params[:version]}.jar") }
  end

end
