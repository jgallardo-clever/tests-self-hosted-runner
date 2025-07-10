# Calculadora Web - ASP.NET Framework 4.8

## Descripción
Mini aplicación web desarrollada en ASP.NET Framework 4.8 que implementa una calculadora con operaciones básicas (suma, resta y multiplicación). Diseñada para ser desplegada en Internet Information Services (IIS).

## Características
- ✅ Interfaz web moderna y responsiva
- ✅ Operaciones matemáticas: Suma, Resta y Multiplicación
- ✅ Validación de entrada de datos
- ✅ Manejo de errores
- ✅ Compatible con IIS
- ✅ Diseño responsive para móviles

## Tecnologías Utilizadas
- ASP.NET Web Forms (.NET Framework 4.8)
- C#
- HTML5 & CSS3
- JavaScript (para mejorar la experiencia de usuario)

## Estructura del Proyecto
```
calculadora-web/
├── App_Code/
│   └── Calculator.cs          # Lógica de operaciones matemáticas
├── Properties/
│   └── AssemblyInfo.cs        # Información del ensamblado
├── Default.aspx               # Página principal (UI)
├── Default.aspx.cs            # Código behind de la página
├── Default.aspx.designer.cs   # Archivo de diseñador
├── Styles.css                 # Estilos CSS
├── Web.config                 # Configuración de la aplicación
└── CalculadoraWeb.csproj      # Archivo de proyecto
```

## Funcionalidades
1. **Suma**: Realiza la adición de dos números
2. **Resta**: Realiza la sustracción de dos números
3. **Multiplicación**: Realiza el producto de dos números
4. **Validación**: Verifica que los valores ingresados sean números válidos
5. **Limpieza**: Botón para limpiar los campos y resultados

## Instalación y Despliegue

### Prerrequisitos
- IIS instalado y configurado
- .NET Framework 4.8 instalado
- Visual Studio o MSBuild para compilar

### Pasos para el despliegue manual
1. Compilar el proyecto en modo Release
2. Copiar los archivos compilados a `C:\inetpub\wwwroot\calculadora-web\`
3. Configurar un sitio web o aplicación en IIS
4. Asegurar que el Application Pool esté configurado para .NET Framework 4.8

### Despliegue con GitHub Actions
El proyecto incluye un workflow de GitHub Actions que automatiza:
- Compilación del proyecto
- Publicación de los artefactos
- Despliegue a la ruta de IIS

## Uso
1. Abrir la aplicación en el navegador
2. Ingresar el primer número
3. Ingresar el segundo número
4. Hacer clic en la operación deseada (Suma, Resta o Multiplicación)
5. Ver el resultado en pantalla
6. Usar el botón "Limpiar" para reiniciar

## API de la Clase Calculator
```csharp
// Suma de dos números
double resultado = Calculator.Sumar(5.0, 3.0); // 8.0

// Resta de dos números
double resultado = Calculator.Restar(5.0, 3.0); // 2.0

// Multiplicación de dos números
double resultado = Calculator.Multiplicar(5.0, 3.0); // 15.0

// Validación de número
double numero;
bool esValido = Calculator.EsNumeroValido("123.45", out numero);
```

## Contribución
1. Fork del repositorio
2. Crear una rama para la nueva funcionalidad
3. Realizar los cambios
4. Enviar Pull Request

## Autor
CleverIT - 2025

## Licencia
Este proyecto es de uso educativo y de demostración.
