# SonarQube Simple - Solo HTTP

Configuración simplificada de SonarQube con PostgreSQL, sin SSL ni configuraciones complejas.

## 🚀 Inicio Rápido

### Prerrequisitos

- Docker Desktop instalado y ejecutándose
- Docker Compose (incluido con Docker Desktop)

### Iniciar SonarQube

```bash
# Iniciar SonarQube simple
./start-simple.bat
```

### Acceder a SonarQube

- **URL:** <http://localhost:9000>
- **Usuario por defecto:** admin
- **Contraseña por defecto:** admin

> ⚠️ **Importante:** Cambia la contraseña por defecto en el primer acceso.

## 🛠️ Gestión del Servicio

### Detener SonarQube

```bash
./stop-simple.bat
```

### Verificar estado

```bash
./check-simple.bat
```

### Ver logs

```bash
# Todos los servicios
docker-compose -f docker-compose-simple.yml logs -f

# Solo SonarQube
docker-compose -f docker-compose-simple.yml logs -f sonarqube

# Solo PostgreSQL
docker-compose -f docker-compose-simple.yml logs -f db
```

## 📁 Estructura del Proyecto Simple

```text
├── docker-compose-simple.yml  # Configuración simplificada
├── .env-simple              # Variables de entorno básicas
├── start-simple.bat         # Script de inicio
├── stop-simple.bat          # Script de parada
├── check-simple.bat         # Verificación de estado
└── README-SIMPLE.md         # Este archivo
```

## ⚙️ Configuración

### Variables de Entorno (en .env-simple)

- `SONAR_JDBC_USERNAME`: Usuario de la base de datos (sonar)
- `SONAR_JDBC_PASSWORD`: Contraseña de la base de datos
- `SONAR_JDBC_URL`: URL de conexión a PostgreSQL
- `SONARQUBE_PORT`: Puerto para acceder a SonarQube (9000)

### Servicios incluidos

- **SonarQube LTS Community:** Análisis de código
- **PostgreSQL 13:** Base de datos
- **Volúmenes persistentes:** Para datos, extensiones y logs

## 🔧 Comandos útiles

### Reiniciar servicios

```bash
docker-compose -f docker-compose-simple.yml restart
```

### Actualizar SonarQube

```bash
# Detener servicios
docker-compose -f docker-compose-simple.yml down

# Actualizar imágenes
docker-compose -f docker-compose-simple.yml pull

# Iniciar con nuevas imágenes
docker-compose -f docker-compose-simple.yml up -d
```

### Backup de datos

```bash
# Crear backup de PostgreSQL
docker exec postgresql pg_dump -U sonar sonar > backup_sonar.sql

# Restaurar backup
docker exec -i postgresql psql -U sonar sonar < backup_sonar.sql
```

## 📊 Uso de SonarQube

### Configurar un proyecto

1. Accede a <http://localhost:9000>
2. Haz clic en "Create new project"
3. Sigue las instrucciones para configurar tu proyecto
4. Ejecuta el análisis desde tu proyecto usando SonarScanner

### Comando de ejemplo para análisis

```bash
sonar-scanner \
  -Dsonar.projectKey=mi-proyecto \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=tu-token-de-acceso
```

## 🆚 Diferencias con la versión completa

Esta versión simple **NO incluye:**

- ❌ Configuración SSL/HTTPS
- ❌ Nginx como proxy reverso  
- ❌ Certificados Let's Encrypt
- ❌ Configuración para producción/internet

Esta versión simple **SÍ incluye:**

- ✅ SonarQube Community LTS
- ✅ PostgreSQL como base de datos
- ✅ Volúmenes persistentes
- ✅ Scripts de gestión básicos
- ✅ Configuración optimizada para desarrollo local

## 🔄 Migrar a la versión completa

Si más tarde quieres SSL y configuración para producción:

1. Usa `docker-compose.yml` (versión completa)
2. Ejecuta `setup-ssl.bat`
3. Configura tu dominio según `DOMAIN-SETUP.md`

Los datos se mantendrán ya que usan los mismos volúmenes.
