$vpnfqdn = "azuregateway-{REPLACE}.vpn.azure.com"
$vpnname = "{REPLACE}-Azure-VPN"
#Get The Details from the users
#$vpn = Get-VPNConnection -name $vpnname
Write-Host "Are You accessing this VPN Connection from 1) Home/External 2) HQ or 3)The Datacenter"
$location = Read-host -Prompt "Enter 1, 2, or 3"
if($location -gt 0 -and $location -lt 4)
{


    Add-VpnConnection -Name $vpnname -ServerAddress $vpnfqdn #-AllUserConnection $true -RememberCredential $true -SplitTunneling $true -TunnelType Automatic -EncryptionLevel Required -AuthenticationMethod Eap
    $vpn = Get-VPNConnection -name $vpnname
    #Set-VpnConnection -Name $vpnname -AllUserConnection $true 
    #Set-VpnConnection -Name $vpnname -RememberCredential $true
    #Set-VpnConnection -Name $vpnname -EncryptionLevel Required 
    $vpn.AllUserConnection = $true
    $vpn.RememberCredential = $true
    $vpn.EncryptionLevel = 'Required'



    #IF @ HOME We want all the routes
    Add-VpnConnectionRoute -ConnectionName $vpnname -DestinationPrefix "10.x.0.0/20" #DC IP Address Ranges (10.64.0.0 - 10.64.15.255)
    
    if ($location -ne "3")
    {
        #If the location does not equal DC add the DC Routes
        Add-VpnConnectionRoute -ConnectionName $vpnname -DestinationPrefix "10.x.0.0/20" #DC IP Address Ranges (10.0.0.0 - 10.0.15.255)
    }
    if ($location -ne "2")
    {
        #If location does not equal HQ add the add the HQ Routes
        Add-VpnConnectionRoute -ConnectionName $vpnname -DestinationPrefix "192.168.x.0/24" #HQ IP Address Ranges (192.168.0.0 - 192.168.0.255)

    }

Write-host "VPN Configured"
}
else {write-host "Invalid Input, exiting"}
