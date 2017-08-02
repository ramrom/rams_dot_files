echo off
set /p password=enter password for the vault: 
"c:\program files\truecrypt\truecrypt.exe" /v "d:\sreeram's docs\vault.tc" /lv /p %password% /q
