# Farmaclear - Planificación MVP
## Sistema de Clearing Farmacéutico para Chile

**Versión:** 1.0  
**Fecha:** Enero 2026  
**Objetivo:** Documento de planificación para cotización con Software Factory

---

## 1. Visión General del Producto

### 1.1 Propósito
Farmaclear es una plataforma de clearing farmacéutico que actúa como capa neutral para:
- ✅ Validar prestaciones (GES y no GES)
- 🔄 Conciliar descuentos entre actores
- 📅 Liquidar pagos de forma estandarizada
- ☑ Auditar y trazar todas las transacciones

### 1.2 Actores del Sistema
1. **Cadenas de Farmacias** (FASA, Cruz Verde, Salcobrand, Simi)
2. **Farmacias Independientes**
3. **Laboratorios Farmacéuticos**
4. **Isapres** (Instituciones de Salud Previsional)
5. **Fonasa** (Fondo Nacional de Salud)
6. **Clínicas e Instituciones Privadas**
7. **Farmaclear** (Plataforma de Clearing - Operador Neutral)

### 1.3 Modelo de Negocio MVP
- **Entrada:** Modelo tipo Presefar (comercial, menor fricción regulatoria)
- **Evolución:** Hacia modelo tipo Farmalink (institucional)
- **Ingresos:** % sobre descuentos gestionados (ej: 1.2% del descuento GES)

---

## 2. Arquitectura del Sistema

### 2.1 Arquitectura General

```
┌─────────────────────────────────────────────────────────────────┐
│                    FARMACLEAR PLATFORM                           │
│              (Capa Neutral de Clearing)                          │
└─────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
┌───────▼────────┐   ┌────────▼────────┐   ┌───────▼────────┐
│   API Gateway  │   │  Core Engine    │   │  Blockchain    │
│   (REST/GraphQL│   │  (Business Logic)│   │  (BFT - 3 nodos)│
└───────┬────────┘   └────────┬────────┘   └───────┬────────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
┌───────▼────────┐   ┌────────▼────────┐   ┌───────▼────────┐
│  Validation    │   │ Reconciliation  │   │  Settlement   │
│  Service       │   │  Service        │   │  Service       │
└────────────────┘   └─────────────────┘   └───────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
┌───────▼────────┐   ┌────────▼────────┐   ┌───────▼────────┐
│  Audit &       │   │  Notification   │   │  Reporting     │
│  Traceability  │   │  Service        │   │  Service       │
└────────────────┘   └─────────────────┘   └────────────────┘
                              │
                    ┌─────────▼─────────┐
                    │   Data Layer      │
                    │  (PostgreSQL +    │
                    │   Redis Cache)    │
                    └───────────────────┘
```

### 2.2 Componentes Principales

#### 2.2.1 API Gateway
- **Función:** Punto de entrada único para todos los actores
- **Tecnología:** Kong / AWS API Gateway / NGINX
- **Características:**
  - Autenticación y autorización (OAuth 2.0 / JWT)
  - Rate limiting por actor
  - Logging y monitoreo
  - Versionado de APIs

#### 2.2.2 Core Engine (Motor de Negocio)
- **Función:** Lógica de negocio central
- **Tecnología:** Node.js / Python / Java
- **Módulos:**
  - Gestión de reglas de negocio
  - Procesamiento de transacciones
  - Orquestación de servicios

#### 2.2.3 Blockchain Layer (BFT)
- **Función:** Trazabilidad inmutable y consenso distribuido
- **Tecnología:** Hyperledger Fabric / Cosmos SDK / Custom BFT
- **Características:**
  - 3 nodos Byzantine Fault Tolerant
  - Smart contracts para reglas de negocio
  - Inmutabilidad de transacciones
  - Auditoría transparente

#### 2.2.4 Servicios Especializados

**Validation Service:**
- Validación de prestaciones GES
- Validación de prestaciones no GES
- Verificación de elegibilidad
- Validación de montos y descuentos

**Reconciliation Service:**
- Conciliación automática de descuentos
- Matching de transacciones
- Detección de discrepancias
- Generación de reportes de conciliación

**Settlement Service:**
- Cálculo de liquidaciones
- Generación de notas de crédito
- Programación de pagos
- Integración con sistemas bancarios

