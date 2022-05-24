$project = Get-ChildItem *.*proj
if (Test-Path \objd) { Remove-Item -recurse .\objd }
iex -command "msbuild @$PSScriptRoot\msbparams.txt $project"