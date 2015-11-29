#
# Author:: Jake Vanderdray <jvanderdray@customink.com>
# Cookbook Name:: nrpe
# Provider:: check
#
# Copyright 2011, CustomInk LLC
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

def whyrun_supported?
  true
end

action :add do
  Chef::Log.info "Adding #{new_resource.command_name} to #{node['nrpe']['conf_dir']}/nrpe.d/"
  command = new_resource.command || "#{node['nrpe']['plugin_dir']}/#{new_resource.command_name}"
  file_contents = "command[#{new_resource.command_name}]=#{command}"
  file_contents += " -w #{new_resource.warning_condition}" unless new_resource.warning_condition.nil?
  file_contents += " -c #{new_resource.critical_condition}" unless new_resource.critical_condition.nil?
  file_contents += " #{new_resource.parameters}" unless new_resource.parameters.nil?
  f = file "#{node['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg" do
    owner node['nrpe']['user']
    group node['nrpe']['group']
    mode '0640'
    content file_contents
    notifies node['nrpe']['check_action'], "service[#{node['nrpe']['service_name']}]"
  end
  new_resource.updated_by_last_action(f.updated_by_last_action?)
end

action :remove do
  if ::File.exist?("#{node['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg")
    Chef::Log.info "Removing #{new_resource.command_name} from #{node['nrpe']['conf_dir']}/nrpe.d/"
    f = file "#{node['nrpe']['conf_dir']}/nrpe.d/#{new_resource.command_name}.cfg" do
      action :delete
      notifies node['nrpe']['check_action'], "service[#{node['nrpe']['service_name']}]"
    end
    new_resource.updated_by_last_action(f.updated_by_last_action?)
  end
end
