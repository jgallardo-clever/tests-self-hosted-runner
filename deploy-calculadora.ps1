# Script de despliegue para Calculadora Web - Windows Server 2022
# Este script compila y despliega la aplicación web en IIS
# Optimizado para Windows Server 2022 con MSBuild en PATH

param(
    [Parameter(Mandatory=$false)]
    [string]$Configuration = "Release",
    
    [Parameter(Mandatory=$false)]
    [string]$IISPath = "C:\inetpub\wwwroot\calculadora-web",
    
    [Parameter(Mandatory=$false)]
    [switch]$CreateBackup = $true,
    
    [Parameter(Mandatory=$false)]
    [switch]$ConfigureIIS = $false
)

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  Despliegue Calculadora Web - Windows Server 2022" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Configuración del despliegue:" -ForegroundColor White
Write-Host "• Configuración: $Configuration" -ForegroundColor Gray
Write-Host "• Ruta IIS: $IISPath" -ForegroundColor Gray
Write-Host "• Crear backup: $CreateBackup" -ForegroundColor Gray
Write-Host "• Configurar IIS: $ConfigureIIS" -ForegroundColor Gray
Write-Host ""

# Verificar que estamos en el directorio correcto
$projectPath = "calculadora-web\CalculadoraWeb.csproj"
if (!(Test-Path $projectPath)) {
    Write-Error "No se encontró el archivo de proyecto: $projectPath"
    Write-Error "Asegúrate de ejecutar este script desde el directorio raíz del repositorio."
    exit 1
}

Write-Host "1. Verificando entorno Windows Server 2022..." -ForegroundColor Yellow

# Verificar MSBuild (ya está en PATH en Windows Server 2022)
try {
    $msbuildVersion = & msbuild -version 2>$null | Select-Object -Last 1
    Write-Host "   ✅ MSBuild disponible: $msbuildVersion" -ForegroundColor Green
} catch {
    Write-Error "MSBuild no está disponible en PATH. Verifica la instalación."
    exit 1
}

# Verificar .NET Framework 4.8
$dotNetVersion = Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\" -Name Release -ErrorAction SilentlyContinue
if (!$dotNetVersion -or $dotNetVersion.Release -lt 528040) {
    Write-Warning "   ⚠️  .NET Framework 4.8 no detectado completamente."
} else {
    Write-Host "   ✅ .NET Framework 4.8 instalado (Release: $($dotNetVersion.Release))" -ForegroundColor Green
}

# Verificar IIS (si está instalado)
$iisFeature = Get-WindowsFeature -Name IIS-WebServer -ErrorAction SilentlyContinue
if ($iisFeature -and $iisFeature.InstallState -eq "Installed") {
    Write-Host "   ✅ IIS está instalado y habilitado" -ForegroundColor Green
} else {
    Write-Warning "   ⚠️  IIS no parece estar instalado o habilitado"
}

# Verificar ASP.NET 4.8 en IIS
$aspNetPath = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe"
if (Test-Path $aspNetPath) {
    Write-Host "   ✅ ASP.NET 4.x disponible para IIS" -ForegroundColor Green
} else {
    Write-Warning "   ⚠️  ASP.NET tools no encontradas"
}

Write-Host ""
Write-Host "2. Compilando el proyecto..." -ForegroundColor Yellow

# Limpiar y compilar
$buildArgs = @(
    $projectPath,
    "/p:Configuration=$Configuration",
    "/p:Platform=Any CPU",
    "/verbosity:minimal",
    "/nologo"
)

Write-Host "   Ejecutando: msbuild $($buildArgs -join ' ')" -ForegroundColor Gray
$buildResult = & msbuild @buildArgs

if ($LASTEXITCODE -ne 0) {
    Write-Error "Error en la compilación. Revisa los errores anteriores."
    exit 1
}

Write-Host "   ✅ Compilación exitosa" -ForegroundColor Green

Write-Host ""
Write-Host "3. Preparando despliegue..." -ForegroundColor Yellow