**Audit & Traceability Service:**
- Registro inmutable de todas las operaciones
- Trazabilidad completa de transacciones
- Generación de evidencias auditables
- Reportes de compliance

**Notification Service:**
- Notificaciones en tiempo real
- Alertas de discrepancias
- Notificaciones de liquidaciones
- Comunicación multi-canal (email, SMS, API)

**Reporting Service:**
- Dashboards por actor
- Reportes de transacciones
- Reportes de conciliación
- Reportes regulatorios

---

## 3. Flujo de Datos y Transacciones

### 3.1 Flujo Principal: Transacción GES

```
┌─────────────┐
│  FARMACIA   │
│  (Punto de  │
│   Venta)    │
└──────┬──────┘
       │
       │ 1. Venta con descuento GES
       │    POST /api/v1/transactions
       │    {
       │      "tipo": "GES",
       │      "prestacion": {...},
       │      "descuento": {...},
       │      "paciente": {...}
       │    }
       ▼
┌─────────────────────────────────────┐
│      FARMACLEAR API GATEWAY         │
│  - Autenticación                    │
│  - Validación de entrada            │
│  - Rate limiting                    │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│      VALIDATION SERVICE             │
│  - Validar prestación GES           │
│  - Verificar elegibilidad paciente  │
│  - Validar monto descuento          │
│  - Verificar cobertura Isapre/Fonasa│
└──────────────┬──────────────────────┘
               │
               ├───► Validación OK
               │
               ▼
┌─────────────────────────────────────┐
│      BLOCKCHAIN LAYER (BFT)         │
│  - Registrar transacción            │
│  - Generar hash inmutable           │
│  - Consenso entre 3 nodos           │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│      RECONCILIATION SERVICE         │
│  - Buscar transacción correspondiente│
│  - Matching con registro Isapre/Fonasa│
│  - Detectar discrepancias           │
└──────────────┬──────────────────────┘
               │
               ├───► Conciliación OK
               │
               ▼
┌─────────────────────────────────────┐
│      SETTLEMENT SERVICE             │
│  - Calcular liquidación             │
│  - Generar nota de crédito          │
│  - Programar pago a laboratorio     │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│      NOTIFICATION SERVICE           │
│  - Notificar a Farmacia             │
│  - Notificar a Isapre/Fonasa        │
│  - Notificar a Laboratorio          │
└─────────────────────────────────────┘
```

### 3.2 Flujo de Conciliación

```
┌──────────────┐         ┌──────────────┐
│   FARMACIA   │         │   ISAPRE/    │
│              │         │   FONASA     │
└──────┬───────┘         └──────┬───────┘
       │                         │
       │ Registro de venta       │ Registro de pago
       │ con descuento           │ de descuento
       │                         │
       ▼                         ▼
┌─────────────────────────────────────────────┐
│         FARMACLEAR PLATFORM                │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │  RECONCILIATION ENGINE              │  │
│  │                                      │  │
│  │  1. Matching por:                   │  │
│  │     - RUT Paciente                  │  │
│  │     - Código Prestación             │  │
│  │     - Fecha                         │  │
│  │     - Monto                         │  │
│  │                                      │  │
│  │  2. Detectar discrepancias:         │  │
│  │     - Montos diferentes              │  │
│  │     - Fechas fuera de rango         │  │
│  │     - Prestaciones no encontradas   │  │
│  │                                      │  │
│  │  3. Generar reporte:                │  │
│  │     - Transacciones conciliadas     │  │
│  │     - Discrepancias detectadas      │  │
│  │     - Pendientes de conciliar       │  │
│  └──────────────────────────────────────┘  │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │  BLOCKCHAIN (Registro Inmutable)     │  │
│  │  - Hash de cada transacción         │  │
│  │  - Timestamp                         │  │
│  │  - Estado de conciliación           │  │
│  └──────────────────────────────────────┘  │
└─────────────────────────────────────────────┘
```

### 3.3 Flujo de Liquidación

