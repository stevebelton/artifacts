# INSTALL IIS

Import-Module ServerManager
Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools

# CREATE A TEMPORARY FOLDER

$guid = [system.guid]::NewGuid().Guid
$folder = "$env:temp\$guid"

New-Item -Path $folder -ItemType Directory

$zipfilelocal = "$folder\imageserver"
$zipextracted = "$folder\extracted"

# INSTALL THE WEBSITE

Invoke-WebRequest "C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.8\Downloads\0\imageserver.zip" -OutFile $zipfilelocal

Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory($zipfilelocal, $zipextracted)

copy-item $zipextracted\imageserver\* c:\inetpub\wwwroot -Force -Recurse

# INSTALL URLREWRITE

Invoke-WebRequest -Uri "http://go.microsoft.com/fwlink/?LinkID=615137" -OutFile "$folder\urlrewrite.msi"
msiexec /i $folder\urlrewrite.msi /qn

# INSTALL .NET FRAMEWORK 4.6

Invoke-WebRequest -Uri "https://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe" -OutFile "$folder\dotnet46.exe"

start-process "$folder\dotnet46.exe" "/q /serialdownload /log $folder\dotnet46.log"

# REBOOT VIA .NET INSTALLATION
