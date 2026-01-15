# Ejercicio E: Cambios Render

## Resumen de cambios realizados

### Ejercicio 1-2: Configurar despliegue automático en Render

**Archivos creados:**

#### 1. `.github/workflows/CD_render.yml`
Workflow de GitHub Actions que:
- Se ejecuta automáticamente con cada push a `main`
- Obtiene el RENDER_DEPLOY_HOOK_URL de secrets de GitHub
- Ejecuta curl al webhook para disparar deploy en Render

#### 2. `docker/entrypoints/render_entrypoint.sh`
Script de inicio que ejecuta en cada deploy:
- Migraciones de BD (`migrate --noinput`)
- Recogida de archivos estáticos (`collectstatic --noinput`)
- Creación de superusuario admin (si no existe)
- Inicia gunicorn con 4 workers en puerto dinámico `$PORT`

#### 3. `docker/images/Dockerfile.render`
Dockerfile específico para Render:
- Python 3.10.12-alpine
- Clona repo desde `antonioluisjf22/EGC-2324-1630-antjimde`
- Instala requirements.txt
- Copia entrypoint script
- Usa `local_settings.py` de docker

---

## Archivos modificados/creados

- ✅ `.github/workflows/CD_render.yml` - Workflow para deploy automático
- ✅ `docker/entrypoints/render_entrypoint.sh` - Script de inicio
- ✅ `docker/images/Dockerfile.render` - Dockerfile para Render

---

## Setup del RENDER_DEPLOY_HOOK_URL

**Dónde obtenerlo:**

1. **En Render:**
   - Ir a Dashboard → tu servicio web → Settings → Deploy Hook
   - Copiar la URL del webhook
   
2. **En GitHub (Secrets):**
   - Ir a Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Nombre: `RENDER_DEPLOY_HOOK_URL`
   - Valor: URL copiada desde Render
   - Click "Add secret"

---

## Flujo de despliegue automático

1. **Push a main:**
   ```bash
   git push origin main
   ```

2. **GitHub Actions ejecuta:**
   - Workflow `CD_render.yml` se dispara
   - Extrae el secret `RENDER_DEPLOY_HOOK_URL`
   - Ejecuta curl al webhook

3. **Render detecta el webhook:**
   - Construye imagen usando `Dockerfile.render`
   - Inicia contenedor
   - Script `render_entrypoint.sh` ejecuta:
     - Migraciones
     - Static files
     - Crea superuser admin
     - Levanta gunicorn (4 workers)

4. **Aplicación disponible:**
   - URL: `https://decide-xxx.onrender.com` (Render proporciona)

---

## Variables de entorno en Render

Configurar en Render Dashboard → Environment:

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `DEBUG` | Modo debug | `False` |
| `ALLOWED_HOSTS` | Hosts permitidos | `decide-xxx.onrender.com` |
| `SECRET_KEY` | Clave secreta Django | Generar con `python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"` |
| `DATABASE_URL` | URL de conexión BD | `postgresql://...` (Render lo genera) |

---

## Notas importantes

- **RENDER_DEPLOY_HOOK_URL** es secreto y NO debe exponerse públicamente
- El plan **free** puede hibernar sin tráfico (Render lo reanima al recibir request)
- Cada deploy toma ~2-5 minutos
- Superuser `admin:admin` se crea automáticamente en cada deploy
- Los logs de deploy se ven en Render Dashboard → Logs


