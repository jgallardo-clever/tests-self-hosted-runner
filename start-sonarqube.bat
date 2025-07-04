@echo off
echo ======================================
echo    Iniciando SonarQube con Docker
echo ======================================

echo.
echo Verificando si Docker esta ejecutandose...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker no esta instalado o no esta ejecutandose
    echo Por favor instala Docker Desktop e intentalo de nuevo
    pause
    exit /b 1
)

echo Docker detectado correctamente.
echo.

echo Iniciando contenedores...
docker-compose up -d

if %errorlevel% equ 0 (
    echo.
    echo ======================================
    echo   SonarQube iniciado correctamente!
    echo ======================================
    echo.
    echo URL: http://localhost:9000
    echo Usuario por defecto: admin
    echo Contraseña por defecto: admin
    echo.
    echo Esperando a que SonarQube este listo...
    timeout /t 30 /nobreak >nul
    echo.
    echo Abriendo SonarQube en el navegador...
    start http://localhost:9000
) else (
    echo.
    echo ERROR: No se pudo iniciar SonarQube
    echo Revisa los logs con: docker-compose logs
)

pause
