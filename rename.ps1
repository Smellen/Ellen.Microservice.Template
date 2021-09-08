# read the updated project name
$newProjectNameFromArgs = $args[0]

# read the updated API name
$newApiName = $args[1]

if ($args.Length -eq 0)
{
	Write-Host "Required arguments missing. 
	First arg is Project name. 
	Second arg is the new API name."
}

# set output encoding
$OutputEncoding = [Text.UTF8Encoding]::UTF8

# project name placeholder
$oldProjectName="Ellen.Microservice.Template"
# new project name.
$newProjectName = $newProjectNameFromArgs

# Old names of existing solution.
$placeHolderTextContent= ('Ellen.Microservice.Template.xml', 'Ellen Microservice Template API')
# New project settings.
$newTextContent = ("$newProjectNameFromArgs.xml", $newApiName)

# file type
$fileType="FileInfo"

# directory type
$dirType="DirectoryInfo"

# copy 
Write-Host "Starting folder copy for $newProjectName..."
$newRoot=$newProjectName
mkdir $newRoot

try
{
	Copy-Item -Recurse .\src\ .\$newRoot\ -ErrorAction Stop
}catch{
	Write-Host("No src folder found.") -ForegroundColor Red
}

try{
	Copy-Item -Recurse .\tests\ .\$newRoot\ -ErrorAction Stop
}catch
{
	Write-Host("No tests folder found.") -ForegroundColor Red
}

try{
	Copy-Item -Recurse .\build\ .\$newRoot\ -ErrorAction Stop
}catch
{
	Write-Host("No build folder found.") -ForegroundColor Red
}

try{
	Copy-Item .gitignore .\$newRoot\ -ErrorAction Stop
}catch
{
	Write-Host("No .gitignore found.") -ForegroundColor Red
}

try{
	Copy-Item .editorconfig .\$newRoot\ -ErrorAction Stop
}catch
{
	Write-Host("No .editorconfig file found.") -ForegroundColor Red
}

try{
	Copy-Item .gitattributes .\$newRoot\ -ErrorAction Stop
}catch
{
	Write-Host("No .gitattributes file found.") -ForegroundColor Red
}

try{
	Copy-Item CHANGELOG.md .\$newRoot\ -ErrorAction Stop
}catch
{
	Write-Host("No CHANGELOG.md file found.") -ForegroundColor Red
}

try{
	Copy-Item nuget.config .\$newRoot\ -ErrorAction Stop
}catch
{
	Write-Host("No nuget.config file found.") -ForegroundColor Red
}

try{
	Copy-Item README.md .\$newRoot\ -ErrorAction Stop
}catch
{
	Write-Host("No README.md file found.") -ForegroundColor Red
}

Copy-Item "$($oldProjectName).sln" .\$newRoot\

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
	# ADD missing file extensions as needed.
	$include=@("*.cs","*.cshtml","*.asax","*.ps1","*.ts","*.csproj","*.sln","*.xaml","*.json","*.js","*.xml","*.config","Dockerfile", "azure-pipelines.yml")

	$elapsed = [System.Diagnostics.Stopwatch]::StartNew()

	Write-Host "Start folder renaming..."
	Write-Host "New solution location [$TargetFolder]" -ForegroundColor Yellow
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
	Write-Host "End replace file content and rename file name."
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