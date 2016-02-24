scopes = data_bag('scopes')

Chef::Log.error('Data bag cannot be empty') if scopes.empty?

scopes.each do |scope|

  scope_info = data_bag_item('scopes', scope)
  
  windows_dhcp_scope(scope) do
    action [:create]
    name scope_info['id']
    scopeid scope_info['network']
    startrange scope_info['startrange']
    endrange scope_info['endrange']
    subnetmask scope_info['netmask']
  end

  hosts = scope_info['hosts']
  
  hosts.each do |host, option|
    windows_dhcp_reservation host do
      action [:create]
      scopeid scope_info['scopeid']
      ipaddress option['ip']
      macaddress option['mac']
      computername scope_info['computername']
      description option['description']
    end
  end
end
