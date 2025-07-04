@echo off
echo ======================================
echo   Informacion de Red para SSL
echo ======================================

echo.
echo [1] Obteniendo IP publica...
echo Tu IP publica es:
curl -s ifconfig.me
echo.

echo.
echo [2] Verificando puertos abiertos localmente...
echo Puertos en uso:
netstat -an | findstr ":80\|:443\|:9000"

echo.
echo [3] Informacion de red local...
echo IP local:
ipconfig | findstr "IPv4"

echo.
echo ======================================
echo   Instrucciones para configurar DNS
echo ======================================
echo.
echo 1. Anota tu IP publica mostrada arriba
echo 2. Ve al panel de control de tu proveedor de dominio
echo 3. Crea un registro A que apunte a esta IP
echo 4. Ejemplo:
echo    Nombre: sonarqube (o el subdominio que prefieras)
echo    Tipo: A
echo    Valor: [tu-ip-publica]
echo    TTL: 300 (5 minutos)
echo.
echo 5. Espera la propagacion DNS (5-60 minutos)
echo 6. Verifica con: nslookup tu-dominio.com
echo.

pause
