# Farmaclear - Especificación Técnica MVP
## Documento para Cotización con Software Factory

**Versión:** 1.0  
**Fecha:** Enero 2026  
**Cliente:** Farmaclear  
**Objetivo:** Desarrollo MVP Fase 1 (MVP Controlado)

---

## 1. Alcance del Proyecto

### 1.1 Objetivo
Desarrollar un MVP funcional del sistema de clearing farmacéutico que permita:
- Validar transacciones GES
- Registrar transacciones en blockchain
- Visualizar transacciones en dashboard básico
- Conciliación automática con sistemas externos reales
- Integración con sistemas de farmacias, isapres y laboratorios

### 1.2 Entregables

#### 1.2.1 Backend
- ✅ API REST completa con autenticación
- ✅ Servicios de validación, conciliación y liquidación
- ✅ Integración con blockchain BFT (3 nodos)
- ✅ Base de datos PostgreSQL
- ✅ Sistema de notificaciones básico
- ✅ Integración con sistemas externos reales (APIs de farmacias, isapres, laboratorios)

#### 1.2.2 Frontend
- ✅ Dashboard para Farmacias
- ✅ Dashboard para Isapres/Fonasa
- ✅ Dashboard para Laboratorios
- ✅ Panel de administración Farmaclear

#### 1.2.3 Infraestructura
- ✅ Setup de desarrollo local
- ✅ Configuración de deployment (Docker)
- ✅ Documentación técnica

#### 1.2.4 Integraciones Externas
- ✅ Integración con sistemas de farmacias (APIs REST/SOAP)
- ✅ Integración con sistemas de Isapres (APIs/Web Services)
- ✅ Integración con sistemas de Fonasa (APIs/Web Services)
- ✅ Integración con sistemas de laboratorios (APIs)
- ✅ Adaptadores para diferentes formatos de datos
- ✅ Manejo de errores y reintentos

### 1.3 Fuera de Alcance (MVP Fase 1)
- ❌ Procesamiento de pagos bancarios
- ❌ Reportes avanzados
- ❌ Mobile apps

---

## 2. Requisitos Funcionales

### 2.1 Gestión de Transacciones

**RF-001: Registrar Transacción**
- **Actor:** Farmacia
- **Descripción:** La farmacia debe poder registrar una transacción con descuento GES
- **Entrada:**
  - Tipo de prestación (GES)
  - Código de prestación
  - RUT del paciente
  - Monto total
  - Monto descuento
  - Fecha de transacción
- **Salida:**
  - ID de transacción
  - Hash de blockchain
  - Estado de validación
- **Validaciones:**
  - Prestación GES válida (validación con sistemas externos)
  - Monto descuento correcto (validación con sistemas externos)
  - RUT válido

**RF-002: Consultar Transacción**
- **Actor:** Todos
- **Descripción:** Consultar estado y detalles de una transacción
- **Entrada:** ID de transacción
- **Salida:** Detalles completos de transacción

**RF-003: Listar Transacciones**
- **Actor:** Todos
- **Descripción:** Listar transacciones con filtros
- **Filtros:**
  - Fecha desde/hasta
  - Estado
  - Tipo de prestación
  - RUT paciente

### 2.2 Validación

**RF-004: Validar Prestación GES**
- **Descripción:** Validar que una prestación GES es válida y el descuento es correcto
- **Validación:**
  - Consulta a sistemas externos de Isapres/Fonasa
  - Verificación de códigos GES válidos
  - Validación de porcentajes y montos de descuento

**RF-005: Validar Elegibilidad**
- **Descripción:** Validar que el paciente es elegible para descuento GES
- **Validación:**
  - Validación de RUT
  - Consulta a sistemas de Isapres/Fonasa para verificar elegibilidad

### 2.3 Conciliación

**RF-006: Conciliación Automática**
- **Descripción:** Conciliar transacciones de farmacia con registros de Isapre/Fonasa
- **Matching por:**
  - RUT paciente
  - Código prestación
  - Fecha (± 7 días)
  - Monto (± 5%)
- **Estados:**
  - CONCILIADA
  - PENDIENTE
  - DISCREPANCIA

**RF-007: Registrar Pago Isapre/Fonasa**
- **Actor:** Isapre/Fonasa
- **Descripción:** Registrar pago de descuento GES
- **Entrada:**
  - RUT paciente
  - Código prestación
  - Monto descuento
  - Fecha pago

