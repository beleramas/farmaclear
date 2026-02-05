# Farmaclear - Índice de Documentación MVP
## Documentación para Cotización con Software Factory

**Proyecto:** Sistema de Clearing Farmacéutico para Chile  
**Cliente:** Farmaclear  
**Fecha:** Enero 2026  
**Versión:** 1.0

---

## 📋 Documentos Disponibles

### 1. [FARMACLEAR_MVP_PLANNING.md](./FARMACLEAR_MVP_PLANNING.md)
**Documento Principal de Planificación**

Contiene:
- Visión general del producto
- Arquitectura del sistema completa
- Flujos de datos y transacciones
- Modelo de datos
- APIs y contratos
- Seguridad y compliance
- Plan de desarrollo por fases
- Stack tecnológico
- Métricas de éxito
- Riesgos y mitigaciones

**Uso:** Documento de referencia completo para entender el proyecto en su totalidad.

---

### 2. [FARMACLEAR_DIAGRAMS.md](./FARMACLEAR_DIAGRAMS.md)
**Diagramas Técnicos Detallados**

Contiene:
- Diagrama de arquitectura de alto nivel
- Diagrama de actores e interacciones
- Flujo detallado de transacción GES
- Arquitectura de blockchain BFT
- Modelo de datos simplificado
- Flujo de conciliación detallado
- Arquitectura de seguridad
- Flujo de liquidación mensual
- Diagrama de deployment
- Flujo de notificaciones

**Uso:** Diagramas visuales para presentaciones y comprensión técnica rápida.

---

### 3. [FARMACLEAR_TECHNICAL_SPEC.md](./FARMACLEAR_TECHNICAL_SPEC.md)
**Especificación Técnica MVP Fase 1**

Contiene:
- Alcance del proyecto (dentro/fuera)
- Requisitos funcionales detallados (RF-001 a RF-012)
- Requisitos no funcionales
- Stack tecnológico específico
- Estructura de proyecto
- Modelo de datos (esquema SQL)
- APIs específicas con interfaces TypeScript
- Plan de desarrollo por fases
- Criterios de aceptación

**Uso:** Documento técnico detallado para desarrollo. Base para cotización.

---

### 4. [FARMACLEAR_TIMELINE.md](./FARMACLEAR_TIMELINE.md)
**Timeline y Entregables MVP Fase 1**

Contiene:
- Timeline general (10 semanas)
- Detalle por fase con entregables específicos
- Hitos por fase
- Criterios de aceptación por fase
- Riesgos y mitigaciones
- Estructura de comunicación
- Recursos necesarios
- Próximos pasos post-MVP

**Uso:** Planificación temporal detallada para estimación de esfuerzo y costos.

---

## 🎯 Resumen Ejecutivo

### Objetivo del MVP
Desarrollar un sistema de clearing farmacéutico que permita:
- ✅ Validar transacciones GES
- 🔄 Conciliar descuentos entre actores
- 📅 Liquidar pagos de forma estandarizada
- ☑ Auditar y trazar todas las transacciones

### Actores del Sistema
1. **Cadenas de Farmacias** (FASA, Cruz Verde, Salcobrand, Simi)
2. **Farmacias Independientes**
3. **Laboratorios Farmacéuticos**
4. **Isapres** (Instituciones de Salud Previsional)
5. **Fonasa** (Fondo Nacional de Salud)
6. **Farmaclear** (Plataforma - Operador Neutral)

### Tecnologías Principales
- **Backend:** Node.js + TypeScript + Express/NestJS
- **Frontend:** React + TypeScript + shadcn/ui
- **Base de Datos:** PostgreSQL + Redis
- **Blockchain:** Hyperledger Fabric / Cosmos SDK (BFT 3 nodos)
- **Infraestructura:** Docker + Kubernetes

### Timeline MVP Fase 1
- **Duración:** 10 semanas
- **Inicio propuesto:** Febrero 2026
- **Fin estimado:** Abril 2026

### Fases
1. **Semanas 1-2:** Setup y Arquitectura Base
2. **Semanas 3-5:** Backend Core
3. **Semanas 6-7:** Frontend
4. **Semana 8:** Integración y Testing
5. **Semanas 9-10:** Documentación y Deployment

---

## 📊 Estructura del Proyecto

```
farmaclear-platform/
├── backend/
│   ├── api/              # APIs REST
│   ├── services/         # Servicios de negocio
│   ├── blockchain/       # Integración blockchain
│   └── database/         # Migraciones y seeds
├── frontend/
│   ├── src/
│   │   ├── components/  # Componentes React
│   │   ├── pages/        # Dashboards
│   │   └── services/     # API clients
├── infrastructure/       # Docker, K8s, scripts
└── docs/                 # Documentación
```

---

## 🔑 Puntos Clave para Cotización

### Alcance MVP Fase 1
**Incluye:**
- ✅ APIs REST completas
- ✅ Validación de transacciones GES (hard-coded)
- ✅ Conciliación automática (simulada)
- ✅ Dashboards por actor
- ✅ Integración blockchain básica
- ✅ Sistema de notificaciones básico

**No incluye:**
- ❌ Integración con sistemas externos reales
- ❌ Procesamiento de pagos bancarios
- ❌ Reportes avanzados
- ❌ Mobile apps

### Requisitos Técnicos
- **Performance:** < 200ms respuesta API (p95)
- **Disponibilidad:** 99% (MVP)
- **Seguridad:** TLS 1.3, AES-256, OAuth 2.0
- **Testing:** >70% cobertura unitaria

### Entregables Finales
- ✅ Código completo en repositorio Git
- ✅ Documentación técnica completa
- ✅ Documentación de API (Swagger)
- ✅ Tests unitarios e integración
- ✅ Sistema desplegado en producción
- ✅ Handover técnico

---

## 📞 Contacto

**Equipo Farmaclear:**
- **Manuel Astaburuaga** - Tecnología (Tech Lead)
- **Victor Pucci** - Estrategia Negocio (Product Owner)
- **Daniel Horán** - Advisor Industria Farma

---

## 📝 Notas para Software Factory

1. **Revisar todos los documentos** antes de preparar cotización
2. **Priorizar comprensión** de arquitectura y flujos
3. **Clarificar dudas** antes de cotizar
4. **Incluir en cotización:**
   - Horas por fase
   - Recursos necesarios
   - Timeline detallado
   - Riesgos identificados
   - Opciones de stack tecnológico

5. **Considerar:**
   - Complejidad de integración blockchain
   - Necesidad de expertise en sistemas financieros
   - Requisitos de seguridad y compliance
   - Escalabilidad futura

---

## 🚀 Próximos Pasos

1. **Revisión de documentación** por Software Factory
2. **Reunión de clarificación** de dudas técnicas
3. **Preparación de cotización** detallada
4. **Revisión y negociación** de términos
5. **Firma de contrato** y kick-off

---

**Documento preparado por:** Manuel Astaburuaga  
**Fecha:** Enero 2026  
**Versión:** 1.0
