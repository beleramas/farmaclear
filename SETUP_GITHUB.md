# Setup Repositorio GitHub FARMACLEAR

## ✅ Estado Actual

El repositorio local está creado y tiene todos los archivos listos.

## 📋 Pasos para Crear Repositorio en GitHub

### Opción 1: Desde GitHub Web (Recomendado)

1. **Ir a GitHub:** https://github.com/Belera-Capital
2. **Click en "New repository"** (botón verde)
3. **Configurar:**
   - **Repository name:** `FARMACLEAR`
   - **Description:** `Sistema de Clearing Farmacéutico para Chile - Documentación MVP`
   - **Visibility:** Private ✅
   - **NO marcar** "Add a README file" (ya lo tenemos)
   - **NO marcar** "Add .gitignore" (ya lo tenemos)
   - **NO marcar** "Choose a license"
4. **Click "Create repository"**

### Opción 2: Usando GitHub CLI (si está instalado)

```bash
gh repo create Belera-Capital/FARMACLEAR --private --description "Sistema de Clearing Farmacéutico para Chile - Documentación MVP"
```

## 🚀 Después de Crear el Repositorio

Ejecutar estos comandos desde la carpeta `FARMACLEAR`:

```bash
cd C:\Users\manue\FARMACLEAR
git remote add origin https://github.com/Belera-Capital/FARMACLEAR.git
git branch -M main
git push -u origin main
```

## ✅ Verificación

Una vez hecho push, verificar en:
https://github.com/Belera-Capital/FARMACLEAR

---

**Nota:** Si el repositorio ya existe, solo ejecuta los comandos de push.