```
┌─────────────────────────────────────────────┐
│      SETTLEMENT ENGINE                     │
│                                            │
│  1. Agrupar transacciones conciliadas     │
│     por período (diario/semanal/mensual)   │
│                                            │
│  2. Calcular montos a liquidar:            │
│     - Total descuentos GES                │
│     - Comisiones Farmaclear                │
│     - Montos a pagar a Laboratorios       │
│                                            │
│  3. Generar documentos:                    │
│     - Notas de crédito                     │
│     - Estados de cuenta                    │
│     - Órdenes de pago                      │
│                                            │
│  4. Validar con Blockchain                 │
│                                            │
│  5. Enviar a sistemas bancarios            │
│                                            │
│  6. Notificar a todos los actores          │
└─────────────────────────────────────────────┘
```

---

## 4. Modelo de Datos

### 4.1 Entidades Principales

```sql
-- Transacciones
CREATE TABLE transactions (
    id UUID PRIMARY KEY,
    transaction_hash VARCHAR(64) UNIQUE, -- Hash blockchain
    farmacia_id UUID NOT NULL,
    tipo_prestacion VARCHAR(50), -- GES, NO_GES
    codigo_prestacion VARCHAR(50),
    paciente_rut VARCHAR(12),
    monto_total DECIMAL(15,2),
    monto_descuento DECIMAL(15,2),
    fecha_transaccion TIMESTAMP,
    estado VARCHAR(50), -- PENDIENTE, VALIDADA, CONCILIADA, LIQUIDADA
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Conciliaciones
CREATE TABLE reconciliations (
    id UUID PRIMARY KEY,
    transaction_id UUID REFERENCES transactions(id),
    isapre_fonasa_id UUID,
    registro_isapre_fonasa_id UUID,
    estado VARCHAR(50), -- PENDIENTE, CONCILIADA, DISCREPANCIA
    monto_farmacia DECIMAL(15,2),
    monto_isapre_fonasa DECIMAL(15,2),
    diferencia DECIMAL(15,2),
    motivo_discrepancia TEXT,
    fecha_conciliacion TIMESTAMP,
    created_at TIMESTAMP
);

-- Liquidaciones
CREATE TABLE settlements (
    id UUID PRIMARY KEY,
    periodo_inicio DATE,
    periodo_fin DATE,
    farmacia_id UUID,
    laboratorio_id UUID,
    total_descuentos DECIMAL(15,2),
    comision_farmaclear DECIMAL(15,2),
    monto_a_pagar DECIMAL(15,2),
    nota_credito_id UUID,
    estado VARCHAR(50), -- PENDIENTE, GENERADA, PAGADA
    fecha_liquidacion TIMESTAMP,
    created_at TIMESTAMP
);

-- Notas de Crédito
CREATE TABLE credit_notes (
    id UUID PRIMARY KEY,
    settlement_id UUID REFERENCES settlements(id),
    numero_nota VARCHAR(50) UNIQUE,
    monto DECIMAL(15,2),
    estado VARCHAR(50), -- PENDIENTE, VALIDADA, APROBADA, RECHAZADA
    motivo TEXT,
    fecha_emision DATE,
    fecha_vencimiento DATE,
    created_at TIMESTAMP
);

-- Actores del Sistema
CREATE TABLE actors (
    id UUID PRIMARY KEY,
    tipo VARCHAR(50), -- FARMACIA, LABORATORIO, ISAPRE, FONASA
    nombre VARCHAR(255),
    rut VARCHAR(12) UNIQUE,
    api_key VARCHAR(255),
    webhook_url VARCHAR(500),
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP
);

-- Reglas de Negocio
CREATE TABLE business_rules (
    id UUID PRIMARY KEY,
    tipo_prestacion VARCHAR(50),
    codigo_prestacion VARCHAR(50),
    descuento_porcentaje DECIMAL(5,2),
    descuento_monto_fijo DECIMAL(15,2),
    vigencia_desde DATE,
    vigencia_hasta DATE,
    activo BOOLEAN DEFAULT true
);

-- Auditoría (Blockchain)
CREATE TABLE audit_log (
    id UUID PRIMARY KEY,
    transaction_hash VARCHAR(64),
    actor_id UUID,
    accion VARCHAR(100),
    datos_anteriores JSONB,
    datos_nuevos JSONB,
    timestamp TIMESTAMP,
    blockchain_block_number BIGINT
);
```

