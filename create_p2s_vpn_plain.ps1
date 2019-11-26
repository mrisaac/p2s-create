$vpnfqdn = "azuregateway-{REPLACE}.vpn.azure.com"
$vpnname = "{REPLACE}-Azure-VPN"

Add-VpnConnection -Name $vpnname -ServerAddress $vpnfqdn #-AllUserConnection $true -RememberCredential $true -SplitTunneling $true -TunnelType Automatic -EncryptionLevel Required -AuthenticationMethod Eap
$vpn = Get-VPNConnection -name $vpnname
#Set-VpnConnection -Name $vpnname -AllUserConnection $true 
#Set-VpnConnection -Name $vpnname -RememberCredential $true
#Set-VpnConnection -Name $vpnname -EncryptionLevel Required 
$vpn.AllUserConnection = $true
$vpn.RememberCredential = $true
$vpn.EncryptionLevel = 'Required'

Add-VpnConnectionRoute -ConnectionName $vpnname -DestinationPrefix "10.x.0.0/20" #DC IP Address Ranges (10.64.0.0 - 10.64.15.255)
Add-VpnConnectionRoute -ConnectionName $vpnname -DestinationPrefix "10.x.0.0/20" #Azure IP Address Ranges (10.64.0.0 - 10.64.15.255)

Write-host "VPN Configured"
