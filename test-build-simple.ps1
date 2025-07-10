# Script de test simplificado para Windows Server 2022
# No requiere targets de Visual Studio

param(
    [Parameter(Mandatory=$false)]
    [string]$Configuration = "Release"
)

Write-Host "============================================"
Write-Host "Test Build Simple - Windows Server 2022"
Write-Host "============================================"
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

Write-Host "📋 Verificando archivos fuente..."
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "   ✅ $file"
    } else {
        Write-Host "   ❌ $file - FALTANTE"
        exit 1
    }
}

# Limpiar build anterior
Write-Host ""
Write-Host "🧹 Limpiando build anterior..."
@("calculadora-web\bin", "calculadora-web\obj") | ForEach-Object {
    if (Test-Path $_) {
        Remove-Item $_ -Recurse -Force
        Write-Host "   Limpiado: $_"
    }
}

# Test 1: Proyecto principal
Write-Host ""
Write-Host "🔨 Test 1: Proyecto principal..."
$result1 = & msbuild "calculadora-web\CalculadoraWeb.csproj" /p:Configuration=$Configuration /p:Platform="Any CPU" /target:Build /verbosity:minimal /nologo 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Proyecto principal: EXITOSO"
    $method = "Principal"
} else {
    Write-Host "   ❌ Proyecto principal: FALLÓ"
    Write-Host "   Salida: $result1"
    
    # Test 2: Proyecto simplificado
    Write-Host ""
    Write-Host "🔨 Test 2: Proyecto simplificado..."
    $result2 = & msbuild "calculadora-web\CalculadoraWeb-Simple.csproj" /p:Configuration=$Configuration /p:Platform="Any CPU" /target:Build /verbosity:minimal /nologo 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ Proyecto simplificado: EXITOSO"
        $method = "Simplificado"
    } else {
        Write-Host "   ❌ Proyecto simplificado: FALLÓ"
        Write-Host "   Salida: $result2"
        
        # Test 3: Compilación directa
        Write-Host ""
        Write-Host "🔨 Test 3: Compilación directa con csc.exe..."
        
        $cscPath = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
        if (!(Test-Path $cscPath)) {
            $cscPath = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe"
        }
        
        if (Test-Path $cscPath) {
            Write-Host "   Compilador encontrado: $cscPath"
            
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
                Write-Host "   ✅ Compilación directa: EXITOSA"
                $method = "Directo (csc.exe)"
            } else {
                Write-Host "   ❌ Compilación directa: FALLÓ"
                Write-Host "   Salida: $result3"
                Write-Host ""
                Write-Host "❌ TODOS LOS MÉTODOS DE COMPILACIÓN FALLARON"
                exit 1
            }
        } else {
            Write-Host "   ❌ Compilador csc.exe no encontrado"
            exit 1
        }
    }
}

# Verificar resultado
Write-Host ""
Write-Host "📦 Verificando resultado..."
if (Test-Path "calculadora-web\bin\CalculadoraWeb.dll") {
    $dll = Get-Item "calculadora-web\bin\CalculadoraWeb.dll"
    Write-Host "   ✅ DLL generada: $($dll.Length) bytes"
    Write-Host "   📅 Fecha: $($dll.LastWriteTime)"
} else {
    Write-Host "   ❌ DLL no encontrada"
    exit 1
}

Write-Host ""
Write-Host "============================================"
Write-Host "        ✅ TEST BUILD EXITOSO"
Write-Host "============================================"
Write-Host ""
Write-Host "🎯 Método utilizado: $method"
Write-Host "📁 DLL ubicada en: calculadora-web\bin\CalculadoraWeb.dll"
Write-Host ""
Write-Host "🚀 Ejecuta el workflow de GitHub Actions para desplegar en IIS"
Write-Host ""
