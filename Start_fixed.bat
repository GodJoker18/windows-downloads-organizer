@echo off
setlocal EnableExtensions
title Downloads Organizer

rem Always work in the folder containing this script.
cd /d "%~dp0" || (
    echo [ERROR] Could not open the folder containing this script.
    pause
    exit /b 1
)

set "SELFNAME=%~nx0"

echo.
echo ========================================
echo          DOWNLOADS ORGANIZER
echo ========================================
echo.
echo Working folder:
echo "%CD%"
echo.
echo SAFETY RULES:
echo   - A preview is shown before anything is moved.
echo   - Only files directly in this folder are considered; folders are untouched.
echo   - This script, other .bat/.cmd/.ps1 scripts, and temporary downloads stay put.
echo   - Existing files are never intentionally overwritten; name conflicts are skipped.
echo   - Files are moved, not copied or intentionally deleted.
echo.
echo PREVIEW - no files have been moved yet:
echo.

rem Preview each category.
for %%E in (mp4 mkv avi mov wmv flv webm 3gp) do call :PreviewExt "Videos" "%%E"
for %%E in (jpg jpeg png gif bmp webp heic svg) do call :PreviewExt "Photos" "%%E"
for %%E in (pdf doc docx xls xlsx csv ppt pptx) do call :PreviewExt "Documents" "%%E"
for %%E in (txt) do call :PreviewExt "Txt Files" "%%E"
for %%E in (mp3 wav aac flac m4a ogg) do call :PreviewExt "Music" "%%E"
for %%E in (zip rar 7z tar gz) do call :PreviewExt "Zip" "%%E"
for %%E in (exe msi apk) do call :PreviewExt "Apps" "%%E"
call :PreviewOthers

echo.
echo No changes have been made yet.
choice /C YN /M "Proceed with the moves shown above"
if errorlevel 2 goto :Cancelled

echo.
echo Organizing files...
echo.

rem Move files by category.
for %%E in (mp4 mkv avi mov wmv flv webm 3gp) do call :MoveExt "Videos" "%%E"
for %%E in (jpg jpeg png gif bmp webp heic svg) do call :MoveExt "Photos" "%%E"
for %%E in (pdf doc docx xls xlsx csv ppt pptx) do call :MoveExt "Documents" "%%E"
for %%E in (txt) do call :MoveExt "Txt Files" "%%E"
for %%E in (mp3 wav aac flac m4a ogg) do call :MoveExt "Music" "%%E"
for %%E in (zip rar 7z tar gz) do call :MoveExt "Zip" "%%E"
for %%E in (exe msi apk) do call :MoveExt "Apps" "%%E"
call :MoveOthers

echo.
echo ========================================
echo           ORGANIZING FINISHED
echo ========================================
echo Review any [SKIPPED] or [ERROR] messages above.
echo.
pause
exit /b 0

:PreviewExt
set "DEST=%~1"
set "EXT=%~2"
for %%F in (*.%EXT%) do (
    rem Skip wildcard non-matches and directories.
    if exist "%%~fF" if not exist "%%~fF\" (
        if exist "%DEST%\%%~nxF" (
            echo [SKIP - name conflict] %%~nxF  - already exists in "%DEST%"
        ) else (
            echo [%DEST%] %%~nxF
        )
    )
)
exit /b 0

