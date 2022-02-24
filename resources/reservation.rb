#
# Cookbook:: windows_dhcp
# Resource:: reservation
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

unified_mode true

property :reservation_name, String, name_property: true
property :scopeid, String, regex: (Resolv::IPv4::Regex || Resolv::IPv6::Regex), required: true
property :ipaddress, String, regex: (Resolv::IPv4::Regex || Resolv::IPv6::Regex), required: true
property :macaddress, String, required: true
property :computername, String
property :description, String
property :version, String, default: '4'

#  Optional params shared
#    AsJob
#    CimSession
#    passthru: string
#    ThrottleLimit: int32
#    Type: string

#  Optional params IPv4
#    ActivatePolicies: Boolean, default true;
#    Delay: int16;
#    LeaseDuration: day.hrs:mins:secs;
#    MaxBootpClients: int32;
#    NapEnable:
#    NapProfile:
#    SuperScoeName: String
#    Type: String

#  Optional params IPv6
#    PassThru
#    Preference: int16
#    PreferenceLifeTime:
#    Prefix: IPAddress
#    T1:
#    T2:
#    ValidLifeTime:

action :create do
  if exists?
    Chef::Log.debug("The reservation #{new_resource.reservation_name} already exists")
  else
    converge_by("create reservation #{new_resource.reservation_name}") do
      cmd = 'Add-DhcpServerv6Reservation' if new_resource.version == '6'
      cmd = 'Add-DhcpServerv4Reservation' if new_resource.version == '4'
      # Allow use of : in macmacaddress
      hwaddress = new_resource.macaddress.gsub(':', '-')
      cmd << " -scopeid #{new_resource.scopeid}"
      cmd << " -IPAddress #{new_resource.ipaddress}"
      cmd << " -clientid #{hwaddress}"
      cmd << " -name #{new_resource.reservation_name}"
      #      cmd << " -description #{new_resource.description}"
      # Optional hash needed

      powershell_out!(cmd).run_command
    end
  end
end

action :delete do
  if exists?
    converge_by("delete reserveation #{new_resource.reservation_name}") do
      cmd = 'Remove-DhcpServerv6Reservation' if new_resource.version == '6'
      cmd = 'Remove-DhcpServerv4Reservation' if new_resource.version == '4'
      # Allow use of : in macmacaddress
      cmd << " -IPAddress #{new_resource.ipaddress}"

      powershell_out!(cmd).run_command
    end
  else
    Chef::Log.debug("The reservation #{new_resource.reservation_name} was not found")
  end
end

action :update do
  if exists?
    cmd = 'Set-DhcpServerv6Reservation' if new_resource.version == '6'
    cmd = 'Set-DhcpServerv4Reservation' if new_resource.version == '4'
    hwaddress = new_resource.macaddress.gsub(':', '-')
    cmd << " -IPAddress #{new_resource.ipaddress}"
    cmd << " -clientid #{hwaddress}"
    cmd << " -name #{new_resource.reservation_name}"

    powershell_script "update_DhcpServerv#{new_resource.version}Reservation_#{new_resource.reservation_name}" do
      code cmd
    end
  end
end

action_class do
  def exists?
    cmd = 'Get-DhcpServerv6Reservation' if new_resource.version == '6'
    cmd = 'Get-DhcpServerv4Reservation' if new_resource.version == '4'
    cmd << " -scopeid #{new_resource.scopeid}"
    check = powershell_out(cmd.to_s).run_command
    check.stdout.include?(new_resource.scopeid)
  end
end
