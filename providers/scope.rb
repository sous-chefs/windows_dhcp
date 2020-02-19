#
# Cookbook:: windows_dhcp
# Provider:: scope
#
# Copyright:: 2014, Texas A&M
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

action :create do
  if exists?
    new_resource.updated_by_last_action(false)
    Chef::Log.info("The scope #{new_resource.name} #{new_resource.scopeid} already exists")
  else
    # Required: Startrange, Endrange, subnetmask, name
    if node['os_version'] >= '6.2'
      Chef::Log.debug('Windows Server 2012 Family Detected')
      if new_resource.version == '6'
        cmd = 'Add-DhcpServerv6Scope'
      end
      if new_resource.version == '4'
        cmd = 'Add-DhcpServerv4Scope'
      end

      cmd << " -StartRange #{new_resource.startrange}"
      cmd << " -EndRange #{new_resource.endrange}"
      cmd << " -Name \"#{new_resource.name}\""
      cmd << " -SubnetMask #{new_resource.subnetmask}"
      # Optional hash needed

      if new_resource.version == '6'
        powershell_script "create_DhcpServerv6Scope_#{new_resource.name}" do
          code cmd
        end
      end
      if new_resource.version == '4'
        powershell_script "create_DhcpServerv4Scope_#{new_resource.name}" do
          code cmd
        end
      end
    else
      # Server 2008
      Chef::Log.debug('Windows Server 2008 Family Detected')
    end
    new_resource.updated_by_last_action(true)
    Chef::Log.info("The scope #{new_resource.name} #{new_resource.scopeid} was created")
  end
end

action :delete do
  if exists?
    new_resource.updated_by_last_action(true)
    Chef::Log.info("The scope #{new_resource.name} #{new_resource.scopeid} exists, deleting")
    if node['os_version'] >= '6.2'
      Chef::Log.debug('Windows Server 2012 Family Detected')
      if new_resource.version == '6'
        cmd = 'Remove-DhcpServerv6Scope'
      end
      if new_resource.version == '4'
        cmd = 'Remove-DhcpServerv4Scope'
      end

      cmd << " -scopeid \"#{new_resource.scopeid}\""
      # Optional hash needed

      if new_resource.version == '6'
        powershell_script "delete_DhcpServerv6Scope_#{new_resource.name}" do
          code cmd
        end
      end
      if new_resource.version == '4'
        powershell_script "delete_DhcpServerv4Scope_#{new_resource.name}" do
          code cmd
        end
      end
    else
      # Server 2008
      Chef::Log.debug('Windows Server 2008 Family Detected')
    end
    new_resource.updated_by_last_action(false)
    Chef::Log.info("The scope #{new_resource.name} #{new_resource.scopeid} was not found")
  end
end

def exists?
  #  if node[:os_version] >= '6.2'
  if new_resource.version == '6'
    check = Mixlib::ShellOut.new("powershell.exe \"Get-DhcpServerv6Scope -scopeid #{new_resource.scopeid}\"").run_command
    check.stdout.include?(new_resource.scopeid)
  end
  if new_resource.version == '4'
    check = Mixlib::ShellOut.new('powershell.exe "Get-DhcpServerv4Scope | fl scopeid"').run_command
    check.stdout.include?(new_resource.scopeid)
  end
  #  end
end
