 $rootDir = "."
 $solutionFileCS = "$rootDir\src\Boleto.Net.sln"
 $srcDir = "$rootDir\src\nuget\boleto.net"
 $isAppVeyor = $env:APPVEYOR -eq $true
 $slns = ls "$rootDir\src\*.sln"
 $packagesDir = "$rootDir\src\packages"
 $buildNumber = [Convert]::ToInt32($env:APPVEYOR_BUILD_NUMBER).ToString("0000")
 $nuspecPathCS = "$rootDir\src\nuget\boleto.net\boleto.net.nuspec"
 $nugetExe = "$packagesDir\NuGet.CommandLine.2.8.3\tools\NuGet.exe"
 $nupkgPathCS = "$rootDir\src\NuGet\Boleto.Net\Boleto.Net.nupkg"

 $logDir = "$rootDir\log"
 $isRelease = $isAppVeyor -and ($env:APPVEYOR_REPO_BRANCH -eq "release")
 $isPullRequest = $env:APPVEYOR_PULL_REQUEST_NUMBER -ne $null

 if ((Test-Path $logDir) -eq $false)
 {
     Write-Host -ForegroundColor DarkBlue "Creating log directory $logDir"
     mkdir $logDir | Out-Null
 }
 
foreach($sln in $slns) {
   write-host $sln 
   nuget restore $sln
}

. $nugetExe pack $nuspecPathCS -properties "Configuration=$env:configuration;Platform=AnyCPU;Version=$($env:appveyor_build_version)" -OutputDirectory $srcDir
appveyor PushArtifact $nupkgPathCS
