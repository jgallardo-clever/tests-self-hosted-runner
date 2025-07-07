# Proyecto Test .NET Framework 4.8

Proyecto de prueba simple para .NET Framework 4.8 con GitHub Actions.

## Estructura del Proyecto

- **Program.cs**: Aplicación de consola simple
- **TestNet48.csproj**: Archivo de proyecto
- **App.config**: Configuración de la aplicación
- **Properties/AssemblyInfo.cs**: Información del ensamblado

## Funcionalidades

La aplicación simplemente:

- Imprime un mensaje de saludo
- Muestra que la compilación fue exitosa
- Imprime la fecha y hora actual

## Compilación Local

```bash
# Compilar el proyecto
msbuild TestNet48.csproj /p:Configuration=Release

# Ejecutar la aplicación
bin\Release\TestNet48.exe
```

## GitHub Actions

El workflow se ejecuta en un self-hosted runner y compila/ejecuta el proyecto automáticamente.
