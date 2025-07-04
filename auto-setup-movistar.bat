@echo off
echo ======================================
echo   Configuracion Automatica Movistar
echo ======================================

echo.
echo Detectando configuracion de red...

REM Verificar IP actual
for /f %%i in ('curl -s ifconfig.me') do set current_ip=%%i
echo Tu IP publica actual: %current_ip%

REM Verificar IP de Movistar
echo.
echo Verificando IP de Movistar...
for /f "tokens=2" %%i in ('nslookup 190-20-39-204.baf.movistar.cl ^| findstr "Address" ^| findstr /v "#"') do set movistar_ip=%%i

if defined movistar_ip (
    echo IP de Movistar resuelve a: %movistar_ip%
    
    if "%movistar_ip%"=="%current_ip%" (
        echo.
        echo ✓ PERFECTO: Estas usando la IP de Movistar
        echo.
        echo Procediendo con configuracion automatica...
        goto configure_movistar
    ) else (
        echo.
        echo ⚠️  Tu IP actual no coincide con la de Movistar
        echo.
        echo Posibles causas:
        echo 1. Necesitas activar/configurar la IP en tu router
        echo 2. Estas detras de un NAT que necesita port forwarding
        echo 3. La IP aun no esta completamente propagada
        echo.
        set /p continue="¿Quieres continuar de todas formas? (S/N): "
        if /i not "%continue%"=="S" (
            echo.
            echo Contacta a Movistar para verificar la configuracion
            pause
            exit /b 1
        )
        goto configure_movistar
    )
) else (
    echo ✗ No se pudo resolver la IP de Movistar
    echo.
    echo Verifica tu conexion a internet y intentalo de nuevo
    pause
    exit /b 1
)

:configure_movistar
echo.
echo ======================================
echo   Configurando para Movistar
echo ======================================

set /p domain="Ingresa tu dominio base (ej: miempresa.com): "
if "%domain%"=="" (
    echo Error: Debes ingresar un dominio
    pause
    exit /b 1
)

set /p subdomain="Subdominio para SonarQube [sonarqube]: "
if "%subdomain%"=="" set subdomain=sonarqube

set full_domain=%subdomain%.%domain%

echo.
echo Configurando para: %full_domain%
echo.

REM Actualizar variables de entorno
echo # Configuracion Movistar>> .env
echo DOMAIN=%full_domain%>> .env
echo MOVISTAR_HOSTNAME=190-20-39-204.baf.movistar.cl>> .env
echo MOVISTAR_IP=%movistar_ip%>> .env

REM Actualizar nginx.conf
echo Actualizando configuracion de Nginx...
powershell -Command "(Get-Content nginx\nginx.conf) -replace 'tu-dominio.com', '%full_domain%' | Set-Content nginx\nginx.conf"

echo.
echo ======================================
echo   Instrucciones DNS
echo ======================================
echo.
echo Configura tu dominio con CUALQUIERA de estas opciones:
echo.
echo OPCION 1 (Recomendada) - CNAME:
echo   Nombre: %subdomain%
echo   Tipo: CNAME
echo   Valor: 190-20-39-204.baf.movistar.cl
echo.
echo OPCION 2 - Registro A:
echo   Nombre: %subdomain%
echo   Tipo: A
echo   Valor: %movistar_ip%
echo.
echo ======================================
echo   Siguientes pasos:
echo ======================================
echo.
echo 1. Configura el DNS segun las instrucciones de arriba
echo 2. Espera propagacion (15-60 minutos)
echo 3. Ejecuta: check-domain.bat
echo 4. Ejecuta: setup-ssl.bat
echo.
echo Tu SonarQube sera accesible en: https://%full_domain%
echo.

pause
