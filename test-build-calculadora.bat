@echo off
echo ====================================================
echo      Probando build de Calculadora Web
echo ====================================================
echo.

cd /d "%~dp0"

echo 1. Verificando que existe el proyecto...
if not exist "calculadora-web\CalculadoraWeb.csproj" (
    echo ERROR: No se encontro el archivo de proyecto
    echo Asegurate de ejecutar este script desde el directorio raiz
    pause
    exit /b 1
)
echo    ✓ Proyecto encontrado

echo.
echo 2. Compilando en modo Debug...
msbuild calculadora-web\CalculadoraWeb.csproj /p:Configuration=Debug /p:Platform="Any CPU" /verbosity:minimal /nologo

if %ERRORLEVEL% neq 0 (
    echo ERROR: Fallo la compilacion en modo Debug
    pause
    exit /b 1
)
echo    ✓ Compilacion Debug exitosa

echo.
echo 3. Compilando en modo Release...
msbuild calculadora-web\CalculadoraWeb.csproj /p:Configuration=Release /p:Platform="Any CPU" /verbosity:minimal /nologo

if %ERRORLEVEL% neq 0 (
    echo ERROR: Fallo la compilacion en modo Release
    pause
    exit /b 1
)
echo    ✓ Compilacion Release exitosa

echo.
echo 4. Verificando archivos generados...
if exist "calculadora-web\bin\Debug\CalculadoraWeb.dll" (
    echo    ✓ DLL Debug generada
) else (
    echo    ✗ DLL Debug no encontrada
)

if exist "calculadora-web\bin\Release\CalculadoraWeb.dll" (
    echo    ✓ DLL Release generada
) else (
    echo    ✗ DLL Release no encontrada
)

echo.
echo ====================================================
echo           BUILD COMPLETADO EXITOSAMENTE
echo ====================================================
echo.
echo El proyecto se ha compilado correctamente.
echo Para desplegarlo en IIS, ejecuta: deploy-calculadora.ps1
echo.
pause
