@echo off
echo ======================================
echo   Renovacion de Certificados SSL
echo ======================================

echo.
echo Verificando certificados existentes...
docker-compose --profile setup run --rm certbot certificates

echo.
echo Intentando renovar certificados...
docker-compose --profile setup run --rm certbot renew --webroot -w /var/www/certbot

if %errorlevel% equ 0 (
    echo.
    echo ✓ Certificados renovados exitosamente!
    echo.
    echo Reiniciando Nginx para aplicar nuevos certificados...
    docker-compose restart nginx
    
    echo.
    echo ✓ Renovacion completada!
) else (
    echo.
    echo ✗ No fue necesario renovar los certificados o ocurrio un error
    echo Los certificados se renuevan automaticamente 30 dias antes del vencimiento
)

echo.
pause
