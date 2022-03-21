$project = Get-ChildItem *.*proj
if (Test-Path \objd) { Remove-Item -recurse .\objd }
write-host "$env:dotnetcore\dotnet.exe msbuild @$PSScriptRoot\params.txt $project $args"
iex -command "$env:dotnetcore\dotnet.exe msbuild @$PSScriptRoot\params.txt $project $args"