### 2.4 Liquidación

**RF-008: Generar Liquidación**
- **Descripción:** Generar liquidación mensual por farmacia y laboratorio
- **Cálculos:**
  - Total descuentos GES
  - Comisión Farmaclear (1.2%)
  - Monto a pagar a laboratorio

**RF-009: Generar Nota de Crédito**
- **Descripción:** Generar nota de crédito para liquidación
- **Campos:**
  - Número único
  - Monto
  - Período
  - Estado (PENDIENTE, APROBADA, RECHAZADA)

### 2.5 Dashboard y Reportes

**RF-010: Dashboard Farmacia**
- **Métricas:**
  - Total transacciones del mes
  - Transacciones validadas
  - Transacciones conciliadas
  - Transacciones pendientes
  - Monto total descuentos

**RF-011: Dashboard Isapre/Fonasa**
- **Métricas:**
  - Total registros del mes
  - Conciliaciones completadas
  - Discrepancias detectadas
  - Pendientes de conciliar

**RF-012: Dashboard Laboratorio**
- **Métricas:**
  - Liquidaciones pendientes
  - Notas de crédito generadas
  - Montos a recibir

---

## 3. Requisitos No Funcionales

### 3.1 Performance

- **Tiempo de respuesta API:** < 200ms (p95)
- **Throughput:** 100 transacciones/minuto (MVP)
- **Disponibilidad:** 99% (MVP)

### 3.2 Seguridad

- **Autenticación:** OAuth 2.0 / JWT
- **Encriptación:** TLS 1.3 en tránsito, AES-256 en reposo
- **Autorización:** RBAC por actor
- **Auditoría:** Logs de todas las operaciones

### 3.3 Escalabilidad

- **Arquitectura:** Microservicios (preparada para escalar)
- **Base de datos:** PostgreSQL con índices optimizados
- **Cache:** Redis para consultas frecuentes

### 3.4 Usabilidad

- **Interfaz:** Responsive (desktop + tablet)
- **Idioma:** Español
- **Accesibilidad:** WCAG 2.1 AA (básico)

---

## 4. Stack Tecnológico

### 4.1 Backend

**Lenguaje:** Node.js + TypeScript  
**Framework:** Express.js / NestJS  
**Base de Datos:** PostgreSQL 15+  
**Cache:** Redis  
**Blockchain:** Hyperledger Fabric / Cosmos SDK  
**Message Queue:** RabbitMQ (opcional para MVP)

### 4.2 Frontend

**Framework:** React 18 + TypeScript  
**Build Tool:** Vite  
**UI Library:** shadcn/ui / Material-UI  
**State Management:** TanStack Query + Zustand  
**Charts:** Recharts

### 4.3 Infraestructura

**Containers:** Docker  
**Orquestación:** Docker Compose (MVP), Kubernetes (producción)  
**CI/CD:** GitHub Actions  
**Monitoring:** Prometheus + Grafana (básico)

---

## 5. Estructura de Proyecto

```
farmaclear-platform/
├── backend/
│   ├── api/
│   │   ├── gateway/          # API Gateway
│   │   ├── transactions/     # API Transacciones
│   │   ├── reconciliations/   # API Conciliaciones
│   │   └── settlements/      # API Liquidaciones
│   ├── services/
│   │   ├── validation/       # Servicio Validación
│   │   ├── reconciliation/  # Servicio Conciliación
│   │   ├── settlement/      # Servicio Liquidación
│   │   └── notification/    # Servicio Notificaciones
│   ├── blockchain/
│   │   ├── nodes/           # Nodos BFT
│   │   └── contracts/      # Smart Contracts
│   ├── database/
│   │   ├── migrations/      # Migraciones DB
│   │   └── seeds/          # Datos iniciales
│   └── shared/
│       ├── models/          # Modelos de datos
│       ├── utils/           # Utilidades
│       └── types/           # TypeScript types
│
├── frontend/
│   ├── src/
│   │   ├── components/      # Componentes React
│   │   ├── pages/           # Páginas
│   │   ├── hooks/           # Custom hooks
│   │   ├── services/        # API clients
│   │   └── lib/             # Utilidades
│   └── public/              # Assets estáticos
│
├── infrastructure/
│   ├── docker/              # Dockerfiles
│   ├── k8s/                 # Kubernetes (futuro)
│   └── scripts/             # Scripts deployment
│
└── docs/
    ├── api/                 # Documentación API
    ├── architecture/        # Arquitectura
    └── user/               # Manual usuario
```

