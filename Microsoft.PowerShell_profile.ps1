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
  param (
    [int]$Minutes,
    [string]$Description
  )

  $TaskName = [string](Get-Date -format 'HH-mm-ss-dddd')
  $time = (Get-Date).AddMinutes($Minutes)
  $argument = "-Command Write-Output 'Timer up! ; $Description ; $Minutes' | Out-GridView; Read-Host 'Enter to close gui'"

  $t1 = New-ScheduledTaskTrigger -Once -At $time
  $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $argument
  $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
  $task = New-ScheduledTask -Action $action -Trigger $t1 -Settings $settings

  Register-ScheduledTask -Taskname $TaskName -InputObject $task
}
