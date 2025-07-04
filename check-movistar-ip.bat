@echo off
echo ======================================
echo   Configuracion IP Movistar Chile
echo ======================================

echo.
echo Tu proveedor te asigno: 190-20-39-204.baf.movistar.cl
echo.

echo [1] Resolviendo la IP numerica...
for /f %%i in ('nslookup 190-20-39-204.baf.movistar.cl ^| findstr "Address" ^| findstr /v "#"') do set movistar_ip=%%i
echo IP numerica: %movistar_ip%

echo.
echo [2] Verificando tu IP publica actual...
for /f %%i in ('curl -s ifconfig.me') do set current_ip=%%i
echo IP actual: %current_ip%

echo.
if "%movistar_ip%"=="%current_ip%" (
    echo ✓ PERFECTO: Tu equipo ya usa la IP de Movistar
    echo.
) else (
    echo ⚠️  ATENCION: Las IPs no coinciden
    echo.
    echo Posibles causas:
    echo 1. Necesitas configurar/activar la IP en tu router
    echo 2. La IP aun no esta propagada
    echo 3. Estas detras de un NAT/Router
    echo.
    echo SOLUCION:
    echo 1. Contacta a Movistar para activar la IP
    echo 2. Configura tu router para usar esta IP
    echo 3. Configura port forwarding si es necesario
)

echo.
echo [3] Verificando conectividad de la IP de Movistar...
ping -n 4 190-20-39-204.baf.movistar.cl

echo.
echo [4] Verificando resolucion DNS...
nslookup 190-20-39-204.baf.movistar.cl

echo.
echo ======================================
echo   Instrucciones para usar esta IP
echo ======================================
echo.
echo Para configurar tu dominio:
echo 1. Ve al panel DNS de tu proveedor de dominio
echo 2. Crea un registro CNAME (no A):
echo    - Nombre: sonarqube
echo    - Tipo: CNAME  
echo    - Valor: 190-20-39-204.baf.movistar.cl
echo.
echo O alternativamente, usa registro A:
echo    - Nombre: sonarqube
echo    - Tipo: A
echo    - Valor: %movistar_ip%
echo.
echo 3. Tu SonarQube sera accesible en:
echo    https://sonarqube.tu-dominio.com
echo.

pause
