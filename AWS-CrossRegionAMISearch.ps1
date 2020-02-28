param(
    [Parameter(Mandatory=$true)]
    [string]$amiName
)

$regionArray = @(
"us-east-1",
"us-east-2"#,
"us-west-1",
"us-west-2",
"ap-south-1",
"ap-northeast-2",
"ap-southeast-1",
"ap-southeast-2",
"ap-northeast-1",
#"ap-east-1", 
"ca-central-1",
# me-south-1,
"eu-central-1",
"eu-west-1",
"eu-west-2",
"eu-west-3",
"eu-north-1",
"sa-east-1"
)

try {    
    
    $document = foreach ($region in $regionArray)
        {
          $ami_search = aws ec2 describe-images --region $region --filter Name="owner-alias",Values="amazon" --filter Name="name",Values=$amiName | Select-String -Pattern "ImageId"
          $ami_id = $ami_search.ToString().Remove(0,23).TrimEnd('"',",").TrimStart('"')
          Write-Output $region
          Write-Output $ami_id
        }

    $date = (Get-Date).ToString()
    $timestamp = $date -replace " ","_" -replace ":","-" -replace "/","-"

    $document | Out-File $amiName-AmiId-List$timestamp.txt
}

catch {
    Write-Host "An error occurred:"
    Write-Host $_
}

