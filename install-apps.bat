@echo off
:: Yönetici olarak çalıştığından emin olun
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Lütfen bu betiği YONETICI olarak calistirin.
    pause
    exit /b
)

echo [1/5] Chocolatey kontrol ediliyor...
choco -v >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Chocolatey bulunamadı, yukleniyor...
    powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command ^
    "Set-ExecutionPolicy Bypass -Scope Process -Force; ^
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; ^
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    refreshenv
) ELSE (
    echo Chocolatey zaten yüklü.
)

echo.
echo [2/5] Winget kontrol ediliyor...
where winget >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Winget bulunamadı. Lutfen Microsoft Store'dan "App Installer" yukleyin ve tekrar deneyin.
    pause
    exit /b
) ELSE (
    echo Winget zaten yüklü.
)

echo.
echo [3/5] Chocolatey ile uygulamalar kuruluyor...

choco install slack -y
choco install pritunl -y
choco install googlechrome -y
choco install microsoft-office-deployment -y

echo.
echo [4/5] Winget ile Asana kuruluyor...

winget install --id Asana.Asana -e --accept-source-agreements --accept-package-agreements

echo.
echo [5/5] Tüm kurulumlar tamamlandi.
pause
exit
