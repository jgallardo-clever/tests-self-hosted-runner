@echo off
echo ======================================
echo   Configuracion Dominio con IP Movistar
echo ======================================

echo.
echo Tu IP de Movistar: 190-20-39-204.baf.movistar.cl
echo.

set /p domain="Ingresa tu dominio (ej: miempresa.com): "
if "%domain%"=="" (
    echo Error: Debes ingresar un dominio
    pause
    exit /b 1
)

set /p subdomain="Ingresa el subdominio para SonarQube (ej: sonarqube): "
if "%subdomain%"=="" set subdomain=sonarqube

echo.
echo ======================================
echo   Opciones de Configuracion DNS
echo ======================================

echo.
echo Tu dominio completo sera: %subdomain%.%domain%
echo.

REM Resolver IP numerica de Movistar
for /f "tokens=2" %%i in ('nslookup 190-20-39-204.baf.movistar.cl ^| findstr "Address" ^| findstr /v "#"') do set movistar_ip=%%i

echo OPCION 1 - Registro CNAME (Recomendado):
echo   Nombre: %subdomain%
echo   Tipo: CNAME
echo   Valor: 190-20-39-204.baf.movistar.cl
echo   TTL: 300
echo.
echo   Ventaja: Si Movistar cambia la IP, se actualiza automaticamente
echo.

echo OPCION 2 - Registro A:
echo   Nombre: %subdomain%
echo   Tipo: A
echo   Valor: %movistar_ip%
echo   TTL: 300
echo.
echo   Nota: Si Movistar cambia la IP, tendras que actualizar manualmente
echo.

echo ======================================
echo   Pasos a seguir:
echo ======================================
echo.
echo 1. Ve al panel DNS de tu proveedor de dominio
echo 2. Elige una de las opciones de arriba
echo 3. Crea el registro DNS correspondiente
echo 4. Espera propagacion (15-60 minutos)
echo 5. Ejecuta: check-domain.bat para verificar
echo 6. Ejecuta: setup-ssl.bat para configurar SSL
echo.

echo ======================================
echo   Verificacion actual:
echo ======================================

echo.
echo Verificando conectividad a IP Movistar...
ping -n 2 190-20-39-204.baf.movistar.cl

echo.
echo Tu IP publica actual:
curl -s ifconfig.me
echo.

echo.
echo Verificando si ya tienes el dominio configurado...
nslookup %subdomain%.%domain%

echo.
echo ======================================
echo   Configuracion completada
echo ======================================
echo.
echo Cuando hayas configurado el DNS, tu SonarQube sera accesible en:
echo https://%subdomain%.%domain%
echo.

pause
