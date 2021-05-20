@ECHO OFF
netstat -ano | findstr /i listen
ECHO.

EXIT /B
