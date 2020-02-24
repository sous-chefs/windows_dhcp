include_recipe 'windows_ad::default'

user = 'Administrator'
pass = 'Passw0rd'
domain = 'contoso.local'

execute "net user \"#{user}\" \"#{pass}\""

windows_ad_domain domain do
  type           'forest'
  safe_mode_pass pass
  domain_pass    pass
  domain_user    user
  options ({ 'InstallDNS' => nil })
  action :create
end
