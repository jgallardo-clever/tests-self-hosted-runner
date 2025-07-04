@echo off
echo ======================================
echo   Verificacion de Configuracion DNS
echo ======================================

echo.
set /p domain="Ingresa el dominio a verificar: "

if "%domain%"=="" (
    echo Error: Debes ingresar un dominio
    pause
    exit /b 1
)

echo.
echo [1] Obteniendo tu IP publica actual...
for /f %%i in ('curl -s ifconfig.me') do set public_ip=%%i
echo Tu IP publica: %public_ip%

echo.
echo [2] Verificando resolucion DNS del dominio...
echo Resolviendo %domain%:
nslookup %domain%

echo.
echo [3] Verificando si el dominio apunta a tu IP...
for /f "tokens=2" %%i in ('nslookup %domain% ^| findstr "Address"') do set domain_ip=%%i
echo.
if "%domain_ip%"=="%public_ip%" (
    echo ✓ CORRECTO: El dominio %domain% apunta a tu IP %public_ip%
    echo.
    echo [4] Verificando conectividad HTTP...
    curl -s -o nul -w "HTTP Status: %%{http_code}\n" --connect-timeout 10 http://%domain%/
    
    echo.
    echo ¡Tu dominio esta configurado correctamente!
    echo Ya puedes ejecutar: setup-ssl.bat
) else (
    echo ✗ ERROR: El dominio %domain% NO apunta a tu IP
    echo.
    echo Dominio apunta a: %domain_ip%
    echo Tu IP publica es: %public_ip%
    echo.
    echo SOLUCION:
    echo 1. Ve al panel de tu proveedor de dominio
    echo 2. Modifica el registro A para que apunte a %public_ip%
    echo 3. Espera la propagacion DNS (5-60 minutos)
    echo 4. Vuelve a ejecutar este script
)

echo.
echo [5] Verificacion de puertos del firewall...
echo.
echo Verificando puerto 80 (HTTP)...
telnet %domain% 80 2>nul
if %errorlevel% equ 0 (
    echo ✓ Puerto 80 accesible
) else (
    echo ✗ Puerto 80 NO accesible - Verifica tu firewall
)

echo.
echo Verificando puerto 443 (HTTPS)...
telnet %domain% 443 2>nul
if %errorlevel% equ 0 (
    echo ✓ Puerto 443 accesible
) else (
    echo ✗ Puerto 443 NO accesible - Verifica tu firewall
)

echo.
echo ======================================
echo   Verificacion completada
echo ======================================

pause
