# Guía de Configuración de Dominio para SonarQube SSL

## 📋 Pasos para configurar tu dominio

### 1. 🔍 Obtener información de red

```bash
# Ejecutar para obtener tu IP pública y información de red
./get-network-info.bat
```

### 2. 🌐 Configurar DNS en tu proveedor de dominio

#### Opción A: Subdominio (Recomendado)
Si tienes un dominio como `miempresa.com`, crea un subdominio:

**Configuración DNS:**
- **Nombre/Host:** `sonarqube`
- **Tipo:** `A`
- **Valor/IP:** `[tu-ip-publica]`
- **TTL:** `300` (5 minutos)

**Resultado:** `sonarqube.miempresa.com`

#### Opción B: Dominio principal
Si quieres usar el dominio principal:

**Configuración DNS:**
- **Nombre/Host:** `@` o vacío
- **Tipo:** `A`
- **Valor/IP:** `[tu-ip-publica]`
- **TTL:** `300`

**Resultado:** `miempresa.com`

### 3. 🕐 Esperar propagación DNS

La propagación DNS puede tomar entre 5 minutos y 2 horas. La mayoría de cambios se propagan en 15-30 minutos.

### 4. ✅ Verificar configuración

```bash
# Verificar que el dominio apunte a tu IP
./check-domain.bat
```

### 5. 🔥 Configurar Firewall

#### Windows Firewall

```powershell
# Abrir PowerShell como administrador y ejecutar:

# Permitir puerto 80 (HTTP)
New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Inbound -Protocol TCP -LocalPort 80

# Permitir puerto 443 (HTTPS)
New-NetFirewallRule -DisplayName "Allow HTTPS" -Direction Inbound -Protocol TCP -LocalPort 443

# Permitir puerto 9000 (SonarQube directo - opcional)
New-NetFirewallRule -DisplayName "Allow SonarQube" -Direction Inbound -Protocol TCP -LocalPort 9000
```

#### Router/Módem (Port Forwarding)

Si estás detrás de un router, necesitas configurar port forwarding:

1. Accede a la configuración de tu router (generalmente `192.168.1.1` o `192.168.0.1`)
2. Busca "Port Forwarding" o "Virtual Servers"
3. Crea reglas para:
   - **Puerto externo:** 80 → **Puerto interno:** 80 → **IP local de tu PC**
   - **Puerto externo:** 443 → **Puerto interno:** 443 → **IP local de tu PC**

### 6. 🚀 Ejecutar configuración SSL

Una vez que todo esté configurado:

```bash
./setup-ssl.bat
```

## 🔧 Solución de problemas comunes

### El dominio no resuelve
```bash
# Verificar DNS
nslookup tu-dominio.com

# Verificar desde otro servidor DNS
nslookup tu-dominio.com 8.8.8.8
```

### Error "El dominio no apunta a esta IP"
1. Verifica la configuración DNS en tu proveedor
2. Espera más tiempo para la propagación
3. Usa herramientas online: whatsmydns.net

### Error "Puerto no accesible"
1. Verifica Windows Firewall
2. Verifica port forwarding en el router
3. Contacta a tu ISP si bloquea puertos

### Certificado SSL falla
1. Asegúrate que el puerto 80 esté accesible desde internet
2. Verifica que el dominio resuelva correctamente
3. Revisa los logs: `docker-compose logs certbot`

## 📱 Proveedores de dominio comunes

### GoDaddy
1. Panel de control → Administrar DNS
2. Agregar registro A
3. Host: subdominio, Apunta a: tu-ip

### Cloudflare
1. Panel DNS
2. Add record → Type: A
3. Name: subdominio, IPv4: tu-ip
4. **Importante:** Desactiva el proxy (nube gris) temporalmente

### Namecheap
1. Domain List → Manage
2. Advanced DNS → Add New Record
3. Type: A, Host: subdominio, Value: tu-ip

### Google Domains
1. DNS → Custom records
2. Create new record → A
3. Host name: subdominio, Data: tu-ip

## 🎯 Ejemplo completo

```
Dominio: miempresa.com
IP pública: 203.0.113.100
Configuración DNS:
  - Nombre: sonarqube
  - Tipo: A
  - Valor: 203.0.113.100
  - TTL: 300

Resultado: sonarqube.miempresa.com apunta a 203.0.113.100
```

Firewall:
- Puerto 80: ✅ Abierto
- Puerto 443: ✅ Abierto

SSL: `https://sonarqube.miempresa.com` ✅

## 🇨🇱 Configuración específica para Movistar Chile

Si tu proveedor te asignó la IP `190-20-39-204.baf.movistar.cl`, sigue estos pasos:

### Verificar tu IP de Movistar

```bash
# Verificar que tu equipo use la IP de Movistar
./check-movistar-ip.bat
```

### Configurar dominio con IP de Movistar

```bash
# Asistente para configurar DNS con IP de Movistar
./setup-movistar-domain.bat
```

### Opciones de configuración DNS

#### Opción 1: CNAME (Recomendado)
```
Nombre: sonarqube
Tipo: CNAME
Valor: 190-20-39-204.baf.movistar.cl
TTL: 300
```
**Ventaja:** Si Movistar cambia la IP, se actualiza automáticamente.

#### Opción 2: Registro A
```
Nombre: sonarqube  
Tipo: A
Valor: [IP-numerica-resuelta]
TTL: 300
```
**Nota:** Deberás actualizar manualmente si la IP cambia.

### Consideraciones importantes

- ✅ La IP de Movistar es estática y gratuita
- ✅ Soporta puertos 80 y 443 para SSL
- ⚠️ Asegúrate de tener los puertos abiertos en tu router
- ⚠️ Configura port forwarding si estás detrás de NAT