---

## 6. Modelo de Datos (Esquema Base)

### 6.1 Tablas Principales

```sql
-- Actores del sistema
CREATE TABLE actors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tipo VARCHAR(50) NOT NULL, -- FARMACIA, ISAPRE, FONASA, LABORATORIO
    nombre VARCHAR(255) NOT NULL,
    rut VARCHAR(12) UNIQUE,
    api_key VARCHAR(255) UNIQUE,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Transacciones
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_hash VARCHAR(64) UNIQUE,
    farmacia_id UUID REFERENCES actors(id),
    tipo_prestacion VARCHAR(50) NOT NULL, -- GES, NO_GES
    codigo_prestacion VARCHAR(50) NOT NULL,
    paciente_rut VARCHAR(12) NOT NULL,
    monto_total DECIMAL(15,2) NOT NULL,
    monto_descuento DECIMAL(15,2) NOT NULL,
    fecha_transaccion TIMESTAMP NOT NULL,
    estado VARCHAR(50) DEFAULT 'PENDIENTE', -- PENDIENTE, VALIDADA, CONCILIADA, LIQUIDADA
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Conciliaciones
CREATE TABLE reconciliations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID REFERENCES transactions(id),
    isapre_fonasa_id UUID REFERENCES actors(id),
    registro_isapre_fonasa_id UUID,
    estado VARCHAR(50) DEFAULT 'PENDIENTE', -- PENDIENTE, CONCILIADA, DISCREPANCIA
    monto_farmacia DECIMAL(15,2),
    monto_isapre_fonasa DECIMAL(15,2),
    diferencia DECIMAL(15,2),
    motivo_discrepancia TEXT,
    fecha_conciliacion TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Liquidaciones
CREATE TABLE settlements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    periodo_inicio DATE NOT NULL,
    periodo_fin DATE NOT NULL,
    farmacia_id UUID REFERENCES actors(id),
    laboratorio_id UUID REFERENCES actors(id),
    total_descuentos DECIMAL(15,2) NOT NULL,
    comision_farmaclear DECIMAL(15,2) NOT NULL,
    monto_a_pagar DECIMAL(15,2) NOT NULL,
    nota_credito_id UUID,
    estado VARCHAR(50) DEFAULT 'PENDIENTE', -- PENDIENTE, GENERADA, PAGADA
    fecha_liquidacion TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Notas de Crédito
CREATE TABLE credit_notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    settlement_id UUID REFERENCES settlements(id),
    numero VARCHAR(50) UNIQUE NOT NULL,
    monto DECIMAL(15,2) NOT NULL,
    estado VARCHAR(50) DEFAULT 'PENDIENTE', -- PENDIENTE, APROBADA, RECHAZADA
    motivo TEXT,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Reglas de Negocio (configurables, integradas con sistemas externos)
CREATE TABLE business_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tipo_prestacion VARCHAR(50) NOT NULL,
    codigo_prestacion VARCHAR(50) NOT NULL,
    descuento_porcentaje DECIMAL(5,2),
    descuento_monto_fijo DECIMAL(15,2),
    monto_maximo DECIMAL(15,2),
    vigencia_desde DATE NOT NULL,
    vigencia_hasta DATE,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_transactions_farmacia ON transactions(farmacia_id);
CREATE INDEX idx_transactions_estado ON transactions(estado);
CREATE INDEX idx_transactions_fecha ON transactions(fecha_transaccion);
CREATE INDEX idx_reconciliations_transaction ON reconciliations(transaction_id);
CREATE INDEX idx_settlements_periodo ON settlements(periodo_inicio, periodo_fin);
```

---

## 7. APIs Específicas

### 7.1 API de Transacciones

