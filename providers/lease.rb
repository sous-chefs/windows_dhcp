#
# Cookbook Name:: windows_dhcp
# Provider:: lease
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
  if exists?
    new_resource.updated_by_last_action(false)
	Chef::Log.info("The lease #{new_resource.name} already exists")
  else
    if node[:os_version] >= "6.2"
	  Chef::Log.debug("Windows Server 2012 Family Detected")
	  if new_resource.version == '6'
	    cmd = "Add-DhcpServerv6Lease"
	  end
	  if new_resource.version == '4'
	    cmd = "Add-DhcpServerv4Lease"
	  end
	  
	  # Allow use of : in macmacaddress
      hwaddress = new_resource.macaddress.gsub(':','-')
	  cmd << " -IPAddress #{new_resource.ipaddress}"
	  cmd << " -scopeid #{new_resource.scopeid}"
      cmd << " -clientid #{hwaddress}"
#      cmd << " -leaseexpirytime #{new_resource.leaseexpirytime}"
#      cmd << " -description #{new_resource.description}"
      # Optional hash needed
	  
	  if new_resource.version == '6'
	    powershell_script "create_DhcpServerv6Lease_#{new_resource.name}" do
		  code cmd
		end
	  end
	  if new_resource.version == '4'
	    powershell_script "create_DhcpServerv4Lease_#{new_resource.name}" do
		  code cmd
		end
	  end
    else
	    # Server 2008
	    Chef::Log.debug("Windows Server 2008 Family Detected")
	end
	new_resource.updated_by_last_action(true)
    Chef::Log.info("The lease #{new_resource.name} was created")
  end
end


action :delete do
  if exists?
    new_resource.updated_by_last_action(true)
    Chef::Log.info("The lease #{new_resource.name} was found, deleting")
    if node[:os_version] >= "6.2"
	  Chef::Log.debug("Windows Server 2012 Family Detected")
	  if new_resource.version == '6'
	    cmd = "Remove-DhcpServerv6lease"
	  end
	  if new_resource.version == '4'
	    cmd = "Remove-DhcpServerv4lease"
	  end
#	  cmd << " -scopeid #{new_resource.scopeid}"
      cmd << " -IPAddress #{new_resource.ipaddress}"
	  
	  if new_resource.version == '6'
	    powershell_script "delete_DhcpServerv6lease_#{new_resource.name}" do
		  code cmd
		end
	  end
	  if new_resource.version == '4'
	    powershell_script "delete_DhcpServerv4lease_#{new_resource.name}" do
		  code cmd
		end
	  end
    else
	  # Server 2008
	  Chef::Log.debug("Windows Server 2008 Family Detected")
	end
  else
	new_resource.updated_by_last_action(false)
	Chef::Log.info("The lease #{new_resource.name} was not found")
  end
end

def exists?
#  if node[:os_version] >= "6.2"
    if new_resource.version == '6' 
      check = Mixlib::ShellOut.new("powershell.exe \"Get-DhcpServerv6Lease -ipaddress #{new_resource.ipaddress}\"").run_command
	  check.stdout.include?(new_resource.ipaddress)
    end
	if new_resource.version == '4' 
      check = Mixlib::ShellOut.new("powershell.exe \"Get-DhcpServerv4Lease -ipaddress #{new_resource.ipaddress}\"").run_command
	  check.stdout.include?(new_resource.ipaddress)
    end
#  end
end