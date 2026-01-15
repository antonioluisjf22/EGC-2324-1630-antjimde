# Ejercicios 5-10: Workflows y Releases

## Ejercicio 5: Configurar Django.yml con múltiples versiones de Python

**Objetivo:** Lanzar pruebas con Python 3.10.12 y 3.11

**Solución: Usar `strategy.matrix`**

```yaml
jobs:
  build:
    runs-on: ubuntu-22.04
    strategy:
      matrix:
        python-version: ['3.10.12', '3.11']
    steps:
    - uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    # resto de pasos...
```

**Ventajas vs 2 jobs separados:**
- Menos código (DRY principle)
- Los pasos se repiten automáticamente para cada versión
- Es el patrón recomendado en GitHub Actions
- Aparece como "2 runs" en la UI

**Resultado:** Cada push ejecuta 2 builds en paralelo (3.10.12 y 3.11)

---

## Ejercicio 6: Commit y push

```bash
git add .github/workflows/django.yml
git commit -m "feat: add python 3.11 test matrix"
git push origin main
```

---

## Ejercicio 7: Verificar funcionamiento

1. Ir a GitHub → **Actions**
2. Ver el último workflow "Django Tests"
3. Debería mostrar **2 runs** (uno por cada versión de Python)
4. Ambos deben completarse ✅

---

## Ejercicio 8: Configurar releases automáticas

**Crear `.github/workflows/release.yml`:**

```yaml
name: Create Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-22.04
    steps:
    - uses: actions/checkout@v3
    
    - name: Create Release
      uses: actions/create-release@v1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        tag_name: ${{ github.ref }}
        release_name: Release ${{ github.ref }}
        body: |
          Changes in this Release:
          - Automated release created from GitHub Actions
        draft: false
        prerelease: false
```

**Explicación:**
- Trigger: `on.push.tags` con patrón `v*` (v1.0.0, v2.1.0, etc.)
- Crea automáticamente una release en GitHub con el tag como versión
- Usa `GITHUB_TOKEN` (token automático de GitHub Actions)

---

## Ejercicio 9: Commit y push

```bash
git add .github/workflows/release.yml
git commit -m "feat: add automatic release workflow"
git push origin main
```

---

## Ejercicio 10: Verificar que se crea una release

**Pasos:**

1. **Crear un tag local:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Verificar en GitHub:**
   - Ir a **Releases** (o Actions → última ejecución)
   - Debería aparecer "Release v1.0.0" creada automáticamente ✅

3. **Comprobar el workflow:**
   - En Actions verá la ejecución de "Create Release"
   - El tag disparó el workflow automáticamente

---

## Resumen

| Ejercicio | Acción | Archivo |
|-----------|--------|---------|
| 5-7 | Matrix tests 3.10.12 + 3.11 | `.github/workflows/django.yml` |
| 8-10 | Releases automáticas por tags | `.github/workflows/release.yml` |

**Próximo paso:** Cada vez que hagas `git tag v1.x.x && git push --tags`, se creará automáticamente una release.
