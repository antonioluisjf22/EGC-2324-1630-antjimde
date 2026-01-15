# Ejercicio C: Cambios Docker

## Resumen de cambios realizados

### Ejercicio 1-2: Actualizar Dockerfile

**Cambios en `docker/Dockerfile`:**

| Parámetro | Anterior | Actual |
|-----------|----------|--------|
| Python | `3.9-alpine` | `3.10.12-alpine` |
| Repositorio | `decide-update-4-1/decide-update-4.1.git` | `antonioluisjf22/EGC-2324-1630-antjimde.git` |
| collectstatic | Sin flag | `--noinput` (no pide confirmación) |

**Razón:** Desplegar el repositorio actual con Python 3.10 compatible.

---

### Ejercicio 3-4: Configurar 4 workers de Gunicorn

**Cambio en `docker/docker-compose.yml`:**

```yaml
# ANTES
command: ash -c "python manage.py migrate && gunicorn -w 5 decide.wsgi --timeout=500 -b 0.0.0.0:5000"

# DESPUÉS
command: ash -c "python manage.py migrate && gunicorn -w 4 decide.wsgi --timeout=500 -b 0.0.0.0:5000"
```

**Razón:** Reducir carga de CPU con 4 workers (suficiente para desarrollo/pruebas).

---

## Verificar funcionamiento en navegador

### Pasos para levantar Docker:

```bash
# Desde la raíz del proyecto
cd /home/anton/examenes_egc/EGC-2324-1630-antjimde/docker

# Construir e iniciar los servicios
docker compose up --build
```

### Verificar en navegador:

1. **Acceder a admin:**
   - URL: `https://localhost:8000/admin`
   - Usuario: `admin`
   - Contraseña: `admin`

2. **Crear superusuario (si no existe):**
   ```bash
   docker exec -it decide_web ash
   cd /app/decide
   python manage.py shell
   ```
   
   Dentro del shell:
   ```python
   from django.contrib.auth.models import User
   User.objects.create_superuser('admin', 'admin@example.com', 'admin')
   print("Admin creado!")
   exit()
   ```

3. **Verificar que funciona:**
   - Debería ver el panel de administración de Django
   - Si aparece, Docker está desplegado correctamente ✅

4. **Logs de workers:**
   ```bash
   docker logs decide_web
   ```
   Debería ver: `Spawning worker with pid: ...` (4 veces para 4 workers)

### Detener Docker:

```bash
docker compose down -v 
```
-v para borrar volúmenes

---

## Checklist de verificación

- ✅ Dockerfile apunta al repo actual (antonioluisjf22)
- ✅ Python 3.10.12 en Dockerfile
- ✅ Gunicorn configurado con 4 workers
- ✅ docker-compose.yml actualizado
- ✅ Admin accesible en `https://localhost:8000/admin`

## Crear de un superuser manual en el contenedor
docker exec -it decide_web ash
cd /app/decide
python manage.py createsuperuserd
