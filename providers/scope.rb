#
# Cookbook Name:: windows_dhcp
# Provider:: scope
#
# Copyright 2014, Texas A&M
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require 'mixlib/shellout'

action :create do
#  if exists?
#    new_resource.updated_by_last_action(false)
#	Chef::Log.debug("The scope already exists")
#  else
    if node[:os_version] >= '6.2'
	  Chef::Log.debug("Windows Server 2012 Family Detected")
      if new_resource.version == '6'
         Chef::Log.debug("IPv6")
         powershell_script "create_DhcpServerv4Scope_#{new_resource.name}" do
	       code "Add-DhcpServerv4Scope -StartRange #{new_resource.startrange} -EndRange #{new_resource.endrange} -Name \"#{new_resource.name}\" -SubnetMask #{new_resource.subnetmask}"
		# Optional hash needed
         end
      else
	    Chef::Log.debug("Not IPv4")
	  end
	  if new_resource.version == '4'
        Chef::Log.debug("IPv4")
	    powershell_script "create_DhcpServerv4Scope_#{new_resource.name}" do
	      code "Add-DhcpServerv4Scope -StartRange #{new_resource.startrange} -EndRange #{new_resource.endrange} -Name \"#{new_resource.name}\" -SubnetMask #{new_resource.subnetmask}"
	   # Optional hash needed
	    end
	  else
	    Chef::Log.debug("Not IPv4")
	  end
    else
	  # Server 2008
	  Chef::Log.debug("Windows Server 2008 Family Detected")
	end
    new_resource.updated_by_last_action(true)
#  end
end

action :delete do
end

def exists?
  if node[:os_version] >= '6.2'
    check = Mixlib::ShellOut.new("powershell.exe -command 'Get-DhcpServer4Scope #{new_resource.name}'").run_command
	check.stdout.match(new_resource.name)
	Chef::Log.info(stdout)
  end
end