:PreviewOthers
for %%F in (*) do (
    rem Only process files at this level, never folders.
    if exist "%%~fF" if not exist "%%~fF\" (
        if /i not "%%~nxF"=="%SELFNAME%" (
            if /i not "%%~xF"==".crdownload" (
                if /i not "%%~xF"==".part" (
                    if /i not "%%~xF"==".tmp" (
                        if /i not "%%~xF"==".download" (
                            if /i not "%%~xF"==".partial" (
                                call :IsKnownExt "%%~xF"
                                if errorlevel 1 (
                                    if exist "Others\%%~nxF" (
                                        echo [SKIP - name conflict] %%~nxF  - already exists in "Others"
                                    ) else (
                                        echo [Others] %%~nxF
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
)
exit /b 0

:MoveExt
set "DEST=%~1"
set "EXT=%~2"
for %%F in (*.%EXT%) do (
    if exist "%%~fF" if not exist "%%~fF\" (
        if exist "%DEST%\%%~nxF" (
            echo [SKIPPED - name conflict] %%~nxF  - already exists in "%DEST%"
        ) else (
            if not exist "%DEST%\" md "%DEST%" >nul 2>&1
            move "%%~fF" "%DEST%\" >nul
            if errorlevel 1 echo [ERROR] Could not move %%~nxF to "%DEST%".
        )
    )
)
exit /b 0

:MoveOthers
for %%F in (*) do (
    if exist "%%~fF" if not exist "%%~fF\" (
        if /i not "%%~nxF"=="%SELFNAME%" (
            if /i not "%%~xF"==".crdownload" (
                if /i not "%%~xF"==".part" (
                    if /i not "%%~xF"==".tmp" (
                        if /i not "%%~xF"==".download" (
                            if /i not "%%~xF"==".partial" (
                                call :IsKnownExt "%%~xF"
                                if errorlevel 1 (
                                    if exist "Others\%%~nxF" (
                                        echo [SKIPPED - name conflict] %%~nxF  - already exists in "Others"
                                    ) else (
                                        if not exist "Others\" md "Others" >nul 2>&1
                                        move "%%~fF" "Others\" >nul
                                        if errorlevel 1 echo [ERROR] Could not move %%~nxF to "Others".
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
)
exit /b 0

:IsKnownExt
rem These file types are handled by a category and should not be sent to Others.
if /i "%~1"==".mp4" exit /b 0
if /i "%~1"==".mkv" exit /b 0
if /i "%~1"==".avi" exit /b 0
if /i "%~1"==".mov" exit /b 0
if /i "%~1"==".wmv" exit /b 0
if /i "%~1"==".flv" exit /b 0
if /i "%~1"==".webm" exit /b 0
if /i "%~1"==".3gp" exit /b 0
if /i "%~1"==".jpg" exit /b 0
if /i "%~1"==".jpeg" exit /b 0
if /i "%~1"==".png" exit /b 0
if /i "%~1"==".gif" exit /b 0
if /i "%~1"==".bmp" exit /b 0
if /i "%~1"==".webp" exit /b 0
if /i "%~1"==".heic" exit /b 0
if /i "%~1"==".svg" exit /b 0
if /i "%~1"==".pdf" exit /b 0
if /i "%~1"==".doc" exit /b 0
if /i "%~1"==".docx" exit /b 0
if /i "%~1"==".xls" exit /b 0
if /i "%~1"==".xlsx" exit /b 0
if /i "%~1"==".csv" exit /b 0
if /i "%~1"==".ppt" exit /b 0
if /i "%~1"==".pptx" exit /b 0
if /i "%~1"==".txt" exit /b 0
if /i "%~1"==".mp3" exit /b 0
if /i "%~1"==".wav" exit /b 0
if /i "%~1"==".aac" exit /b 0
if /i "%~1"==".flac" exit /b 0
if /i "%~1"==".m4a" exit /b 0
if /i "%~1"==".ogg" exit /b 0
if /i "%~1"==".zip" exit /b 0
if /i "%~1"==".rar" exit /b 0
if /i "%~1"==".7z" exit /b 0
if /i "%~1"==".tar" exit /b 0
if /i "%~1"==".gz" exit /b 0
if /i "%~1"==".exe" exit /b 0
if /i "%~1"==".msi" exit /b 0
if /i "%~1"==".apk" exit /b 0
rem Leave command scripts in place rather than relocating runnable scripts.
if /i "%~1"==".bat" exit /b 0
if /i "%~1"==".cmd" exit /b 0
if /i "%~1"==".ps1" exit /b 0
exit /b 1

:Cancelled
echo.
echo Cancelled. No files were moved.
pause
exit /b 0
