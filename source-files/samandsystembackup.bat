@ECHO OFF
ECHO "SAM and SYSTEM backups"
IF EXIST %WINDIR%\repair\SAM ECHO.%WINDIR%\repair\SAM exists. 
IF EXIST %WINDIR%\System32\config\RegBack\SAM ECHO.%WINDIR%\System32\config\RegBack\SAM exists.
IF EXIST %WINDIR%\System32\config\SAM ECHO.%WINDIR%\System32\config\SAM exists.
IF EXIST %WINDIR%\repair\SYSTEM ECHO.%WINDIR%\repair\SYSTEM exists.
IF EXIST %WINDIR%\System32\config\SYSTEM ECHO.%WINDIR%\System32\config\SYSTEM exists.
IF EXIST %WINDIR%\System32\config\RegBack\SYSTEM ECHO.%WINDIR%\System32\config\RegBack\SYSTEM exists.
ECHO.
Echo All Done! 
pause
EXIT
:EOF
:::-Subroutines
:ColorLine
ECHO %~1
PAUSE >nul 
EXIT /B