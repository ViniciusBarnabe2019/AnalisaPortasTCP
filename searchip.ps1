##Obtém lista de Ips consumindo Portas TCP abertas na rede
$remoteAddresses = (Get-NetTCPConnection | Select-Object -ExpandProperty RemoteAddress) -split ' '

##Arquivo texto que armazenará os dados obtidos
$file = "$env:USERPROFILE\Desktop\dadosIp.txt"

##Percorre o array de ips
foreach ($ip in $remoteAddresses) {
    ##Se o índice for diferente de 0.0.0.0, :: ou 127.0.0.1 sigfnica q o IP é Remoto e possivelmente válido
    if ($ip -ne '0.0.0.0' -and $ip -ne '::' -and $ip -ne '127.0.0.1') {
        ##Endereço da Api que irá consulta a procedência do IP
        $url = "https://api.iplocation.net/?ip=$ip"

        ##Faz a requisição a API
        $response = Invoke-RestMethod -Uri $url

        ##Adiciona/Escreve os dados no arquivo txt mesmo se ele n existir
        Add-Content -Path $file "IP: $ip" -Force
        Add-Content -Path $file "País: $($response.country_name)" -Force
        Add-Content -Path $file "Provedor: $($response.isp)" -Force
        Add-Content -Path $file "Versão IP $($response.ip_version)" -Force
        Add-Content -Path $file "------------------------------------" -Force
    }
}