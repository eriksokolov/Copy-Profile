$PrintPDF = 'Microsoft Print to PDF'


function Upload-Git 
{
  git add -A
  git commit -m (Get-Date)
  git push
}


Set-PSReadLineOption -EditMode Vi
