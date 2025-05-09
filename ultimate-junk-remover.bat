@echo off
title Ultimate Junk Remover
mode con: cols=80 lines=30
color 0A

:: Membersihkan File Log yang Mungkin Sudah Ada Sebelumnya
echo [*] Menghapus file log lama...
del /f /q "%TEMP%\*.log" >nul 2>&1
del /f /q "C:\Windows\Temp\*.log" >nul 2>&1
del /f /q "C:\Windows\Logs\*.log" >nul 2>&1
del /f /q "C:\Windows\System32\LogFiles\*.log" >nul 2>&1
del /f /q "%USERPROFILE%\AppData\Local\Temp\*.log" >nul 2>&1

:: Header
echo ==================================================               
echo                 BENNY HERMAWAN  
echo ==================================================
echo.
echo [*] Inisialisasi pembersihan...
timeout /t 2 >nul

:: Proses Pembersihan
call :CleanTemp
call :CleanPrefetch
call :CleanRecycleBin
call :CleanWindowsUpdate
call :CleanDisk

:: Menampilkan Laporan Langsung (Tanpa Log File)
echo.
echo ==================================================
echo              Pembersihan Selesai                      
echo ==================================================
echo.
echo Statistik Pembersihan:
echo - File sementara       : %tempfiles% file dihapus
echo - File Prefetch        : %prefetchfiles% file dihapus
echo - Recycle Bin          : %recyclefiles% file dihapus
echo - Windows Update Cache : %updatefiles% file dihapus
echo - Sampah Disk          : Dibersihkan dengan Disk Cleanup
echo.
echo Tekan tombol apa saja untuk keluar...
pause >nul
exit

:: Fungsi untuk membersihkan folder Temp
:CleanTemp
echo [*] Membersihkan Temporary Files...
set /a tempfiles=0
for /f %%A in ('dir /b /a:-d "%TEMP%" 2^>nul') do set /a tempfiles+=1
del /f /q "%TEMP%\*.*" >nul 2>&1
rd /s /q "%TEMP%" >nul 2>&1
md "%TEMP%" >nul 2>&1
echo    -> %tempfiles% file dihapus
timeout /t 1 >nul
goto :EOF

:: Fungsi untuk membersihkan Prefetch
:CleanPrefetch
echo [*] Membersihkan Prefetch Files...
set /a prefetchfiles=0
for /f %%A in ('dir /b /a:-d "C:\Windows\Prefetch" 2^>nul') do set /a prefetchfiles+=1
del /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1
echo    -> %prefetchfiles% file dihapus
timeout /t 1 >nul
goto :EOF

:: Fungsi untuk membersihkan Recycle Bin
:CleanRecycleBin
echo [*] Mengosongkan Recycle Bin...
set /a recyclefiles=0
for /f %%A in ('PowerShell -command "(New-Object -ComObject Shell.Application).NameSpace(10).Items().Count"') do set /a recyclefiles=%%A
PowerShell -command "Clear-RecycleBin -Force" >nul 2>&1
echo    -> %recyclefiles% file dihapus
timeout /t 1 >nul
goto :EOF

:: Fungsi untuk membersihkan Windows Update Cache
:CleanWindowsUpdate
echo [*] Menghapus Cache Windows Update...
set /a updatefiles=0
for /f %%A in ('dir /b /a:-d "C:\Windows\SoftwareDistribution\Download" 2^>nul') do set /a updatefiles+=1
del /f /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
echo    -> %updatefiles% file dihapus
timeout /t 1 >nul
goto :EOF

:: Fungsi untuk membersihkan Sampah Disk
:CleanDisk
echo [*] Membersihkan Sampah Disk...
cleanmgr /verylowdisk >nul 2>&1
echo    -> Sampah disk dibersihkan dengan Disk Cleanup
timeout /t 3 >nul
goto :EOF
