# ######################################################################################################################
# Validar servidor DNS buscando un nombre y contrastando la IP que devuelve con la que debería devolver
# Check DNS by asking $server for a well known $lookup name and comparing to $correct_result 
function check_dns($server,$lookup,$correct_result){
    try{
        $dns=(Resolve-DnsName -Name $lookup -Server $server -TcpOnly -Type A -NoHostsFile -ErrorAction Stop)
        $addr=$dns.IPAddress
        if( $addr -contains $correct_result){
            Write-Output "INFO: [$server] is OK" # comment out if you want to focus on eithre lying or misconfigured/dumb dns servers
        } else {Write-Output "ERROR VALUE: DNS Server [$server] thinks $lookup IP is [$addr] instead of [$correct_result]"}
        
    }
    catch{ 
        $err_msg=$Error[0].ToString()
        # Fails too often, $server_name=([system.net.dns]::GetHostByAddress($server)).HostName
        # Write-Output "ERROR: DNS Server [$server] - [$server_name] $err_msg"
        Write-Output "ERROR: DNS Server [$server] $err_msg"
        }
}
# ######################################################################################################################

# Ya puestos vamos a probarlo
# Empezamos con una lista de servidores vacía
$dnslist =@()

# Validamos nuestros DNS locales 
$my_interfaces=Get-NetIPInterface -ConnectionState Connected -AddressFamily IPv4
$my_interfaces | %{$dnslist +=(Get-DnsClientServerAddress -InterfaceIndex $_.ifIndex -AddressFamily IPv4).ServerAddresses}

# Y los DNS que aparecen como DNS españoles por estar en España 
$dnslist += (iwr https://public-dns.info/nameserver/es.txt).Content.Split([Environment]::NewLine)

# Validamos parler.com y usamos la direccion IP que nos da un listo más de los que hay por la red https://www.nslookup.io/dns-records/parler.com

$dnslist | %{ check_dns $_ parler.com  216.246.208.249 }

# ######################################################################################################################

# Set decent non censoring DNS run this as Admin 
# $good_dns = "resolver1.opendns.com","resolver2.opendns.com","resolver3.opendns.com"| %{ (Resolve-Dnsname -Name $_ -Type A).IPAddress }
# Set-DnsClientServerAddress -InterfaceAlias Wi-Fi -ServerAddresses $good_dns

# Revert DHCP DNS
# Set-DnsClientServerAddress -InterfaceAlias Wi-Fi -ResetServerAddresses
# Check if they still block parler
# Resolve-Dnsname -Name parler.com
