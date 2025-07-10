# Script rápido para probar la compilación en Windows Server 2022
# Utiliza MSBuild disponible en PATH

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Test Build - Calculadora Web" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Cambiar al directorio del script
Set-Location $PSScriptRoot

# Verificar que el proyecto existe
$projectPath = "calculadora-web\CalculadoraWeb.csproj"
if (!(Test-Path $projectPath)) {
    Write-Error "❌ Proyecto no encontrado: $projectPath"
    Write-Error "Ejecuta este script desde el directorio raíz del repositorio"
    exit 1
}

Write-Host "✅ Proyecto encontrado: $projectPath" -ForegroundColor Green
Write-Host ""

# Limpiar build anterior
Write-Host "🧹 Limpiando build anterior..." -ForegroundColor Yellow
if (Test-Path "calculadora-web\bin") {
    Remove-Item "calculadora-web\bin" -Recurse -Force
    Write-Host "   Directorio bin limpiado" -ForegroundColor Gray
}
if (Test-Path "calculadora-web\obj") {
    Remove-Item "calculadora-web\obj" -Recurse -Force
    Write-Host "   Directorio obj limpiado" -ForegroundColor Gray
}

Write-Host ""

# Test Debug build
Write-Host "🔨 Compilando en modo Debug..." -ForegroundColor Yellow
$debugResult = & msbuild $projectPath /p:Configuration=Debug /p:Platform="Any CPU" /verbosity:minimal /nologo

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build Debug: EXITOSO" -ForegroundColor Green
    
    # Verificar DLL generada
    if (Test-Path "calculadora-web\bin\CalculadoraWeb.dll") {
        $dllSize = (Get-Item "calculadora-web\bin\CalculadoraWeb.dll").Length
        Write-Host "   📦 DLL generada: $dllSize bytes" -ForegroundColor Gray
    }
} else {
    Write-Host "❌ Build Debug: FALLÓ" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test Release build
Write-Host "🔨 Compilando en modo Release..." -ForegroundColor Yellow
$releaseResult = & msbuild $projectPath /p:Configuration=Release /p:Platform="Any CPU" /verbosity:minimal /nologo

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build Release: EXITOSO" -ForegroundColor Green
    
    # Verificar DLL generada
    if (Test-Path "calculadora-web\bin\CalculadoraWeb.dll") {
        $dllSize = (Get-Item "calculadora-web\bin\CalculadoraWeb.dll").Length
        Write-Host "   📦 DLL generada: $dllSize bytes" -ForegroundColor Gray
    }
} else {
    Write-Host "❌ Build Release: FALLÓ" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Mostrar información del build
Write-Host "📋 Información del build:" -ForegroundColor White
Write-Host "   • MSBuild version: $(& msbuild -version 2>$null | Select-Object -Last 1)" -ForegroundColor Gray
Write-Host "   • Target Framework: .NET Framework 4.8" -ForegroundColor Gray
Write-Host "   • Configuración: Debug y Release" -ForegroundColor Gray

# Listar archivos generados
Write-Host ""
Write-Host "📁 Archivos generados en bin:" -ForegroundColor White
if (Test-Path "calculadora-web\bin") {
    Get-ChildItem "calculadora-web\bin" | ForEach-Object {
        $size = if ($_.PSIsContainer) { "[DIR]" } else { "$($_.Length) bytes" }
        Write-Host "   $($_.Name) - $size" -ForegroundColor Gray
    }
} else {
    Write-Host "   ❌ Directorio bin no encontrado" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "     ✅ TEST BUILD COMPLETADO" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Para desplegar en IIS ejecuta:" -ForegroundColor White
Write-Host "   .\deploy-calculadora.ps1" -ForegroundColor Cyan
Write-Host "   .\deploy-calculadora.ps1 -ConfigureIIS" -ForegroundColor Cyan
Write-Host ""
