$Output= @()
$names = Get-content "target-IPs.txt"
$pcname = $env:COMPUTERNAME
$host.ui.RawUI.WindowTitle = “NET-Watcher#by gpdl”

while ($true) {
    foreach ($name in $names){
      $Time = (Get-Date).ToString(“HH:mm:ss”)
      $Date = Get-Date -Format dd.MM.yyyy
      $response = (Test-Connection -ComputerName $name -Count 2 -BufferSize 30 -ErrorAction SilentlyContinue | measure-Object -Property ResponseTime -Average).average
      if ($response -ne $null){
        $response = ($response -as [int] ) 
        $Output+= "$Date,$Time,$name,up,$response ms,$pcname"
        Write-Host "$Date,$Time,$Name,up,$response ms" -ForegroundColor Green
      }else{
        $Output+= "$Date,$Time,$name,down,no response"
        Write-Host "$Date,$Time,$Name,down,no response" -ForegroundColor Red
        #Invoke-RestMethod -Uri "https://api.telegram.org/bot6406804286:AAFaKrN5-XBc8Ub68coxGz-yb6ClMQf7YCA/sendMessage?chat_id=-4118484809&text=$pcname->$Name-caiu-" -Method Post
      }
    }
    $Output | Out-file ping-logs.csv
    #Checking IPs each 5 seconds:
    Start-Sleep -Seconds 5
}