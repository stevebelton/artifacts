Import-Module ServerManager
Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools

$guid=[system.guid]::NewGuid().Guid
$folder="$env:temp\$guid"

New-Item -Path $folder -ItemType Directory

$zipfilelocal = "$folder\imageserver"
$zipextracted="$folder\extracted"

Invoke-WebRequest "C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.8\Downloads\0\imageserver.zip" -OutFile $zipfilelocal

Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory($zipfilelocal, $zipextracted)

copy-item $zipextracted\imageserver\* c:\inetpub\wwwroot -Force -Recurse
