windows_dhcp Cookbook
=====================
[![Join the chat at https://gitter.im/TAMUArch/cookbook.windows_dhcp](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/TAMUArch/cookbook.windows_dhcp?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
This cookbook installs the DHCP on Windows Server including all necessary roles and features.

Requirements
============

Platform
--------

* Windows Server 2008 R2 Family
* Windows Server 2012 Family

Cookbooks
---------

- Windows - Official windows cookbook from opscode https://github.com/opscode-cookbooks/windows.git

Usage
-----
#### windows_dhcp::default

e.g.
Just include `windows_dhcp` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[windows_dhcp]"
  ]
}
```

Resource/Provider
=================

`lease`
--------

### Actions
- :create: Creates a lease entry
- :delete: Deletes a lease entry

### Attribute Parameters

- name: name attribute. Name of the lease entry.
- comptername: Name of the DHCP server.
- description: Description field entry.
- ipaddress: IPv4 or IPv6 address or the lease entry. **Required** Regex: IPv4 or IPv6
- leaseexpirytime: Time to expire the lease. Regex for YYYY-MM-DD HH:MM:SS
- macaddress: MAC Address for the lease entry. Note: Any use of '-' or ':' will be removed.
- scopeid: IPv4 or IPv6 scope ex. 192.168.1.1 **Required** Regex: IPv4 or IPv6
- version: Version of IP address.  Default 4 Available Options (4, 6)

### Examples
```ruby
    # Create lease entry of workstation at 192.168.1.10
    windows_dhcp_lease 'workstation' do
      action :create
      ipaddress '192.168.1.10'
      scopeid '192.168.1.1'
    end
```
`reservation`
--------

### Actions
- :create: Creates a reservation entry
- :delete: Deletes a reservation entry
- :update: Updates a reservation entry

### Attribute Parameters

- name: name attribute. Name of the reservation entry.
- comptername: Name of the DHCP server.
- description: Description field entry.
- ipaddress: IPv4 or IPv6 address or the reservation entry. **Required** Regex: IPv4 or IPv6
- macaddress: MAC Address for the reservation entry. Note: Any use of '-' or ':' will be removed. **Required**
- scopeid: IPv4 or IPv6 scope ex. 192.168.1.1 **Required** Regex: IPv4 or IPv6
- version: Version of IP address.  Default 4 Available Options (4, 6)

### Examples
```ruby
    # create reservation entry of 'workstation' at 192.168.1.10 with mac address of '00-00-00-00-00-00'
    windows_dhcp_reservation 'workstation' do
      action :create
      ipaddress '192.168.1.10'
      scopeid '192.168.1.1'
      macaddress '00-00-00-00-00-00'
    end
    
    # delete reservation entry of 'workstation' at 192.168.1.10
    windows_dhcp_reservation 'workstation' do
      action :delete
      scopeid '192.168.1.1'
    end
    
    # update reservation entry of 'workstation' at 192.168.1.10 with mac address of '00-00-00-00-00-10'
    windows_dhcp_reservation 'workstation' do
      action :update
      ipaddress '192.168.1.10'
      macaddress '00-00-00-00-00-10'
      scopeid '192.168.1.1'
    end
```
`scope`
--------

### Actions
- :create: Creates a reservation entry
- :delete: Deletes a reservation entry
- :update: Updates a reservation entry

### Attribute Parameters

- name: name attribute.  Name of the scope entry.
- computername: Name of the DHCP server.
- description: Description field entry.
- endrange: Ending IP of the scope. Regex: IPv4 or IPv6
- scopeid: IPv4 or IPv6 scope ex. 192.168.1.1 **Required** Regex: IPv4 or IPv6
- startrange: Staring IP of the scope.  Regex: IPv4 or IPv6
- subnetmask: Subnet mask address of the scope. Regex: IPv4 or IPv6
- version: Version of IP address.  Default 4 Available Options (4, 6)

### Examples

    # Create scope 'Internal' of '192.168.1.1' with starting ip of '192.168.1.10' and ending IP of '192.168.1.250'
    windows_dhcp_scope 'Internal' do
      action :create
      startrange '192.168.1.10'
      endrange '192.168.1.250'
      subnetmask '255.255.255.0'
      scopeid '192.168.1.1'
    end
```ruby

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors:: Derek Groh (<dgroh@arch.tamu.edu>)
