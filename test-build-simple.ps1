# Script de test simplificado para Windows Server 2022
# No requiere targets de Visual Studio

param(
    [Parameter(Mandatory=$false)]
    [string]$Configuration = "Release"
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Test Build Simple - Windows Server 2022" -ForegroundColor Cyan  
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

# Verificar archivos fuente
$requiredFiles = @(
    "calculadora-web\CalculadoraWeb.csproj",
    "calculadora-web\CalculadoraWeb-Simple.csproj",
    "calculadora-web\App_Code\Calculator.cs",
    "calculadora-web\Default.aspx.cs",
    "calculadora-web\Default.aspx.designer.cs",
    "calculadora-web\Properties\AssemblyInfo.cs"
)

Write-Host "📋 Verificando archivos fuente..." -ForegroundColor Yellow
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $file - FALTANTE" -ForegroundColor Red
        exit 1
    }
}

# Limpiar build anterior
Write-Host ""
Write-Host "🧹 Limpiando build anterior..." -ForegroundColor Yellow
@("calculadora-web\bin", "calculadora-web\obj") | ForEach-Object {
    if (Test-Path $_) {
        Remove-Item $_ -Recurse -Force
        Write-Host "   Limpiado: $_" -ForegroundColor Gray
    }
}

# Test 1: Proyecto principal
Write-Host ""
Write-Host "🔨 Test 1: Proyecto principal..." -ForegroundColor Yellow
$result1 = & msbuild "calculadora-web\CalculadoraWeb.csproj" /p:Configuration=$Configuration /p:Platform="Any CPU" /target:Build /verbosity:minimal /nologo 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Proyecto principal: EXITOSO" -ForegroundColor Green
    $method = "Principal"
} else {
    Write-Host "   ❌ Proyecto principal: FALLÓ" -ForegroundColor Red
    Write-Host "   Salida: $result1" -ForegroundColor Gray
    
    # Test 2: Proyecto simplificado
    Write-Host ""
    Write-Host "🔨 Test 2: Proyecto simplificado..." -ForegroundColor Yellow
    $result2 = & msbuild "calculadora-web\CalculadoraWeb-Simple.csproj" /p:Configuration=$Configuration /p:Platform="Any CPU" /target:Build /verbosity:minimal /nologo 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Proyecto simplificado: EXITOSO" -ForegroundColor Green
        $method = "Simplificado"
    } else {
        Write-Host "   ❌ Proyecto simplificado: FALLÓ" -ForegroundColor Red
        Write-Host "   Salida: $result2" -ForegroundColor Gray
        
        # Test 3: Compilación directa
        Write-Host ""
        Write-Host "🔨 Test 3: Compilación directa con csc.exe..." -ForegroundColor Yellow
        
        $cscPath = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
        if (!(Test-Path $cscPath)) {
            $cscPath = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe"
        }
        
        if (Test-Path $cscPath) {
            Write-Host "   Compilador encontrado: $cscPath" -ForegroundColor Gray
            
            # Crear directorio bin
            New-Item -ItemType Directory -Path "calculadora-web\bin" -Force | Out-Null
            
            # Referencias mínimas
            $frameworkPath = Split-Path $cscPath
            $refs = @(
                "$frameworkPath\System.dll",
                "$frameworkPath\System.Web.dll",
                "$frameworkPath\System.Core.dll"
            )
            
            $refArgs = @()
            foreach ($ref in $refs) {
                if (Test-Path $ref) {
                    $refArgs += "/reference:$ref"
                }
            }
            
            # Compilar
            $result3 = & $cscPath /target:library /out:"calculadora-web\bin\CalculadoraWeb.dll" $refArgs "calculadora-web\App_Code\Calculator.cs" "calculadora-web\Default.aspx.cs" "calculadora-web\Default.aspx.designer.cs" "calculadora-web\Properties\AssemblyInfo.cs" 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "   ✅ Compilación directa: EXITOSA" -ForegroundColor Green
                $method = "Directo (csc.exe)"
            } else {
                Write-Host "   ❌ Compilación directa: FALLÓ" -ForegroundColor Red
                Write-Host "   Salida: $result3" -ForegroundColor Gray
                Write-Host ""
                Write-Host "❌ TODOS LOS MÉTODOS DE COMPILACIÓN FALLARON" -ForegroundColor Red
                exit 1
            }
        } else {
            Write-Host "   ❌ Compilador csc.exe no encontrado" -ForegroundColor Red
            exit 1
        }
    }
}

# Verificar resultado
Write-Host ""
Write-Host "📦 Verificando resultado..." -ForegroundColor Yellow
if (Test-Path "calculadora-web\bin\CalculadoraWeb.dll") {
    $dll = Get-Item "calculadora-web\bin\CalculadoraWeb.dll"
    Write-Host "   ✅ DLL generada: $($dll.Length) bytes" -ForegroundColor Green
    Write-Host "   📅 Fecha: $($dll.LastWriteTime)" -ForegroundColor Gray
} else {
    Write-Host "   ❌ DLL no encontrada" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "        ✅ TEST BUILD EXITOSO" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "🎯 Método utilizado: $method" -ForegroundColor White
Write-Host "📁 DLL ubicada en: calculadora-web\bin\CalculadoraWeb.dll" -ForegroundColor Gray
Write-Host ""
Write-Host "🚀 Ejecuta el workflow de GitHub Actions para desplegar en IIS" -ForegroundColor Cyan
Write-Host ""
