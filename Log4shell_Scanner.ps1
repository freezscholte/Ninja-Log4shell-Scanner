#JS
#V1.2.1 December 15 2021
#Sources for inspiration -> https://github.com/N-able/ScriptsAndAutomationPolicies/blob/master/Vulnerability%20-%20CVE-2021-44228%20(Log4j)/get-log4jrcevulnerability.ps1

$StartTime = Get-Date
$drives = Get-WmiObject -class “Win32_LogicalDisk" | ?{ @(3) -contains $_.DriveType }
$drives = $drives.DeviceID


$ScanResults = foreach ($Drive in $drives) {

    $robocopyexitcode = (start-process "robocopy.exe" "$($drive)\ $($drive)\DOESNOTEXIST *.jar /S /XJ /L /FP /NS /NC /NDL /NJH /NJS /r:0 /w:0 /LOG:$env:temp\log4jfilescan.csv" -wait).exitcode
        if ($? -eq $True) {
            $robocopycsv = $true
            $ScanResult = import-csv "$env:temp\log4jfilescan.csv" -header FilePath -delimiter "|"
            $ScanResult       
            
        }

}

if ($robocopycsv -eq $true) {

    $log4jvulnerablefiles = $ScanResults | foreach-object {
        if (($_.FilePath -ne $null) -and ($_.FilePath -ne "")) {
          if (($_.FilePath -notmatch "placeholder.jar") -and ($_.FilePath -notmatch "spool\\drivers")) {
            
            select-string "JndiLookup.class" $_.FilePath
          }
        }
      } | select-object -exp Path | sort-object -unique | ConvertTo-Json
    
}
    else {

        $log4jvulnerablefiles = $ScanResults | foreach-object {
            if (($_.FilePath -ne $null) -and ($_.FilePath -ne "")) {
              if ($_.FilePath -notmatch "placeholder.jar") {
                
                select-string "JndiLookup.class" $_
              }
            }
          } | select-object -exp Path | sort-object -unique | ConvertTo-Json
    }


if($null -ne $log4jvulnerablefiles ){

        $ScanMessage = "Warning JndiLookup.class *.Jar Files Found in $((New-Timespan -Start $StartTime -End $(Get-Date)).TotalSeconds) seconds: `n" + $log4jvulnerablefiles

}

    else {
        
        $ScanMessage = "All Good! no JndiLookup.class *.Jar Files Found Scantime $((New-Timespan -Start $StartTime -End $(Get-Date)).TotalSeconds) seconds"
    }   


    

Ninja-Property-Set log4shellScanner $ScanMessage



