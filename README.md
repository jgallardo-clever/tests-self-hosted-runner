# Tests Self-Hosted Runner

Este proyecto contiene la configuración de SonarQube usando Docker Compose para análisis de código estático.

## 🚀 Inicio Rápido

### Prerrequisitos

- Docker Desktop instalado y ejecutándose
- Docker Compose (incluido con Docker Desktop)
- **Para SSL/HTTPS:** Dominio apuntando a tu servidor IP pública
- **Para SSL/HTTPS:** Puertos 80 y 443 abiertos en el firewall

### Iniciar SonarQube

#### Opción 1: Con SSL/HTTPS (Recomendado para producción)

**⚠️ Prerequisitos para SSL:**
1. **Dominio apuntando a tu IP pública**
2. **Puertos 80 y 443 abiertos en firewall**

**Para usuarios de Movistar Chile con IP asignada:**
```bash
# Configuración automática para IP de Movistar
./auto-setup-movistar.bat
```

**Para otros proveedores:**
```bash
# Paso 1: Obtener información de red
./get-network-info.bat

# Paso 2: Verificar configuración DNS
./check-domain.bat

# Paso 3: Configurar SSL automáticamente
./setup-ssl.bat
```

> 📖 **Guía detallada:** Lee `DOMAIN-SETUP.md` para instrucciones completas de configuración DNS.

#### Opción 2: Script automático (Solo HTTP)

```bash
# Ejecutar el script de inicio
./start-sonarqube.bat
```

#### Opción 3: Comandos manuales

```bash
# Iniciar los contenedores
docker-compose up -d

# Ver los logs
docker-compose logs -f
```

### Acceder a SonarQube

#### Con SSL configurado:
- **URL:** <https://tu-dominio.com>
- **Usuario por defecto:** admin
- **Contraseña por defecto:** admin

#### Sin SSL (desarrollo):
- **URL:** <http://localhost:9000>
- **Usuario por defecto:** admin
- **Contraseña por defecto:** admin

> ⚠️ **Importante:** Cambia la contraseña por defecto en el primer acceso.

## 🛠️ Gestión del Servicio

### Detener SonarQube

```bash
# Opción 1: Script automático
./stop-sonarqube.bat

# Opción 2: Comando manual
docker-compose down
```

### Eliminar datos (reinicio completo)

```bash
docker-compose down -v
```

### Ver logs

```bash
# Todos los servicios
docker-compose logs -f

# Solo SonarQube
docker-compose logs -f sonarqube

# Solo PostgreSQL
docker-compose logs -f db
```

## 📁 Estructura del Proyecto

```text
├── docker-compose.yml      # Configuración de Docker Compose
├── .env                   # Variables de entorno
├── start-sonarqube.bat    # Script de inicio para Windows
├── stop-sonarqube.bat     # Script de parada para Windows
├── sonarqube/
│   └── sonar.properties   # Configuración personalizada de SonarQube
└── README.md             # Este archivo
```

## ⚙️ Configuración

### Variables de Entorno

Las variables de configuración están en el archivo `.env`:

- `SONAR_JDBC_USERNAME`: Usuario de la base de datos
- `SONAR_JDBC_PASSWORD`: Contraseña de la base de datos
- `SONAR_JDBC_URL`: URL de conexión a PostgreSQL
- `SONARQUBE_PORT`: Puerto para acceder a SonarQube (por defecto 9000)

### Personalización

- Modifica `sonarqube/sonar.properties` para configuraciones específicas
- Ajusta las variables en `.env` según tus necesidades
- El archivo `docker-compose.yml` contiene la configuración de los servicios

## 🔧 Solución de Problemas

### SonarQube no inicia

1. Verifica que Docker esté ejecutándose
2. Asegúrate de que el puerto 9000 esté disponible
3. Revisa los logs: `docker-compose logs sonarqube`

### Error de conexión a la base de datos

1. Verifica que PostgreSQL esté ejecutándose: `docker-compose logs db`
2. Confirma las credenciales en el archivo `.env`

### Resetear configuración

```bash
# Detener servicios y eliminar datos
docker-compose down -v

# Volver a iniciar
docker-compose up -d
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

## 🔒 Configuración SSL/HTTPS

### Para entornos de producción expuestos a internet

Si tu SonarQube está expuesto a internet, es **crucial** configurar SSL/HTTPS para la seguridad.

#### Configuración automática con Let's Encrypt

```bash
# Ejecutar el script de configuración SSL
./setup-ssl.bat
```

Este script:
1. Te pedirá tu dominio y email
2. Configurará automáticamente Nginx como proxy reverso
3. Obtendrá certificados SSL gratuitos de Let's Encrypt
4. Configurará redirección automática HTTP → HTTPS

#### Renovación de certificados

Los certificados de Let's Encrypt se renuevan automáticamente cada 90 días:

```bash
# Renovar manualmente si es necesario
./renew-ssl.bat
```

#### Verificar configuración SSL

```bash
# Verificar estado SSL
./check-ssl.bat
```

### Configuración manual de SSL

Si prefieres usar tus propios certificados:

1. Coloca tus certificados en `nginx/ssl/`
2. Modifica `nginx/nginx.conf` para apuntar a tus certificados
3. Reinicia el contenedor: `docker-compose restart nginx`