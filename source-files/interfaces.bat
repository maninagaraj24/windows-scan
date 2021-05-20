@ECHO OFF
ipconfig  /all | findstr "Description | IPv4 Address"
ECHO.

EXIT /B
