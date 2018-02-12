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
