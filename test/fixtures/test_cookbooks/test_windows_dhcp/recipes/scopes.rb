#
# Cookbook Name:: windows_dhcp
# Recipe:: scopes
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

windows_dhcp_scope 'Test' do
  scopeid '10.0.0.0'
  startrange '10.0.0.1'
  endrange '10.0.0.254'
  subnetmask '255.255.255.0'
  action :create
end

windows_dhcp_scope 'Test-Copy' do
  scopeid '10.0.0.0'
  startrange '10.0.0.1'
  endrange '10.0.0.254'
  subnetmask '255.255.255.0'
  action :create
end

windows_dhcp_scope 'Test1' do
  scopeid '10.0.10.0'
  startrange '10.0.10.1'
  endrange '10.0.10.254'
  subnetmask '255.255.255.0'
  action :create
end

windows_dhcp_scope 'Test1' do
  scopeid '10.0.10.0'
  action :delete
end

windows_dhcp_scope 'Test2' do
  scopeid '10.0.20.0'
  action :delete
end