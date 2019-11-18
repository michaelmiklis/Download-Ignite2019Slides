######################################################################
## (C) 2019 Michael Miklis (michaelmiklis.de)
##
##
## Filename:      Download-Ignite2019Slides.ps1
##
## Version:       1.0
##
## Release:       Final
##
## Requirements:  -none-
##
## Description:   Downloads all Microsoft Ignite 2019 Slides
##
## This script is provided 'AS-IS'.  The author does not provide
## any guarantee or warranty, stated or implied.  Use at your own
## risk. You are free to reproduce, copy & modify the code, but
## please give the author credit.
##
####################################################################

param (
    [parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()][string]$downloadPath,
    [parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()][int]$ParallelJobs,
    [parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()][switch]$All
)

# Get all sessions using myIgnite API
[array]$Sessions = (Invoke-RestMethod 'https://api-myignite.techcommunity.microsoft.com/api/session/all') | Where-Object { $_.slideDeck } | Select-Object sessionCode, title, slideDeck

# If not -All is passed, open Out-GridView
if (!$all)
{
    $Sessions = $Sessions | Out-GridView -PassThru
}

for ($i = 0; $i -le $($Sessions.Count - 1); $i++)
{
    $slideFilename = $Sessions[$i].title
    [System.IO.Path]::GetInvalidFileNameChars() | ForEach-Object { $slideFilename = $slideFilename.replace("$_","") }
    Add-Member -InputObject $Sessions[$i] -MemberType NoteProperty -Name "slideFilename" -Value $slideFilename

}

# Use parallel ForEach in PowerShell 7
if ($PSVersionTable.PSVersion.Major -ge 7)
{
    $Sessions | ForEach-Object -Parallel { Write-Host $("Processing {0} - {1}" -f $_.sessionCode, $_.slideFilename); Invoke-WebRequest -Uri $_.slideDeck -OutFile $(Join-Path $using:downloadPath $("{0}_{1}.pptx" -f $_.sessionCode, $_.slideFilename)); } -ThrottleLimit $ParallelJobs 
}

else 
{
    $Sessions | ForEach-Object { Write-Host $("Processing {0} - {1}" -f $_.sessionCode, $_.slideFilename); Invoke-WebRequest -Uri $_.slideDeck -OutFile $(Join-Path $downloadPath $("{0}_{1}.pptx" -f $_.sessionCode, $_.slideFilename)); }
}