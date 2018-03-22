param(
    [Parameter(Mandatory = $True)]
    [string]
    $credsFilePath,

    [Parameter(Mandatory = $True)]
    [string]
    $subscriptionName,

    [Parameter(Mandatory = $True)]
    [string]
    $configFileName  
)

# sign in
Write-Host "Logging in...";
Import-AzureRmContext -Path $credsFilePath  -erroraction stop

# select subscription name
Write-Host "Selecting subscription '$subscriptionName'";
Select-AzureRmSubscription -SubscriptionName $subscriptionName -erroraction stop

$tag = @{
    ApplicationCode = "nsr"
    business_unit = "Enterprise-Global"
    dr_class = 1
    infra_msp = "Capgemini"
    managed_service_tier = 3
    security_tier = 1
    terraform_managed = "not_managed"
}

$configjson = (Get-Content $configFileName | Out-String | ConvertFrom-Json)
foreach ($group in $configjson.task) {
    Set-AzureRmResourceGroup -Name $group.resourceGroup -Tag $tag
    $tags = (Get-AzureRmResourceGroup -Name $group.resourceGroup).Tags
    $tags += @{environment = $group.environment}
    Set-AzureRmResourceGroup -Tag $tags -Name $group.resourceGroup 
}
