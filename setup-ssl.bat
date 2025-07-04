@echo off
echo ======================================
echo   Configuracion SSL para SonarQube
echo ======================================

echo.
echo Este script te ayudara a configurar SSL/HTTPS para SonarQube
echo.
echo IMPORTANTE: Antes de continuar, asegurate de que:
echo 1. Tu dominio apunte a la IP publica de este equipo
echo 2. Los puertos 80 y 443 esten abiertos en el firewall
echo 3. Hayas ejecutado: get-network-info.bat y check-domain.bat
echo.

set /p continue="¿Has verificado los requisitos anteriores? (S/N): "
if /i not "%continue%"=="S" (
    echo.
    echo Ejecuta primero:
    echo 1. get-network-info.bat - Para obtener tu IP publica
    echo 2. Configura tu dominio en el proveedor DNS
    echo 3. check-domain.bat - Para verificar la configuracion
    echo.
    pause
    exit /b 1
)

:ask_domain
set /p domain="Ingresa tu dominio (ej: sonarqube.miempresa.com): "
if "%domain%"=="" (
    echo Por favor ingresa un dominio valido.
    goto ask_domain
)

:ask_email
set /p email="Ingresa tu email para Let's Encrypt: "
if "%email%"=="" (
    echo Por favor ingresa un email valido.
    goto ask_email
)

echo.
echo ======================================
echo   Configurando archivos...
echo ======================================

echo.
echo [1] Actualizando configuracion de Nginx...

REM Reemplazar dominio en nginx.conf
powershell -Command "(Get-Content nginx\nginx.conf) -replace 'tu-dominio.com', '%domain%' | Set-Content nginx\nginx.conf"

echo [2] Creando directorios para certificados...
if not exist "certbot\conf" mkdir certbot\conf
if not exist "certbot\www" mkdir certbot\www
if not exist "nginx\ssl" mkdir nginx\ssl

echo [3] Actualizando variables de entorno...
echo DOMAIN=%domain% >> .env
echo EMAIL=%email% >> .env

echo.
echo [4] Verificando configuracion DNS...
echo Verificando que %domain% apunte a este equipo...

REM Obtener IP publica actual
for /f %%i in ('curl -s ifconfig.me') do set public_ip=%%i
echo Tu IP publica actual: %public_ip%

REM Verificar si tienes IP de Movistar
echo.
echo Verificando IP de Movistar: 190-20-39-204.baf.movistar.cl
for /f "tokens=2" %%i in ('nslookup 190-20-39-204.baf.movistar.cl ^| findstr "Address" ^| findstr /v "#"') do set movistar_ip=%%i
if defined movistar_ip (
    echo IP de Movistar resuelve a: %movistar_ip%
    if "%movistar_ip%"=="%public_ip%" (
        echo ✓ Estas usando la IP de Movistar correctamente
    )
)

REM Verificar DNS del dominio
echo.
echo Verificando DNS de %domain%...
for /f "skip=1 tokens=2" %%i in ('nslookup %domain% ^| findstr "Address"') do set domain_ip=%%i
echo Dominio %domain% apunta a: %domain_ip%

REM Validar que el dominio apunte a una IP correcta
set dns_ok=0
if "%domain_ip%"=="%public_ip%" set dns_ok=1
if defined movistar_ip if "%domain_ip%"=="%movistar_ip%" set dns_ok=1

if %dns_ok%==0 (
    echo.
    echo ✗ ERROR: El dominio NO apunta a tu IP
    echo.
    echo Tu IP actual: %public_ip%
    if defined movistar_ip echo Tu IP Movistar: %movistar_ip%
    echo Dominio apunta a: %domain_ip%
    echo.
    echo SOLUCION:
    echo 1. Configura tu dominio para apuntar a: %public_ip%
    if defined movistar_ip echo    O alternativamente a: %movistar_ip%
    echo 2. O usa CNAME apuntando a: 190-20-39-204.baf.movistar.cl
    echo 3. Espera propagacion DNS (5-60 minutos)
    echo 4. Ejecuta: check-domain.bat para verificar
    echo.
    pause
    exit /b 1
) else (
    echo ✓ DNS configurado correctamente
)

echo.
echo ======================================
echo   Obteniendo certificado SSL...
echo ======================================

echo.
echo Iniciando contenedores base...
docker-compose up -d db sonarqube

echo.
echo Esperando a que SonarQube este listo...
timeout /t 30 /nobreak >nul

echo.
echo Iniciando Nginx temporalmente para validacion...
docker-compose up -d nginx

echo.
echo Obteniendo certificado SSL de Let's Encrypt...
docker-compose --profile setup run --rm certbot certonly --webroot -w /var/www/certbot --force-renewal --email %email% -d %domain% --agree-tos --non-interactive

if %errorlevel% equ 0 (
    echo.
    echo ✓ Certificado SSL obtenido exitosamente!
    echo.
    echo Reiniciando Nginx con SSL...
    docker-compose restart nginx
    
    echo.
    echo ======================================
    echo   Configuracion completada!
    echo ======================================
    echo.
    echo Tu SonarQube ahora esta disponible en:
    echo https://%domain%
    echo.
    echo Usuario: admin
    echo Contraseña: admin
    echo.
    echo IMPORTANTE: Cambia la contraseña por defecto
    echo.
) else (
    echo.
    echo ✗ Error al obtener el certificado SSL
    echo.
    echo Posibles causas:
    echo - El dominio no apunta a esta IP
    echo - El puerto 80 no esta abierto
    echo - Problemas de DNS
    echo.
    echo Iniciando SonarQube sin SSL...
    docker-compose down
    docker-compose up -d db sonarqube
    echo.
    echo SonarQube disponible en: http://%domain%:9000
)

echo.
pause
