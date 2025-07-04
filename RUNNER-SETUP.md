# Configuración del Self-Hosted Runner para SonarQube

## 🐛 Problema encontrado

El error `unzip: command not found` indica que el runner self-hosted no tiene las dependencias necesarias instaladas.

## 🔧 Solución

### Opción 1: Configuración automática (Recomendada)

```bash
# Hacer el script ejecutable
chmod +x setup-runner-dependencies.sh

# Ejecutar la configuración
./setup-runner-dependencies.sh
```

Este script instalará automáticamente:
- ✅ `unzip` - Para descomprimir SonarScanner
- ✅ `wget` - Para descargar dependencias
- ✅ `curl` - Para comunicación HTTP
- ✅ `git` - Para control de versiones
- ✅ `java-17` - Runtime de Java para SonarScanner
- ✅ `sonar-scanner` - CLI de SonarQube

### Opción 2: Instalación manual

#### Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install -y unzip wget curl git openjdk-17-jre-headless
```

#### CentOS/RHEL/Fedora:
```bash
sudo yum update -y
sudo yum install -y unzip wget curl git java-17-openjdk-headless
```

#### Alpine Linux:
```bash
sudo apk update
sudo apk add --no-cache unzip wget curl git openjdk17-jre-headless
```

## 📋 Workflows disponibles

### 1. `test-sonar.yml` (Mejorado)
- ✅ Instala dependencias automáticamente en cada ejecución
- ✅ Funciona con cualquier runner
- ⚠️ Más lento (instala dependencias cada vez)

### 2. `test-sonar-manual.yml` (Control total)
- ✅ Instalación manual de SonarScanner
- ✅ Cache de dependencias
- ✅ Configuración detallada del proyecto
- ⚠️ Más complejo

### 3. `sonar-clean.yml` (Eficiente)
- ✅ Asume dependencias pre-instaladas
- ✅ Más rápido
- ✅ Configuración limpia
- ❌ Requiere setup previo

## 🚀 Uso recomendado

### Para configuración inicial:
```bash
# 1. Configurar el runner
./setup-runner-dependencies.sh

# 2. Usar el workflow limpio para mejor rendimiento
# Usar: sonar-clean.yml
```

### Configuración de secrets en GitHub:

1. Ve a tu repositorio → Settings → Secrets and variables → Actions
2. Agrega los secrets:

```
SONAR_TOKEN=tu_token_de_sonarqube
SONAR_HOST_URL=https://tu-dominio.com  # o http://localhost:9000
```

### Para obtener el token de SonarQube:
1. Accede a tu SonarQube
2. Ve a My Account → Security → Tokens
3. Genera un nuevo token
4. Copia el token y agrégalo como secret

## 🔍 Verificar configuración

```bash
# Verificar Java
java -version

# Verificar SonarScanner
sonar-scanner --version

# Verificar dependencias
which unzip wget curl git
```

## 🧪 Probar el workflow

```bash
# Disparar el workflow manualmente desde GitHub
# O hacer un push a main/master
```

## 📊 Configuración del proyecto SonarQube

El workflow automáticamente configura:
- **Project Key**: `owner_repository-name`
- **Sources**: Todo el directorio (`.`)
- **Exclusions**: Archivos no relevantes (logs, builds, etc.)
- **Encoding**: UTF-8

### Personalización (opcional):

Crea un archivo `sonar-project.properties` en la raíz:

```properties
sonar.projectKey=mi-proyecto-custom
sonar.projectName=Mi Proyecto
sonar.projectVersion=1.0
sonar.sources=src
sonar.exclusions=**/tests/**,**/node_modules/**
sonar.sourceEncoding=UTF-8

# Para JavaScript/TypeScript
sonar.javascript.lcov.reportPaths=coverage/lcov.info

# Para Python
sonar.python.coverage.reportPaths=coverage.xml

# Para Java
sonar.java.coveragePlugin=jacoco
sonar.jacoco.reportPaths=target/jacoco.exec
```

## 🔧 Solución de problemas

### Error: `java: command not found`
```bash
sudo apt-get install openjdk-17-jre-headless
```

### Error: `sonar-scanner: command not found`
```bash
# Ejecutar el script de configuración
./setup-runner-dependencies.sh
```

### Error de conexión a SonarQube
- Verificar `SONAR_HOST_URL` en secrets
- Verificar que SonarQube esté ejecutándose
- Verificar token en `SONAR_TOKEN`

### Error de permisos
```bash
# Dar permisos al script
chmod +x setup-runner-dependencies.sh

# Si necesitas sudo para el runner
sudo usermod -aG sudo runner-user
```