```typescript
// POST /api/v1/transactions
interface CreateTransactionRequest {
  tipo_prestacion: 'GES' | 'NO_GES';
  codigo_prestacion: string;
  paciente_rut: string;
  monto_total: number;
  monto_descuento: number;
  fecha_transaccion: string; // ISO 8601
}

interface CreateTransactionResponse {
  transaction_id: string;
  transaction_hash: string;
  estado: 'VALIDADA' | 'ERROR';
  mensaje: string;
}

// GET /api/v1/transactions/:id
interface GetTransactionResponse {
  id: string;
  transaction_hash: string;
  farmacia: {
    id: string;
    nombre: string;
  };
  tipo_prestacion: string;
  codigo_prestacion: string;
  paciente_rut: string;
  monto_total: number;
  monto_descuento: number;
  estado: string;
  reconciliation?: {
    id: string;
    estado: string;
  };
  created_at: string;
}

// GET /api/v1/transactions
interface ListTransactionsQuery {
  fecha_desde?: string;
  fecha_hasta?: string;
  estado?: string;
  tipo_prestacion?: string;
  paciente_rut?: string;
  page?: number;
  limit?: number;
}
```

### 7.2 API de Conciliaciones

```typescript
// POST /api/v1/reconciliations/registros
interface CreateRegistroRequest {
  paciente_rut: string;
  codigo_prestacion: string;
  monto_descuento: number;
  fecha_pago: string;
}

// GET /api/v1/reconciliations
interface ListReconciliationsResponse {
  reconciliations: Array<{
    id: string;
    transaction_id: string;
    estado: string;
    monto_farmacia: number;
    monto_isapre_fonasa: number;
    diferencia: number;
    fecha_conciliacion: string;
  }>;
  total: number;
  conciliadas: number;
  pendientes: number;
  discrepancias: number;
}
```

### 7.3 API de Liquidaciones

```typescript
// GET /api/v1/settlements
interface ListSettlementsResponse {
  settlements: Array<{
    id: string;
    periodo: string;
    farmacia: {
      id: string;
      nombre: string;
    };
    laboratorio: {
      id: string;
      nombre: string;
    };
    total_descuentos: number;
    comision_farmaclear: number;
    monto_a_pagar: number;
    nota_credito: {
      id: string;
      numero: string;
      estado: string;
    };
    estado: string;
  }>;
}

// POST /api/v1/settlements/generate
interface GenerateSettlementRequest {
  periodo_inicio: string;
  periodo_fin: string;
  farmacia_id: string;
  laboratorio_id: string;
}
```

---

## 8. Plan de Desarrollo

### 8.1 Fase 1: Setup y Arquitectura Base (Semana 1-2)
- Setup de repositorio y estructura de proyecto
- Configuración de base de datos
- Setup de Docker y desarrollo local
- Configuración de CI/CD básico

### 8.2 Fase 2: Backend Core (Semana 3-5)
- Desarrollo de APIs principales
- Servicios de validación
- Integración con blockchain básica
- Tests unitarios

### 8.3 Fase 3: Frontend (Semana 6-7)
- Desarrollo de dashboards
- Integración con APIs
- UI/UX básico

### 8.4 Fase 4: Integración y Testing (Semana 8)
- Testing end-to-end
- Corrección de bugs
- Optimización de performance

### 8.5 Fase 5: Documentación y Deployment (Semana 9-10)
- Documentación técnica
- Documentación de API
- Setup de producción
- Handover

---

## 9. Criterios de Aceptación

### 9.1 Funcionales
- ✅ Todas las APIs funcionan correctamente
- ✅ Validación de transacciones GES funciona
- ✅ Conciliación automática funciona con sistemas externos reales
- ✅ Dashboards muestran datos correctos
- ✅ Blockchain registra transacciones

### 9.2 Técnicos
- ✅ Código sigue estándares (ESLint, Prettier)
- ✅ Tests unitarios > 70% cobertura
- ✅ Documentación completa
- ✅ Deployment funcional

### 9.3 Seguridad
- ✅ Autenticación implementada
- ✅ Encriptación en tránsito y reposo
- ✅ Logs de auditoría funcionando

---

## 10. Presupuesto Estimado

**Nota:** Este documento es para que Software Factory prepare su cotización detallada.

**Estimación preliminar (referencia):**
- Desarrollo Backend: X horas
- Desarrollo Frontend: X horas
- Blockchain Integration: X horas
- Testing: X horas
- Documentación: X horas
- **Total estimado:** X horas

---

**Fecha:** Enero 2026  
**Versión:** 1.0