# Crear directorio de IIS si no existe
if (!(Test-Path $IISPath)) {
    Write-Host "   Creando directorio de destino: $IISPath" -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path $IISPath | Out-Null
}

# Crear backup si se solicita
if ($CreateBackup -and (Test-Path $IISPath) -and (Get-ChildItem $IISPath | Measure-Object).Count -gt 0) {
    $backupPath = "C:\inetpub\backups\calculadora-web-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Host "   Creando backup en: $backupPath" -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path (Split-Path $backupPath) | Out-Null
    Copy-Item -Path $IISPath -Destination $backupPath -Recurse -Force
    Write-Host "   ✅ Backup creado exitosamente" -ForegroundColor Green
}

Write-Host ""
Write-Host "4. Desplegando archivos..." -ForegroundColor Yellow

# Archivos y directorios a copiar
$itemsToCopy = @(
    @{Source = "calculadora-web\*.aspx"; Destination = ""},
    @{Source = "calculadora-web\*.css"; Destination = ""},
    @{Source = "calculadora-web\Web.config"; Destination = ""},
    @{Source = "calculadora-web\bin\*"; Destination = "bin"}
)

foreach ($item in $itemsToCopy) {
    $sourceFiles = Get-ChildItem -Path $item.Source -ErrorAction SilentlyContinue
    
    foreach ($file in $sourceFiles) {
        $destinationPath = if ($item.Destination) { 
            Join-Path $IISPath $item.Destination 
        } else { 
            $IISPath 
        }
        
        if (!(Test-Path $destinationPath)) {
            New-Item -ItemType Directory -Force -Path $destinationPath | Out-Null
        }
        
        $destFile = Join-Path $destinationPath $file.Name
        Copy-Item -Path $file.FullName -Destination $destFile -Force
        Write-Host "   📁 Copiado: $($file.Name)" -ForegroundColor Gray
    }
}

Write-Host "   ✅ Archivos desplegados exitosamente" -ForegroundColor Green

Write-Host ""
Write-Host "5. Configurando permisos de IIS..." -ForegroundColor Yellow

try {
    # Configurar permisos para IIS_IUSRS
    icacls $IISPath /grant "IIS_IUSRS:(OI)(CI)F" /T /Q | Out-Null
    
    # Configurar permisos para el identity del Application Pool
    icacls $IISPath /grant "ApplicationPoolIdentity:(OI)(CI)F" /T /Q | Out-Null
    
    Write-Host "   ✅ Permisos de IIS configurados" -ForegroundColor Green
} catch {
    Write-Warning "   ⚠️  No se pudieron configurar los permisos automáticamente. Configúralos manualmente en IIS."
}

Write-Host ""
Write-Host "6. Verificando despliegue..." -ForegroundColor Yellow

# Verificar archivos críticos
$requiredFiles = @("Default.aspx", "Web.config", "Styles.css")
$allFilesExist = $true

foreach ($file in $requiredFiles) {
    $filePath = Join-Path $IISPath $file
    if (Test-Path $filePath) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $file - FALTA" -ForegroundColor Red
        $allFilesExist = $false
    }
}

# Verificar directorio bin
$binPath = Join-Path $IISPath "bin"
if (Test-Path $binPath) {
    $binFiles = Get-ChildItem $binPath | Measure-Object
    Write-Host "   ✅ Directorio bin ($($binFiles.Count) archivos)" -ForegroundColor Green
} else {
    Write-Host "   ❌ Directorio bin - FALTA" -ForegroundColor Red
    $allFilesExist = $false
}

