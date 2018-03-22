## Read parameters from parameters file
param(
[Parameter(Mandatory=$True)]
 [string]
 $parametersFile,

[Parameter(Mandatory=$True)]
 [string]
 $configFile,

 [Parameter(Mandatory=$True)]
 [string]
 $applicationPropertiesFile,

 [Parameter(Mandatory=$True)]
 [string]
 $jdbcPropertiesFile
)

$configfileName= $configFile
$configjson = (Get-Content $configfileName | Out-String | ConvertFrom-Json)
$configVals = $configjson.webappConfigVars

# create a jdbc object and add member to it first
$jdbc = New-Object PSObject
Add-Member -InputObject $jdbc -MemberType NoteProperty -Name url -Value ""
Add-Member -InputObject $jdbc -MemberType NoteProperty -Name username -Value ""
Add-Member -InputObject $jdbc -MemberType NoteProperty -Name password -Value ""

$AAD_TENANT = $configVals.tenantId
$AAD_CLIENT_ID=$configVals.webappClientId
$MANUAL_ESTIMATES_URL=$configVals.manualestimateURL
$CORPORATE_VOLUME_EXTRACT_URL=$configVals.corporatevolumeURL
$AZURE_ACCOUNT_NAME=$configVals.webappAcountName
$AZURE_ACCOUNT_KEY=$configVals.webappAcountKey

.\change_parametersFile.ps1    
    
$jdbc.url="jdbc:sqlserver://" + (Get-Content $parametersFile | Out-String | ConvertFrom-Json).parameters.serverName.value + ".database.windows.net:1433;database=" + (Get-Content "$parametersFile" | Out-String | ConvertFrom-Json).parameters.databaseName.value + ";encrypt=false;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
$jdbc.username= (Get-Content $parametersFile | Out-String | ConvertFrom-Json).parameters.administratorLogin.value
$jdbc.password=(Get-Content $parametersFile | Out-String | ConvertFrom-Json).parameters.administratorLoginPassword.value

$properties = @{
'AAD_TENANT' = $AAD_TENANT
'AAD_CLIENT_ID' = $AAD_CLIENT_ID
'MANUAL_ESTIMATES_URL' = $MANUAL_ESTIMATES_URL
'CORPORATE_VOLUME_EXTRACT_URL' = $CORPORATE_VOLUME_EXTRACT_URL
'AZURE_ACCOUNT_NAME' = $AZURE_ACCOUNT_NAME
'AZURE_ACCOUNT_KEY' = $AZURE_ACCOUNT_KEY
'jdbc.url' = $jdbc.url
'jdbc.username' = $jdbc.username
'jdbc.password' = $jdbc.password
}

$app = Get-Content .\$applicationPropertiesFile | 
     ForEach-Object{
          $key=$_.Split('=')[0]
          if($val = $properties[$key]){
            '{0}={1}' -f $key,$val
          }else{
              $_
          }        
     }
Set-Content .\$applicationPropertiesFile $app



$jdbc = Get-Content .\$jdbcPropertiesFile | 
     ForEach-Object{
          $key=$_.Split('=')[0]
          if($val=$properties[$key]){
              '{0}={1}' -f $key,$val
          }else{
              $_
          }
     }
Set-Content .\$jdbcPropertiesFile $jdbc

Write-Host "finished running parameters scripts"
