#
# Cookbook Name:: windows_dhcp
# Resource:: scope
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
attribute :startrange, :kind_of => String, :regex => Resolv::IPv4::Regex, :required => true
attribute :endrange, :kind_of => String, :regex => Resolv::IPv4::Regex, :required => true
attribute :subnetmask, :kind_of => String, :regex => Resolv::IPv4::Regex, :required => true
attribute :computername, :kind_of => String
attribute :description, :kind_of => String
attribute :version, :kind_of => String, :default => '4'

#  Optional params shared
#    AsJob
#    CimSession
#    State: string
#    ThrottleLimit: int32

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

