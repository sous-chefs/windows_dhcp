#
# Cookbook Name:: windows_dhcp
# Resource:: lease
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

actions :create, :delete
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :ipaddress, :kind_of => String, :regex => (Resolv::IPv4::Regex or Resolv::IPv6::Regex), :required => true
attribute :scopeid, :kind_of => String, :regex => (Resolv::IPv4::Regex or Resolv::IPv6::Regex), :required => true
attribute :macaddress, :kind_of => String, :required => true
attribute :leaseexpirytime, :kind_of => String #Regex for YYYY-MM-DD HH:MM:SS?
attribute :description, :kind_of => String
attribute :version, :kind_of => String, :default => '4'
attribute :computername, :kind_of => String

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

