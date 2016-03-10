#
# Cookbook Name:: windows_dhcp
# Provider:: reservation
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
	Chef::Log.info("The reservation #{new_resource.name} already exists")
  else
    if node[:os_version] >= "6.2"
	  Chef::Log.debug("Windows Server 2012 Family Detected")
	  if new_resource.version == '6'
	    cmd = "Add-DhcpServerv6Reservation"
	  end
	  if new_resource.version == '4'
	    cmd = "Add-DhcpServerv4Reservation"
	  end
	  # Allow use of : in macmacaddress
      hwaddress = new_resource.macaddress.gsub(':','-')
	  cmd << " -scopeid #{new_resource.scopeid}"
      cmd << " -IPAddress #{new_resource.ipaddress}"
      cmd << " -clientid #{hwaddress}"
      cmd << " -name #{new_resource.name}"
#      cmd << " -description #{new_resource.description}"
      # Optional hash needed
	  
	  if new_resource.version == '6'
	    powershell_script "create_DhcpServerv6Reservation_#{new_resource.name}" do
		  code cmd
		end
	  end
	  if new_resource.version == '4'
	    powershell_script "create_DhcpServerv4Reservation_#{new_resource.name}" do
		  code cmd
		end
	  end
    else
	    # Server 2008
	    Chef::Log.debug("Windows Server 2008 Family Detected")
	end
	new_resource.updated_by_last_action(true)
    Chef::Log.info("The reservation #{new_resource.name} was created")
  end
end


action :delete do
  if exists?
    new_resource.updated_by_last_action(true)
    Chef::Log.info("The reservation #{new_resource.name} was found, deleting")
    if node[:os_version] >= "6.2"
	  Chef::Log.debug("Windows Server 2012 Family Detected")
	  if new_resource.version == '6'
	    cmd = "Remove-DhcpServerv6Reservation"
	  end
	  if new_resource.version == '4'
	    cmd = "Remove-DhcpServerv4Reservation"
	  end
	  # Allow use of : in macmacaddress
      cmd << " -IPAddress #{new_resource.ipaddress}"

	  
	  if new_resource.version == '6'
	    powershell_script "delete_DhcpServerv6Reservation_#{new_resource.name}" do
		  code cmd
		end
	  end
	  if new_resource.version == '4'
	    powershell_script "delete_DhcpServerv4Reservation_#{new_resource.name}" do
		  code cmd
		end
	  end
    else
	  # Server 2008
	  Chef::Log.debug("Windows Server 2008 Family Detected")
	end
  else
	new_resource.updated_by_last_action(false)
	Chef::Log.info("The reservation #{new_resource.name} was not found")
  end
end

action :update do
  if exists?
    if node['os_version'] >= '6.2'
      Chef::Log.debug('Windows Server 2012 Family Detected')
      if new_resource.version == '6'
        cmd = 'Set-DhcpServerv6Reservation'
      elsif new_resource.version == '4'
        cmd = 'Set-DhcpServerv4Reservation'
      else
        Chef::Log.error("DHCP version must be '4' or '6'")
      end
      hwaddress = new_resource.macaddress.gsub(':','-')
      cmd << " -IPAddress #{new_resource.ipaddress}"
      cmd << " -clientid #{hwaddress}"
      cmd << " -name #{new_resource.name}"
      if new_resource.version == '6'
	    powershell_script "update_DhcpServerv6Reservation_#{new_resource.name}" do
		  code cmd
		end
	  end
	  if new_resource.version == '4'
	    powershell_script "update_DhcpServerv4Reservation_#{new_resource.name}" do
		  code cmd
		end
      end
    end
  else
    # Server 2008
    Chef::Log.debug("Windows Server 2008 is not currently supported")
  end
end

def exists?
#  if node[:os_version] >= "6.2"
    if new_resource.version == '6' 
      check = Mixlib::ShellOut.new("powershell.exe \"Get-DhcpServerv6Reservation -scopeid #{new_resource.scopeid}\"").run_command
	  check.stdout.include?(new_resource.name)
    end
	if new_resource.version == '4' 
      check = Mixlib::ShellOut.new("powershell.exe \"Get-DhcpServerv4Reservation -scopeid #{new_resource.scopeid}\"").run_command
	  check.stdout.include?(new_resource.name)
    end
#  end
end