#
# Cookbook Name:: sonar
# Recipe:: default
#
# Copyright 2011, Christian Trabold
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'java'

package 'unzip'

remote_file "/opt/sonar-#{node[:sonar][:version]}.zip" do
  source "#{node[:sonar][:mirror]}/sonar-#{node[:sonar][:version]}.zip"
  mode '0644'
  checksum node[:sonar][:checksum]
  not_if { ::File.exists?("/opt/sonar-#{node[:sonar][:version]}.zip") }
end

execute "unzip /opt/sonar-#{node[:sonar][:version]}.zip -d /opt/" do
  notifies :stop, 'service[sonar]', :immediate
  not_if { ::File.directory?("/opt/sonar-#{node[:sonar][:version]}/") }
end

link node[:sonar][:dir] do
  to "/opt/sonar-#{node[:sonar][:version]}"
end

link '/etc/init.d/sonar' do
  to "#{node[:sonar][:dir]}/bin/#{node[:sonar][:os_kernel]}/sonar.sh"
end

service 'sonar' do
  supports :status => true, :restart => true, :start => true, :stop => true
  action [:enable, :start]
end

template 'sonar.properties' do
  path "#{node[:sonar][:dir]}/conf/sonar.properties"
  source 'sonar.properties.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables(
    :options => node[:sonar][:options]
  )
  notifies :restart, 'service[sonar]'
end

template 'wrapper.conf' do
  path "#{node[:sonar][:dir]}/conf/wrapper.conf"
  source 'wrapper.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[sonar]'
end

