zones = data_bag('zones-sta')

Chef::Log.error('Data bag cannot be empty') if zones.empty?

zones.each do |scope|

  scope_info = data_bag_item('zones', scope)
  
  windows_dhcp_scope(scope) do
    action [:create]
    name scope_info['id']
    scopeid scope_info['network']
    startrange scope_info['startrange']
    endrange scope_info['endrange']
    subnetmask scope_info['netmask']
  end
end
