@ECHO OFF
ECHO.
ECHO "CURRENT USER"
net user %username%
net user %USERNAME% /domain 2>nul
whoami /all
ECHO.
ECHO "USERS"
net user

EXIT /B
