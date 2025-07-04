@echo off
echo ======================================
echo   Estado de SonarQube Simple
echo ======================================

echo.
echo Verificando estado de los contenedores...
docker-compose -f docker-compose-simple.yml ps

echo.
echo ======================================
echo   Estado de Servicios
echo ======================================

echo.
echo [1] Verificando SonarQube...
curl -s -o nul -w "HTTP Status: %%{http_code}\n" http://localhost:9000/api/system/status 2>nul
if %errorlevel% equ 0 (
    echo SonarQube: ✓ Respondiendo
) else (
    echo SonarQube: ✗ No responde
)

echo.
echo [2] Verificando PostgreSQL...
docker exec postgresql pg_isready -U sonar >nul 2>&1
if %errorlevel% equ 0 (
    echo PostgreSQL: ✓ Funcionando
) else (
    echo PostgreSQL: ✗ No responde
)

echo.
echo ======================================
echo   Informacion de Acceso
echo ======================================
echo.
echo URL de SonarQube: http://localhost:9000
echo Usuario: admin
echo Contraseña: admin
echo.

echo ¿Deseas abrir SonarQube en el navegador? (S/N)
set /p choice="Ingresa tu opcion: "
if /i "%choice%"=="S" (
    start http://localhost:9000
)

pause
