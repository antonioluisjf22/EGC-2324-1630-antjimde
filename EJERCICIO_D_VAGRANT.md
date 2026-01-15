# Ejercicio D: Cambios Vagrant

## Resumen de cambios realizados

### Ejercicio 1-2: Actualizar python.yml para repo actual

**Cambios en `vagrant/python.yml`:**

| Parámetro | Anterior | Actual |
|-----------|----------|--------|
| Repositorio | `wadobo/decide.git` | `antonioluisjf22/EGC-2324-1630-antjimde.git` |
| Rama | `master` | `main` |

**Razón:** Desplegar el repositorio actual con la rama principal.

---

### Ejercicio 3-4: Cambiar puerto a 8081

**Cambio en `vagrant/Vagrantfile`:**

```ruby
# ANTES
config.vm.network "forwarded_port", guest: 80, host: 8080

# DESPUÉS
config.vm.network "forwarded_port", guest: 80, host: 8081
```

**Razón:** Redirigir el puerto 80 de la máquina virtual al puerto 8081 del host para acceso desde el navegador.

---

## Archivos modificados

- ✅ `vagrant/python.yml` - URL del repo y rama actualizada
- ✅ `vagrant/Vagrantfile` - Puerto forwarded cambiado a 8081
