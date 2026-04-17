function Read-Me {
  <#
  .DESCRIPTION
    This is my Powershell profile. It customizes my environment and adds session-specific elements to every PowerShell session that I start.
  #>
  
  (Get-Help Read-Me).Description
}


$PrintPDF = 'Microsoft Print to PDF'


function Write-Git 
{
  git add -A
  git commit -m (Get-Date)
  git push
}


Set-PSReadLineOption -EditMode Vi


function Test-Connection-t {
  while ($true) {
   Test-Connection 8.8.8.8 -Count 1
   Start-Sleep -Seconds 1
  }
}


function Start-Timer {
  <#
  .DESCRIPTION
    Requires ScheduledTasks module, Microsoft.PowerShell.Utility Module
  #>

  param (
    [int]$Minutes,
    [string]$Description
  )

  $TaskName = [string](Get-Date -format 'HH-mm-ss-dddd')
  $time = (Get-Date).AddMinutes($Minutes)
  $argument = "-WindowStyle Hidden -Command Write-Output 'Timer up! ; $Description ; $Minutes' | Out-GridView; Read-Host 'Enter to close gui'"

  $t1 = New-ScheduledTaskTrigger -Once -At $time
  $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $argument
  $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
  $task = New-ScheduledTask -Action $action -Trigger $t1 -Settings $settings

  Register-ScheduledTask -Taskname $TaskName -InputObject $task
}


function Get-Word {
  $csvUrl = "https://raw.githubusercontent.com/eriksokolov/csv/main/serbianwords.csv"
  $invokecsv = Invoke-RestMethod $csvUrl
  $csv = ConvertFrom-csv $invokecsv -Delimiter ","
  $i = 0
  $csvcounter = $csv | 
    Foreach-Object {
      $i++
    }

  $randomRow = $csv | 
    Select-Object -index (Get-random -Maximum $i -minimum 0)
  $randomRowClone = $randomRow
  $serbian = $randomRowClone | 
    Select-Object "serbian"
  $serbian | 
    Format-Table -AutoSize

  $blank = Read-Host

  $russian = $randomRowClone |
    Select-Object "russian"
  $russian |
    Format-Table -AutoSize
  Read-Host
  cls
}


function Merge-ADUserlists{
  param (
    [string]$client,
    [string]$month,
    [string]$year,
    [int]$modify
  )

  $z = 1;

  ls |
  Where-Object {
   $_.Name -match ".csv"
  } |
  Foreach-Object {
   $z++
  };

  $i = 1;
  $filename = "{0}_AD_Userliste_{1}_{2}" -f $client, $month, $year;

  if ($modify -eq 0) {
    while ( $i -lt $z ) {
      $data = ".\temp{0}.csv" -f $i

      Get-content $data|
      Add-content .\$filename
      $i++
    }
  } 
  elseif ($modify -eq 1) {
    while ($i -lt $z) {
      $data = ".\temp{0}.csv" -f $i
      $olddata = Get-content $data 
      $newdata = $olddata |
      Where-Object { 
        $_ -cnotmatch "Typ,Beschreibung"
      }
      $newdata | 
      Add-Content $filename
      $i++
    }
  }
  elseif ($modify -eq 2) {
    while ($i -lt $z) {
      $data = ".\temp{0}.csv" -f $i
      $olddata = Get-content $data 
      $newdata = $olddata |
      Where-Object { 
        $_ -cnotmatch "Typ,Beschreibung|Test|test"
      }
      $newdata |
      Add-Content $filename
      $i++
    }
  }
}

