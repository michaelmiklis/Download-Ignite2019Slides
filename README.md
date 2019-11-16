# Download-Ignite2019Slides.ps1
Download all or just selected slides, which were persented at the Microsoft Ignite 2019 conference in Orlando:
 - Script support parallel processing, when executed in PowerShell 7
 - Script also supports PowerShell version 6
 - Use "-All" parameter to download all availabled slides
 - Use GridView UI to select individual sessions to download


## Parameters
The PowerShell script can be executed using the following parameters:

| Parameter | Sample-Value | Description |
| -------------| -----| ----- | 
| -downloadPath |  "C:\Users\michael\Document\Ignite-Slides" |  Path, where to store the downloaded slides| 
| -ParallelJobs|  10 |  Start 10 simultaneous download sessions (only supported in PowerShell 7 and above)| 
| -all | | When specified, all slides from all sessions will be downloaded, otherwise a GridView for selecting the sessions will be displayed | 

## Examples
The following example downloads all available session to the folder "C:\Ignite-Slides" using 5 simultaneous download sessions (requires PowerShell 7.0)

```
./Download-Ignite2019Slides.ps1 -downloadPath "C:\Ignite-Slides" -ParallelJobs 5 -all
```