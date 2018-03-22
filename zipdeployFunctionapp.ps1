#Kudo API to deploy zip file into server

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))
$apiUrl = "https://$functionAPPname.scm.azurewebsites.net/api/zip/site/wwwroot"
Invoke-RestMethod -Uri $apiUrl -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)} -Method PUT -InFile $functionappPath -ContentType "multipart/form-data" | Out-Null
