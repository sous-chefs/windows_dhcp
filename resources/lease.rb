#
# Cookbook:: windows_dhcp
# Resource:: lease
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

property :lease_name, String, name_property: true
property :ipaddress, String, regex: (Resolv::IPv4::Regex || Resolv::IPv6::Regex), required: true
property :scopeid, String, regex: (Resolv::IPv4::Regex || Resolv::IPv6::Regex), required: true
property :macaddress, String, required: true
property :leaseexpirytime, String # Regex for YYYY-MM-DD HH:MM:SS?
property :description, String
property :version, String, default: '4'
property :computername, String

#  Optional params shared
#    AsJob
#    CimSession
#    ClientType: String
#    Computername: string
#    DnsRegistration: string
#    DnsRR: String
#    Hostname: string
#    LeaseExpiryTime: Datetime
#    NapCapable: boolean
#    NapStatus: String
#    passthru: string
#    PolicyName: string
#    ThrottleLimit: int32

#  Optional params IPv4
#    AddressState: String
#    ProbationEnds: datetime

#  Optional params IPv6
#    Addresstype: string IANA IATA
#    ClientDuid: string
#    iaid: int32

action :create do
  if exists?
    Chef::Log.debug("The lease #{new_resource.lease_name} already exists")
  else
    converge_by "create lease #{new_resource.lease_name}" do
      if new_resource.version == '6'
        cmd = 'Add-DhcpServerv6Lease'
      end
      if new_resource.version == '4'
        cmd = 'Add-DhcpServerv4Lease'
      end

      # Allow use of : in macmacaddress
      hwaddress = new_resource.macaddress.gsub(':', '-')
      cmd << " -IPAddress #{new_resource.ipaddress}"
      cmd << " -scopeid #{new_resource.scopeid}"
      cmd << " -clientid #{hwaddress}"
      #      cmd << " -leaseexpirytime #{new_resource.leaseexpirytime}"
      #      cmd << " -description #{new_resource.description}"
      # Optional hash needed

      powershell_out!(cmd).run_command
    end
  end
end

action :delete do
  if exists?
    converge_by("delete lease #{new_resource.lease_name}") do
      if new_resource.version == '6'
        cmd = 'Remove-DhcpServerv6lease'
      end
      if new_resource.version == '4'
        cmd = 'Remove-DhcpServerv4lease'
      end
      #    cmd << " -scopeid #{new_resource.scopeid}"
      cmd << " -IPAddress #{new_resource.ipaddress}"

      powershell_out!(cmd).run_command
    end
  else
    Chef::Log.debug("The lease #{new_resource.lease_name} was not found")
  end
end

action_class do
  def exists?
    if new_resource.version == '6'
      check = powershell_out("Get-DhcpServerv6Lease -ipaddress #{new_resource.ipaddress}").run_command
      check.stdout.include?(new_resource.ipaddress)
    end
    if new_resource.version == '4'
      check = powershell_out("Get-DhcpServerv4Lease -ipaddress #{new_resource.ipaddress}").run_command
      check.stdout.include?(new_resource.ipaddress)
    end
  end
end
