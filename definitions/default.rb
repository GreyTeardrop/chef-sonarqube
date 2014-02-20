define :sonar_plugin, :version => '1.0', :repo_url => false, :download_url => false do

  if params[:download_url]
    download_url = params[:download_url]
  else
    repo_url = params[:repo_url] ? params[:repo_url] : node[:sonar][:plugins_repo]
    download_url = "#{repo_url}/#{params[:name]}/#{params[:version]}/#{params[:name]}-#{params[:version]}.jar"
  end

  download_path = "#{node[:sonar][:dir]}/#{node[:sonar][:downloads_dir]}/#{params[:name]}-#{params[:version]}.jar"
  install_path = "#{node[:sonar][:dir]}/#{node[:sonar][:plugins_dir]}/#{params[:name]}-#{params[:version]}.jar"

  remote_file download_path do
    source download_url
    owner 'root'
    group 'root'
    mode 00644
    notifies :restart, 'service[sonar]'
    not_if { ::File.exists?(install_path) }
  end

end
