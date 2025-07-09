# Proyecto2Net48

Proyecto de prueba para .NET Framework 4.8 diseñado para validar la compilación y ejecución en un self-hosted runner de GitHub Actions.

## Descripción

Este proyecto es una aplicación de consola que demuestra:
- Compilación exitosa con .NET Framework 4.8
- Operaciones matemáticas básicas con una clase Calculator
- Manejo de excepciones
- Información del sistema y entorno de ejecución

## Estructura del Proyecto

```
proyecto2-net48/
├── Proyecto2Net48.csproj    # Archivo de proyecto MSBuild
├── Program.cs               # Punto de entrada de la aplicación
├── Calculator.cs            # Clase con operaciones matemáticas
├── App.config              # Configuración de la aplicación
├── Properties/
│   └── AssemblyInfo.cs     # Información del ensamblado
└── README.md               # Este archivo
```

## Funcionalidades

### Calculator Class
- **Add**: Suma de dos números enteros
- **Subtract**: Resta de dos números enteros
- **Multiply**: Multiplicación de dos números enteros
- **Divide**: División con manejo de división por cero
- **Factorial**: Cálculo del factorial de un número
- **IsPrime**: Verificación si un número es primo

### Program Principal
- Muestra información del sistema
- Demuestra el uso de la clase Calculator
- Maneja excepciones apropiadamente
- Proporciona feedback visual de la ejecución

## Compilación

### Usando MSBuild directamente
```bash
MSBuild.exe Proyecto2Net48.csproj /p:Configuration=Release /p:Platform=AnyCPU
```

### En GitHub Actions Self-Hosted Runner
Este proyecto está configurado para compilarse automáticamente usando el workflow de GitHub Actions que detecta MSBuild en el sistema.

## Ejecución

Después de la compilación, el ejecutable se encuentra en:
```
bin/Release/Proyecto2Net48.exe
```

## Requisitos

- .NET Framework 4.8
- MSBuild (incluido con Visual Studio o Build Tools)
- Windows (para self-hosted runner)

## Propósito

Este proyecto sirve como prueba de concepto para validar que:
1. El self-hosted runner puede compilar proyectos .NET Framework 4.8
2. MSBuild está correctamente configurado
3. La ejecución de aplicaciones funciona correctamente
4. Los logs y outputs son capturados apropiadamente

## Autor

CleverIT - 2025
