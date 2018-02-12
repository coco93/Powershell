# ftp the entire folder into server (including folders and subfolders) 

function CreateDirD {
    param(
      [Parameter(Mandatory=$true)]
      [string]
      $Dir,
      
      [Parameter(Mandatory=$true)]
      [string]
      $ServerDir)

foreach ($item in Get-ChildItem $Dir ) {
    $webclient = New-Object System.Net.WebClient 
    $webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass) 

    if ($item.Attributes -ne "Directory"){
        $uri = New-Object System.Uri("$ServerDir/$item") 
        $webclient.UploadFile($uri,$item.FullName) 
    } 
    else {
        Create-FtpDirectory -sourceuri "$ServerDir/$item" -username $user -password $pass
        $newDir = "$Dir\$item" 
        $newServerDir = "$ServerDir/$item"
        CreateDirD -Dir $newDir -ServerDir $newServerDir
        Write-Host $Dir 
        Write-Host $servername
    }
}  
}

#Craps (WIP)
$Dir="C:\Users\cocowu\iac\functionapp"    
 
$webclient = New-Object System.Net.WebClient 
 
$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)  
 
#ftp every files inside functionapp to server

foreach($item in (dir $Dir)){ 
    "Uploading $item..." 
    $a = Get-ChildItem $item
    if ($a.count = 0) 
    {
        $uri = New-Object System.Uri("$servername/$item") 
        $webclient.UploadFile($uri, $item.FullName) 
    }
 } 
foreach ($item in Get-ChildItem $Dir ) {
    $a = Get-ChildItem $item
    Write-Host $a
}


function Create-FtpDirectory {
    param(
      [Parameter(Mandatory=$true)]
      [string]
      $sourceuri,
      [Parameter(Mandatory=$true)]
      [string]
      $username,
      [Parameter(Mandatory=$true)]
      [string]
      $password
    )
    if ($sourceUri -match '\\$|\\\w+$') { throw 'sourceuri should end with a file name' }
    $ftprequest = [System.Net.FtpWebRequest]::Create($sourceuri);
    $ftprequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
    $ftprequest.UseBinary = $true
  
    $ftprequest.Credentials = New-Object System.Net.NetworkCredential($username,$password)
  
    $response = $ftprequest.GetResponse();
  
    Write-Host Upload File Complete, status $response.StatusDescription
  
    $response.Close();
  }


Create-FtpDirectory -sourceuri "$servername/Azurefunctions" -username $user -password $pass
function CreateDir {
    param(
      [Parameter(Mandatory=$true)]
      [string]
      $Dir,
      
      [Parameter(Mandatory=$true)]
      [string]
      $ServerDir)

foreach ($item in Get-ChildItem $Dir ) {
    $webclient = New-Object System.Net.WebClient 
    $webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass) 

    if ($item.Attributes -ne "Directory"){
        $uri = New-Object System.Uri("$ServerDir/$item") 
        $webclient.UploadFile($uri,$item.FullName) 
    } 
    else {
        Create-FtpDirectory -sourceuri "$ServerDir/$item" -username $user -password $pass
        $Dir = "$Dir\$item" 
        $newServerDir = "$ServerDir/$item"
        Write-Host $Dir 
        Write-Host $servername
    }
}
    if ($ServerDir -ne $newServerDir ) { 
        CreateDir -Dir $Dir -ServerDir $newServerDir
    }
}
