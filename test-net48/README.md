# Proyecto Test .NET Framework 4.8

Este es un proyecto de prueba simple para demostrar la compilación y ejecución de aplicaciones .NET Framework 4.8 usando GitHub Actions.

## Estructura del Proyecto

- **Program.cs**: Punto de entrada principal de la aplicación
- **Calculator.cs**: Clase con operaciones matemáticas básicas
- **TestNet48.csproj**: Archivo de proyecto de .NET Framework
- **App.config**: Configuración de la aplicación
- **Properties/AssemblyInfo.cs**: Información del ensamblado

## Funcionalidades

La aplicación incluye:

- Operaciones matemáticas básicas (suma, resta, multiplicación, división)
- Validación de números primos
- Interfaz de consola simple

## Compilación Local

Para compilar el proyecto localmente:

```bash
# Restaurar paquetes NuGet
nuget restore TestNet48.csproj

# Compilar el proyecto
msbuild TestNet48.csproj /p:Configuration=Release /p:Platform="Any CPU"

# Ejecutar la aplicación
bin\Release\TestNet48.exe
```

## GitHub Actions

El workflow `net48.yml` se ejecuta automáticamente cuando:

- Se hace push a las ramas main/master
- Se crean pull requests
- Se ejecuta manualmente (workflow_dispatch)

El workflow incluye:

- Configuración de MSBuild
- Restauración de paquetes NuGet
- Compilación del proyecto
- Ejecución de la aplicación
- Archivado de artefactos de compilación

## Requisitos

- .NET Framework 4.8
- Visual Studio o MSBuild Tools
- Windows (para ejecución)