---

## 5. APIs y Contratos

### 5.1 Endpoints Principales

#### 5.1.1 API para Farmacias

```yaml
POST /api/v1/transactions
  Descripción: Registrar nueva transacción con descuento
  Request Body:
    {
      "tipo_prestacion": "GES",
      "codigo_prestacion": "GES-001",
      "paciente_rut": "12345678-9",
      "monto_total": 10000,
      "monto_descuento": 2000,
      "fecha_transaccion": "2026-01-21T10:30:00Z"
    }
  Response:
    {
      "transaction_id": "uuid",
      "transaction_hash": "blockchain-hash",
      "estado": "VALIDADA",
      "mensaje": "Transacción registrada exitosamente"
    }

GET /api/v1/transactions/{transaction_id}
  Descripción: Consultar estado de transacción
  Response:
    {
      "transaction_id": "uuid",
      "estado": "CONCILIADA",
      "reconciliation_id": "uuid",
      "settlement_id": "uuid"
    }

GET /api/v1/reconciliations
  Descripción: Listar conciliaciones de la farmacia
  Query Params:
    - fecha_desde
    - fecha_hasta
    - estado
  Response:
    {
      "reconciliations": [...],
      "total": 100,
      "conciliadas": 95,
      "discrepancias": 5
    }
```

#### 5.1.2 API para Isapres/Fonasa

```yaml
POST /api/v1/isapre-fonasa/registros
  Descripción: Registrar pago de descuento GES
  Request Body:
    {
      "paciente_rut": "12345678-9",
      "codigo_prestacion": "GES-001",
      "monto_descuento": 2000,
      "fecha_pago": "2026-01-21T10:30:00Z"
    }

GET /api/v1/isapre-fonasa/reconciliations
  Descripción: Consultar conciliaciones pendientes
```

#### 5.1.3 API para Laboratorios

```yaml
GET /api/v1/laboratorios/settlements
  Descripción: Consultar liquidaciones pendientes
  Response:
    {
      "settlements": [
        {
          "id": "uuid",
          "periodo": "2026-01",
          "total_descuentos": 1000000,
          "comision_farmaclear": 12000,
          "monto_a_pagar": 988000,
          "nota_credito_id": "uuid"
        }
      ]
    }

POST /api/v1/laboratorios/credit-notes/{id}/validate
  Descripción: Validar nota de crédito
  Request Body:
    {
      "accion": "APROBAR" | "RECHAZAR",
      "motivo": "string"
    }
```

### 5.2 Webhooks

```yaml
POST /webhooks/transaction-validated
  Descripción: Notificar cuando transacción es validada
  Payload:
    {
      "transaction_id": "uuid",
      "estado": "VALIDADA",
      "timestamp": "2026-01-21T10:30:00Z"
    }

POST /webhooks/reconciliation-completed
  Descripción: Notificar cuando conciliación se completa
  Payload:
    {
      "reconciliation_id": "uuid",
      "estado": "CONCILIADA" | "DISCREPANCIA",
      "transaction_id": "uuid"
    }

POST /webhooks/settlement-generated
  Descripción: Notificar cuando liquidación es generada
  Payload:
    {
      "settlement_id": "uuid",
      "periodo": "2026-01",
      "monto_total": 1000000
    }
```

---

## 6. Seguridad y Compliance

### 6.1 Seguridad de Datos

- **Encriptación:**
  - En tránsito: TLS 1.3
  - En reposo: AES-256
  - Datos sensibles: Encriptación adicional

- **Autenticación:**
  - OAuth 2.0 / JWT
  - API Keys por actor
  - MFA para operaciones críticas

- **Autorización:**
  - RBAC (Role-Based Access Control)
  - Permisos granulares por actor
  - Auditoría de accesos

### 6.2 Blockchain y Trazabilidad

- **Blockchain BFT (3 nodos):**
  - Consenso distribuido
  - Inmutabilidad de registros
  - Transparencia auditada

- **Trazabilidad:**
  - Hash único por transacción
  - Timestamp inmutable
  - Cadena de custodia completa

### 6.3 Compliance