Write-Host ""
if ($allFilesExist) {
    Write-Host "====================================================" -ForegroundColor Green
    Write-Host "         ¡DESPLIEGUE COMPLETADO EXITOSAMENTE!" -ForegroundColor Green
    Write-Host "====================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "La aplicación ha sido desplegada en:" -ForegroundColor White
    Write-Host "$IISPath" -ForegroundColor Cyan
    Write-Host ""
    
    if ($ConfigureIIS) {
        Write-Host "7. Configurando IIS automáticamente..." -ForegroundColor Yellow
        
        try {
            # Importar módulo de IIS si está disponible
            Import-Module WebAdministration -ErrorAction SilentlyContinue
            
            $siteName = "CalculadoraWeb"
            $port = 8080
            
            # Verificar si el sitio ya existe
            $existingSite = Get-Website -Name $siteName -ErrorAction SilentlyContinue
            if ($existingSite) {
                Remove-Website -Name $siteName
                Write-Host "   Sitio web existente removido" -ForegroundColor Gray
            }
            
            # Crear Application Pool específico
            $appPoolName = "CalculadoraWebPool"
            $existingPool = Get-IISAppPool -Name $appPoolName -ErrorAction SilentlyContinue
            if ($existingPool) {
                Remove-IISAppPool -Name $appPoolName -Confirm:$false
            }
            
            New-IISAppPool -Name $appPoolName -Force
            Set-ItemProperty -Path "IIS:\AppPools\$appPoolName" -Name "managedRuntimeVersion" -Value "v4.0"
            Set-ItemProperty -Path "IIS:\AppPools\$appPoolName" -Name "enable32BitAppOnWin64" -Value $false
            
            # Crear sitio web
            New-Website -Name $siteName -Port $port -PhysicalPath $IISPath -ApplicationPool $appPoolName
            
            Write-Host "   ✅ Sitio web configurado en puerto $port" -ForegroundColor Green
            Write-Host "   ✅ Application Pool '$appPoolName' creado con .NET 4.0" -ForegroundColor Green
            Write-Host ""
            Write-Host "URLs de acceso:" -ForegroundColor White
            Write-Host "• http://localhost:$port" -ForegroundColor Cyan
            Write-Host "• http://$env:COMPUTERNAME:$port" -ForegroundColor Cyan
            
        } catch {
            Write-Warning "   ⚠️  No se pudo configurar IIS automáticamente: $($_.Exception.Message)"
            Write-Host ""
            Write-Host "Configuración manual requerida en IIS Manager:" -ForegroundColor White
            Write-Host "1. Crear un nuevo sitio web o aplicación" -ForegroundColor Gray
            Write-Host "2. Apuntar a la ruta: $IISPath" -ForegroundColor Gray
            Write-Host "3. Configurar Application Pool para .NET Framework 4.8" -ForegroundColor Gray
            Write-Host "4. Asegurar que el modo de pipeline sea 'Integrated'" -ForegroundColor Gray
        }
    } else {
        Write-Host "URLs de acceso (después de configurar IIS):" -ForegroundColor White
        Write-Host "• http://localhost/calculadora-web" -ForegroundColor Cyan
        Write-Host "• http://$env:COMPUTERNAME/calculadora-web" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Configuración manual requerida en IIS Manager:" -ForegroundColor White
        Write-Host "1. Crear un nuevo sitio web o aplicación" -ForegroundColor Gray
        Write-Host "2. Apuntar a la ruta: $IISPath" -ForegroundColor Gray
        Write-Host "3. Configurar Application Pool para .NET Framework 4.8" -ForegroundColor Gray
        Write-Host "4. Asegurar que el modo de pipeline sea 'Integrated'" -ForegroundColor Gray
        Write-Host ""
        Write-Host "💡 Tip: Ejecuta con -ConfigureIIS para configuración automática" -ForegroundColor Yellow
    }
} else {
    Write-Host "====================================================" -ForegroundColor Red
    Write-Host "           ERROR EN EL DESPLIEGUE" -ForegroundColor Red
    Write-Host "====================================================" -ForegroundColor Red
    Write-Host "Algunos archivos críticos no se copiaron correctamente." -ForegroundColor Red
    Write-Host "Revisa los errores anteriores y vuelve a intentar." -ForegroundColor Red
    exit 1
}

Write-Host ""
