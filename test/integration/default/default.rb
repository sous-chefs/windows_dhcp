describe windows_feature('DHCPServer', :dism) do
  it{ should be_installed }
end

describe windows_feature('ServerManager-Core-RSAT', :dism) do
  it{ should be_installed }
end

describe windows_feature('ServerManager-Core-RSAT-Role-Tools', :dism) do
  it{ should be_installed }
end

describe windows_feature('DHCPServer-Tools', :dism) do
  it{ should be_installed }
end