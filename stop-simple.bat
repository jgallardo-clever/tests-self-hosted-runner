@echo off
echo ======================================
echo   Deteniendo SonarQube Simple
echo ======================================

echo.
echo Deteniendo contenedores...
docker-compose -f docker-compose-simple.yml down

if %errorlevel% equ 0 (
    echo.
    echo SonarQube detenido correctamente.
) else (
    echo.
    echo ERROR: No se pudo detener SonarQube
)

echo.
echo ¿Deseas eliminar tambien los volumenes de datos? (S/N)
set /p choice="Ingresa tu opcion: "
if /i "%choice%"=="S" (
    echo.
    echo Eliminando volumenes...
    docker-compose -f docker-compose-simple.yml down -v
    echo Volumenes eliminados.
)

pause
