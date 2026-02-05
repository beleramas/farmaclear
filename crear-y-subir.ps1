# Script para crear repositorio GitHub y subir código
# Ejecutar desde PowerShell: .\crear-y-subir.ps1

Write-Host "`n=== Crear Repositorio GitHub FARMACLEAR ===" -ForegroundColor Cyan
Write-Host ""

# Verificar si GitHub CLI está instalado
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue

if ($ghInstalled) {
    Write-Host "GitHub CLI encontrado. Creando repositorio..." -ForegroundColor Green
    
    # Crear repositorio con GitHub CLI
    gh repo create Belera-Capital/FARMACLEAR `
        --private `
        --description "Sistema de Clearing Farmacéutico para Chile - Documentación MVP" `
        --source=. `
        --remote=origin `
        --push
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ Repositorio creado y código subido exitosamente!" -ForegroundColor Green
        Write-Host "URL: https://github.com/Belera-Capital/FARMACLEAR" -ForegroundColor Cyan
        exit 0
    }
}

# Si GitHub CLI no está disponible, intentar con API
Write-Host "GitHub CLI no disponible. Intentando con API..." -ForegroundColor Yellow

# Solicitar token de GitHub
Write-Host "`nNecesitas un Personal Access Token de GitHub:" -ForegroundColor Yellow
Write-Host "1. Ve a: https://github.com/settings/tokens" -ForegroundColor Cyan
Write-Host "2. Click 'Generate new token (classic)'" -ForegroundColor Cyan
Write-Host "3. Selecciona scope: 'repo' (todos los permisos)" -ForegroundColor Cyan
Write-Host "4. Copia el token generado" -ForegroundColor Cyan
Write-Host ""

$token = Read-Host "Pega tu GitHub Personal Access Token aquí"

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "`n❌ Token no proporcionado. Saliendo..." -ForegroundColor Red
    Write-Host "`nAlternativa: Crea el repositorio manualmente en:" -ForegroundColor Yellow
    Write-Host "https://github.com/organizations/Belera-Capital/repositories/new" -ForegroundColor Cyan
    Write-Host "Luego ejecuta: git push -u origin main" -ForegroundColor Cyan
    exit 1
}

# Crear repositorio con API
$headers = @{
    'Accept' = 'application/vnd.github.v3+json'
    'Authorization' = "token $token"
}

$body = @{
    name = 'FARMACLEAR'
    description = 'Sistema de Clearing Farmacéutico para Chile - Documentación MVP'
    private = $true
} | ConvertTo-Json

try {
    Write-Host "`nCreando repositorio..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri 'https://api.github.com/orgs/Belera-Capital/repos' `
        -Method Post `
        -Headers $headers `
        -Body $body `
        -ContentType 'application/json'
    
    Write-Host "✅ Repositorio creado exitosamente!" -ForegroundColor Green
    Write-Host "URL: $($response.html_url)" -ForegroundColor Cyan
    
    # Configurar remote y push
    Write-Host "`nConfigurando remote y subiendo código..." -ForegroundColor Yellow
    
    git remote remove origin 2>$null
    git remote add origin https://github.com/Belera-Capital/FARMACLEAR.git
    git branch -M main
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ Código subido exitosamente!" -ForegroundColor Green
        Write-Host "Repositorio disponible en: https://github.com/Belera-Capital/FARMACLEAR" -ForegroundColor Cyan
    }
    
} catch {
    Write-Host "`n❌ Error al crear repositorio:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "`nToken inválido o sin permisos suficientes." -ForegroundColor Yellow
    } elseif ($_.Exception.Response.StatusCode -eq 422) {
        Write-Host "`nEl repositorio ya existe o hay un problema con el nombre." -ForegroundColor Yellow
        Write-Host "Intenta hacer push directamente:" -ForegroundColor Cyan
        Write-Host "git push -u origin main" -ForegroundColor Cyan
    }
    
    Write-Host "`nAlternativa: Crea el repositorio manualmente en:" -ForegroundColor Yellow
    Write-Host "https://github.com/organizations/Belera-Capital/repositories/new" -ForegroundColor Cyan
    Write-Host "Luego ejecuta: git push -u origin main" -ForegroundColor Cyan
}
