# set output encoding
$OutputEncoding = [Text.UTF8Encoding]::UTF8

# project name placeholder
$oldProjectName="Ellen.Microservice.Template"
# new project name. CHANGE ME
$newProjectName="Ellen.Updated.Microservice"

$placeHolderTextContent= ('Ellen.Microservice.Template.xml', 'Ellen Microservice Template API')
# New project settings. CHANGE ME
$newTextContent= ('Ellen.Updated.Microservice.xml', 'Ellen Updated Microservice API')

# file type
$fileType="FileInfo"

# directory type
$dirType="DirectoryInfo"

# copy 
Write-Host 'Start copy folders...'
$newRoot=$newProjectName
mkdir $newRoot
Copy-Item -Recurse .\src\ .\$newRoot\
Copy-Item -Recurse .\tests\ .\$newRoot\
Copy-Item -Recurse .\build\ .\$newRoot\
Copy-Item .gitignore .\$newRoot\
Copy-Item .editorconfig .\$newRoot\
Copy-Item .gitattributes .\$newRoot\
Copy-Item CHANGELOG.md .\$newRoot\
Copy-Item "$($oldProjectName).sln" .\$newRoot\
Copy-Item nuget.config .\$newRoot\
Copy-Item README.md .\$newRoot\

# folders to deal with
$rootFolder = (Get-Item -Path "./$newRoot/" -Verbose).FullName

function Rename {
	param (
		$TargetFolder,		
		$PlaceHolderProjectName,		
        $NewProjectName,
        [string[]]$PlaceHolderTextContent,
        [string[]]$NewTextContent
	)
	# file extensions to deal with
	$include=@("*.cs","*.cshtml","*.asax","*.ps1","*.ts","*.csproj","*.sln","*.xaml","*.json","*.js","*.xml","*.config","Dockerfile", "azure-pipelines.yml")

	$elapsed = [System.Diagnostics.Stopwatch]::StartNew()

	Write-Host "[$TargetFolder]Start rename folder..."
	# rename folder
	Get-ChildItem $TargetFolder -Recurse | Where-Object { $_.GetType().Name -eq $dirType -and $_.Name.Contains($PlaceHolderProjectName) } | ForEach-Object{
		Write-Host 'directory ' $_.FullName
		$newDirectoryName=$_.Name.Replace($PlaceHolderProjectName,$NewProjectName)
		Rename-Item $_.FullName $newDirectoryName
	}
	Write-Host "[$TargetFolder]End rename folder."
	Write-Host '-------------------------------------------------------------'


	# replace file content and rename file name
	Write-Host "[$TargetFolder]Start replace file content and rename file name..."
	Get-ChildItem $TargetFolder -Include $include -Recurse | Where-Object { $_.GetType().Name -eq $fileType} | ForEach-Object{
        ReplaceFileContent -FileName $_ -PlaceHolder $PlaceHolderProjectName -Replacement $NewProjectName
        for ($counter=0; $counter -lt $PlaceHolderTextContent.Length; $counter++) {
            ReplaceFileContent -FileName $_ -PlaceHolder $PlaceHolderTextContent[$counter] -Replacement $NewTextContent[$counter]
        }
		If($_.Name.contains($PlaceHolderProjectName)){
			$newFileName=$_.Name.Replace($PlaceHolderProjectName,$NewProjectName)
			Rename-Item $_.FullName $newFileName
			Write-Host 'file(change name) ' $_.FullName
		}
	}
	Write-Host "[$TargetFolder]End replace file content and rename file name."
	Write-Host '-------------------------------------------------------------'

	$elapsed.stop()
	write-host "[$TargetFolder]Total Time Cost: $($elapsed.Elapsed.ToString())"
}

function ReplaceFileContent($FileName, $PlaceHolder, $Replacement) {
    $fileText = Get-Content $FileName -Raw -Encoding UTF8
    if($fileText.Length -gt 0 -and $fileText.contains($PlaceHolder)){
        $fileText.Replace($PlaceHolder,$Replacement) | Set-Content $_ -Encoding UTF8
        Write-Host 'file(change text) ' $FileName
    }
}

Rename -TargetFolder $rootFolder -PlaceHolderProjectName $oldProjectName -NewProjectName $newProjectName -PlaceHolderTextContent $placeHolderTextContent -NewTextContent $newTextContent