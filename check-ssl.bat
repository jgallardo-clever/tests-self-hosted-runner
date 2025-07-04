@echo off
echo ======================================
echo   Verificacion SSL de SonarQube
echo ======================================

echo.
set /p domain="Ingresa tu dominio para verificar: "

if "%domain%"=="" (
    echo Error: Debes ingresar un dominio
    pause
    exit /b 1
)

echo.
echo [1] Verificando conectividad HTTP...
curl -s -o nul -w "HTTP Status: %%{http_code}\n" http://%domain%/.well-known/acme-challenge/test 2>nul

echo.
echo [2] Verificando conectividad HTTPS...
curl -s -o nul -w "HTTPS Status: %%{http_code}\n" https://%domain% 2>nul

echo.
echo [3] Verificando certificado SSL...
docker-compose --profile setup run --rm certbot certificates

echo.
echo [4] Verificando configuracion de Nginx...
docker exec nginx-proxy nginx -t

if %errorlevel% equ 0 (
    echo ✓ Configuracion de Nginx valida
) else (
    echo ✗ Error en la configuracion de Nginx
)

echo.
echo [5] Estado de contenedores...
docker-compose ps

echo.
echo [6] Logs recientes de Nginx...
echo ======================================
docker-compose logs --tail=10 nginx

echo.
echo [7] Verificacion de puertos...
echo ======================================
netstat -an | findstr ":80\|:443"

echo.
echo ======================================
echo   Verificacion completada
echo ======================================

pause