- **Regulación Chilena:**
  - Ley de Protección de Datos Personales
  - Regulación farmacéutica
  - Regulación financiera

- **Auditoría:**
  - Logs inmutables
  - Reportes de compliance
  - Evidencias auditables

---

## 7. Plan de Desarrollo MVP

### 7.1 Fase 1: MVP Controlado (Q1-Q2 2026)

**Objetivo:** Sistema funcional con integraciones reales para validar concepto

**Entregables:**
1. Arquitectura base
2. APIs básicas
3. Validación de transacciones GES con integraciones reales
4. Dashboard básico por actor
5. Blockchain básico (3 nodos BFT)

**Timeline:** 8-10 semanas

### 7.2 Fase 2: Escalamiento y Optimización (Q2-Q3 2026)

**Objetivo:** Escalar integraciones y optimizar sistema

**Entregables:**
1. Integración con más farmacias e isapres
2. Optimización de performance
3. Mejoras de UX basadas en feedback
4. Reportes avanzados
5. Preparación para auditoría

**Timeline:** 10-12 semanas

### 7.3 Fase 3: Escalamiento (Q3-Q4 2026)

**Objetivo:** Preparación para auditoría y escalamiento

**Entregables:**
1. Documentación completa
2. Auditoría tecnológica Big Four
3. Ajustes post-auditoría
4. Preparación para escalamiento

**Timeline:** 8-10 semanas

---

## 8. Stack Tecnológico Propuesto

### 8.1 Backend

- **API:** Node.js + Express / Python + FastAPI
- **Base de Datos:** PostgreSQL 15+
- **Cache:** Redis
- **Message Queue:** RabbitMQ / AWS SQS
- **Blockchain:** Hyperledger Fabric / Cosmos SDK

### 8.2 Frontend

- **Dashboard:** React + TypeScript
- **UI Components:** shadcn/ui / Material-UI
- **State Management:** TanStack Query + Zustand

### 8.3 Infraestructura

- **Cloud:** AWS / Google Cloud Platform
- **Containers:** Docker + Kubernetes
- **CI/CD:** GitHub Actions / GitLab CI
- **Monitoring:** Prometheus + Grafana
- **Logging:** ELK Stack / CloudWatch

### 8.4 Seguridad

- **API Gateway:** Kong / AWS API Gateway
- **WAF:** Cloudflare / AWS WAF
- **Secrets Management:** AWS Secrets Manager / HashiCorp Vault

---

## 9. Métricas de Éxito MVP

### 9.1 Técnicas

- Disponibilidad: 99.9%
- Tiempo de respuesta API: < 200ms (p95)
- Throughput: 1000 transacciones/minuto
- Tasa de conciliación automática: > 95%

### 9.2 Negocio

- Transacciones procesadas: 10,000+ mensuales
- Actores conectados: 3+ (1 farmacia, 1 isapre, 1 laboratorio)
- Tasa de discrepancias detectadas: < 5%
- Tiempo de conciliación: < 24 horas

---

## 10. Riesgos y Mitigaciones

### 10.1 Riesgos Técnicos

| Riesgo | Impacto | Probabilidad | Mitigación |
|--------|---------|--------------|------------|
| Escalabilidad blockchain | Alto | Media | Optimización de consenso, sharding |
| Integración con sistemas legacy | Alto | Alta | APIs adaptadores, documentación clara |
| Seguridad de datos | Crítico | Media | Auditorías de seguridad, encriptación |

### 10.2 Riesgos de Negocio

| Riesgo | Impacto | Probabilidad | Mitigación |
|--------|---------|--------------|------------|
| Adopción lenta | Alto | Media | Pilotos con incentivos, soporte dedicado |
| Cambios regulatorios | Medio | Baja | Diseño flexible, monitoreo regulatorio |
| Competencia | Medio | Media | Diferenciación técnica, relaciones estratégicas |

---

## 11. Próximos Pasos

1. **Revisión de documentación** con equipo técnico
2. **Cotización con Software Factory** basada en este documento
3. **Definición de contrato** y términos de desarrollo
4. **Kick-off técnico** con equipo de desarrollo
5. **Inicio Fase 1** (MVP Controlado)

---

**Fecha:** Enero 2026  
**Versión:** 1.0
