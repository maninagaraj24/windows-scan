@ECHO OFF
type C:\WINDOWS\System32\drivers\etc\hosts | findstr /v "^#"
ECHO.

EXIT /B
