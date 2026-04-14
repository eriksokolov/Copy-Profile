$PrintPDF = 'Microsoft Print to PDF'


function Upload-Git 
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
  $randomRow = $csv | Select-Object -index (Get-random -Maximum $i -minimum 0)
  $randomRowClone = $randomRow
  $serbian = $randomRowClone | Select-Object "serbian"
  $serbian| Format-Table -AutoSize

  $blank = Read-Host

  $russian = $randomRowClone | Select-Object "russian"
  $russian | Format-Table -AutoSize
  Read-Host
  cls
}
