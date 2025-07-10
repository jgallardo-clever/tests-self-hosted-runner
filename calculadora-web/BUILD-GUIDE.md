# 🔧 Guía de Compilación - Windows Server 2022

## Problema Común: Targets de Visual Studio No Disponibles

En Windows Server 2022 con solo MSBuild (sin Visual Studio completo), es común encontrar el error:

```
error MSB4226: The imported project "...\WebApplications\Microsoft.WebApplication.targets" was not found
```

## ✅ Soluciones Implementadas

### 1. Proyecto Principal (CalculadoraWeb.csproj)
- Imports condicionales de targets de WebApplication
- Fallback automático si los targets no están disponibles

### 2. Proyecto Simplificado (CalculadoraWeb-Simple.csproj)  
- Sin dependencias de Visual Studio
- Solo usa targets básicos de MSBuild
- Garantiza compatibilidad con Windows Server

### 3. Compilación Directa (csc.exe)
- Último recurso usando el compilador C# directamente
- Ubicaciones verificadas:
  - `C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe`
  - `C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe`

## 🚀 Scripts de Test Disponibles

### Test Completo con Fallbacks
```powershell
.\test-build-simple.ps1
```
Prueba los 3 métodos en orden hasta encontrar uno que funcione.

### Test Básico (.bat)
```cmd
test-build-calculadora.bat
```
Test simple usando MSBuild estándar.

### Despliegue Completo
```powershell
# Básico
.\deploy-calculadora.ps1

# Con configuración automática de IIS
.\deploy-calculadora.ps1 -ConfigureIIS
```

## 🔄 Workflow de GitHub Actions

El workflow `.github/workflows/calculadora-web.yml` implementa la misma lógica de fallback:

1. **Intento 1**: Proyecto principal con targets de VS
2. **Intento 2**: Proyecto simplificado sin dependencias
3. **Intento 3**: Compilación directa con csc.exe

## 📋 Verificación del Entorno

### Verificar MSBuild
```powershell
msbuild -version
```

### Verificar .NET Framework 4.8
```powershell
Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\" -Name Release
```
Debe ser >= 528040 para .NET Framework 4.8

### Verificar Compilador C#
```powershell
Test-Path "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
```

## 🎯 Estrategia de Build

1. **Desarrollo Local**: Usa Visual Studio normal
2. **CI/CD (GitHub Actions)**: Usa lógica de fallback automático  
3. **Servidor Manual**: Usa scripts PowerShell con fallback

## 🔧 Troubleshooting

### Error: "WebApplication.targets not found"
- **Solución**: El sistema automáticamente usa el proyecto simplificado

### Error: "MSBuild no encontrado"
- **Verificar**: PATH incluye MSBuild
- **Solución**: Instalar Build Tools for Visual Studio

### Error: "csc.exe no encontrado"  
- **Verificar**: .NET Framework 4.8 instalado correctamente
- **Solución**: Reinstalar .NET Framework 4.8

### Error: "DLL no generada"
- **Verificar**: Permisos de escritura en carpeta bin
- **Solución**: Ejecutar como administrador

## 📁 Estructura de Archivos Generados

```
calculadora-web/
├── bin/
│   ├── CalculadoraWeb.dll     # Librería principal
│   └── CalculadoraWeb.pdb     # Símbolos de debug (opcional)
├── obj/                       # Archivos temporales (se limpian)
└── ...archivos fuente...
```

## 🌐 Despliegue en IIS

Una vez compilado exitosamente, los archivos necesarios son:

- `*.aspx` - Páginas web
- `*.css` - Estilos  
- `Web.config` - Configuración
- `bin/*.dll` - Librerías compiladas

El workflow copia automáticamente estos archivos a `C:\inetpub\wwwroot\calculadora-web`

---

**💡 Tip**: Siempre usa `test-build-simple.ps1` primero para verificar que la compilación funciona antes de hacer el despliegue completo.
