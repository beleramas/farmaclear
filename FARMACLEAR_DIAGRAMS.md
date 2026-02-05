# Farmaclear - Diagramas Técnicos Detallados

## 1. Diagrama de Arquitectura de Alto Nivel

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         FARMACLEAR PLATFORM                              │
│                    (Capa Neutral de Clearing)                            │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
            ┌───────▼───────┐ ┌─────▼─────┐ ┌───────▼───────┐
            │  API Gateway  │ │   Core    │ │  Blockchain   │
            │  (Kong/AWS)   │ │  Engine   │ │  (BFT 3 nodos)│
            └───────┬───────┘ └─────┬─────┘ └───────┬───────┘
                    │               │               │
        ┌───────────┼───────────────┼───────────────┼───────────┐
        │           │               │               │           │
┌───────▼──────┐ ┌──▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐
│ Validation  │ │Reconcile│ │ Settlement  │ │  Audit &    │
│  Service    │ │ Service │ │  Service    │ │ Traceability │
└───────┬──────┘ └──┬──────┘ └──────┬──────┘ └──────┬──────┘
        │           │               │               │
        └───────────┼───────────────┼───────────────┘
                    │               │
            ┌───────▼───────────────▼───────┐
            │      Data Layer                │
            │  PostgreSQL + Redis Cache      │
            └───────────────────────────────┘
```

## 2. Diagrama de Actores e Interacciones

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   FARMACIA   │         │ ISAPRE/FONASA│         │ LABORATORIO │
│              │         │              │         │              │
│ - Registra   │         │ - Registra   │         │ - Valida     │
│   venta con  │         │   pago de    │         │   notas de   │
│   descuento  │         │   descuento  │         │   crédito    │
└──────┬───────┘         └──────┬───────┘         └──────┬───────┘
       │                        │                       │
       │ POST /transactions     │ POST /registros      │ GET /settlements
       │                        │                       │
       └───────────┬────────────┴───────────┬──────────┘
                   │                        │
                   ▼                        ▼
        ┌──────────────────────────────────────────┐
        │      FARMACLEAR PLATFORM                  │
        │                                            │
        │  1. Validación                            │
        │  2. Registro Blockchain                  │
        │  3. Conciliación Automática              │
        │  4. Generación Liquidación               │
        │  5. Notificación a Actores               │
        └──────────────────────────────────────────┘
```

## 3. Flujo Detallado de Transacción GES

```
[FARMACIA] Venta con descuento GES
    │
    ├─► POST /api/v1/transactions
    │   {
    │     "tipo": "GES",
    │     "codigo_prestacion": "GES-001",
    │     "paciente_rut": "12345678-9",
    │     "monto_total": 10000,
    │     "monto_descuento": 2000
    │   }
    │
    ▼
[API GATEWAY]
    │
    ├─► Autenticación (JWT)
    ├─► Validación de entrada
    ├─► Rate limiting
    │
    ▼
[VALIDATION SERVICE]
    │
    ├─► ¿Prestación GES válida? ──NO──► Error 400
    ├─► ¿Paciente elegible? ────NO──► Error 400
    ├─► ¿Monto descuento correcto? ─NO──► Error 400
    │
    └─► Validación OK
        │
        ▼
[BLOCKCHAIN LAYER]
    │
    ├─► Generar hash transacción
    ├─► Consenso entre 3 nodos
    ├─► Registrar en blockchain
    │
    ▼
[RECONCILIATION SERVICE]
    │
    ├─► Buscar registro Isapre/Fonasa
    ├─► Matching automático
    │   ├─► Match encontrado ──► Estado: CONCILIADA
    │   └─► Sin match ──────────► Estado: PENDIENTE
    │
    ▼
[NOTIFICATION SERVICE]
    │
    ├─► Webhook a Farmacia: "Transacción validada"
    ├─► Webhook a Isapre/Fonasa: "Conciliación pendiente"
    │
    ▼
[SETTLEMENT SERVICE] (si conciliada)
    │
    ├─► Agrupar por período
    ├─► Calcular liquidación
    ├─► Generar nota de crédito
    │
    ▼
[NOTIFICATION SERVICE]
    │
    └─► Webhook a Laboratorio: "Liquidación generada"
```

## 4. Arquitectura de Blockchain BFT

```
                    ┌─────────────────┐
                    │  CLIENT APP     │
                    │  (Farmaclear)   │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  ORDERER NODE   │
                    │  (Coordinador)  │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
┌───────▼────────┐  ┌────────▼────────┐  ┌───────▼────────┐
│  PEER NODE 1   │  │  PEER NODE 2    │  │  PEER NODE 3  │
│  (Farmaclear)  │  │  (Isapre)       │  │  (Regulador)  │
│                │  │                 │  │               │
│  - Ledger      │  │  - Ledger       │  │  - Ledger     │
│  - Smart       │  │  - Smart        │  │  - Smart      │
│    Contracts   │  │    Contracts    │  │    Contracts  │
└────────────────┘  └─────────────────┘  └───────────────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
                    ┌────────▼────────┐
                    │  CONSENSUS      │
                    │  (BFT)         │
                    │  - 2/3 nodos    │
                    │    deben        │
                    │    coincidir    │
                    └─────────────────┘
```

## 5. Modelo de Datos Simplificado

```
┌─────────────────┐
│   TRANSACTIONS  │
│─────────────────│
│ id (PK)         │
│ hash            │──┐
│ farmacia_id     │  │
│ tipo_prestacion │  │
│ paciente_rut    │  │
│ monto_descuento │  │
│ estado          │  │
└─────────────────┘  │
                     │
┌─────────────────┐  │
│ RECONCILIATIONS │◄─┘
│─────────────────│
│ id (PK)         │
│ transaction_id  │──┐
│ isapre_id       │  │
│ estado          │  │
│ diferencia      │  │
└─────────────────┘  │
                     │
┌─────────────────┐  │
│  SETTLEMENTS    │◄─┘
│─────────────────│
│ id (PK)         │
│ periodo         │
│ farmacia_id     │
│ laboratorio_id  │
│ total_monto     │
│ nota_credito_id │──┐
└─────────────────┘  │
                     │
┌─────────────────┐  │
│  CREDIT_NOTES   │◄─┘
│─────────────────│
│ id (PK)         │
│ numero          │
│ monto           │
│ estado          │
└─────────────────┘
```

## 6. Flujo de Conciliación Detallado

```
┌──────────────────┐              ┌──────────────────┐
│   FARMACIA        │              │  ISAPRE/FONASA   │
│                   │              │                  │
│ Registro Venta    │              │ Registro Pago    │
│ con Descuento     │              │ de Descuento     │
└─────────┬─────────┘              └─────────┬────────┘
          │                                  │
          │ POST /transactions               │ POST /registros
          │                                  │
          └──────────────┬───────────────────┘
                         │
                         ▼
          ┌──────────────────────────────┐
          │  RECONCILIATION ENGINE        │
          │                               │
          │  Matching Algorithm:           │
          │  1. RUT Paciente              │
          │  2. Código Prestación         │
          │  3. Fecha (± 7 días)          │
          │  4. Monto (± 5%)              │
          │                               │
          │  Resultados:                  │
          │  ├─► Match encontrado        │
          │  │   └─► Estado: CONCILIADA   │
          │  │                            │
          │  ├─► Match parcial           │
          │  │   └─► Estado: DISCREPANCIA │
          │  │                            │
          │  └─► Sin match                │
          │      └─► Estado: PENDIENTE   │
          └──────────────┬─────────────────┘
                         │
                         ▼
          ┌──────────────────────────────┐
          │  BLOCKCHAIN REGISTRY         │
          │  - Hash transacción          │
          │  - Estado conciliación       │
          │  - Timestamp                 │
          └──────────────────────────────┘
```

## 7. Arquitectura de Seguridad

```
                    ┌─────────────────┐
                    │   INTERNET      │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │   CLOUDFLARE   │
                    │   WAF + DDoS   │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  API GATEWAY   │
                    │  - Auth (JWT)  │
                    │  - Rate Limit  │
                    │  - Logging     │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
┌───────▼────────┐  ┌────────▼────────┐  ┌───────▼────────┐
│  APPLICATION   │  │   DATABASE      │  │   BLOCKCHAIN   │
│   LAYER        │  │   (Encrypted)   │  │   (BFT)        │
│                │  │                 │  │                │
│  - TLS 1.3     │  │  - AES-256      │  │  - Immutable   │
│  - OAuth 2.0   │  │  - At Rest      │  │  - Distributed │
│  - RBAC        │  │  - Backups      │  │  - Auditable   │
└────────────────┘  └─────────────────┘  └────────────────┘
```

## 8. Flujo de Liquidación Mensual

```
[SETTLEMENT ENGINE] - Inicio de mes
    │
    ├─► Agrupar transacciones conciliadas del mes anterior
    │
    ├─► Calcular por farmacia + laboratorio:
    │   ├─► Total descuentos GES
    │   ├─► Comisión Farmaclear (1.2%)
    │   └─► Monto a pagar a laboratorio
    │
    ├─► Generar documentos:
    │   ├─► Nota de Crédito
    │   ├─► Estado de Cuenta
    │   └─► Orden de Pago
    │
    ├─► Validar con Blockchain
    │
    ├─► Enviar a sistema bancario
    │
    └─► Notificar:
        ├─► Farmacia: "Liquidación generada"
        ├─► Laboratorio: "Nota de crédito disponible"
        └─► Isapre/Fonasa: "Liquidación completada"
```

## 9. Diagrama de Deployment

```
                    ┌─────────────────┐
                    │   AWS/GCP       │
                    │   Cloud         │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
┌───────▼────────┐  ┌────────▼────────┐  ┌───────▼────────┐
│  KUBERNETES   │  │   DATABASE      │  │   BLOCKCHAIN   │
│  CLUSTER      │  │   CLUSTER       │  │   NODES        │
│               │  │                 │  │                │
│  - API Pods   │  │  - PostgreSQL   │  │  - Node 1      │
│  - Services   │  │  - Redis        │  │  - Node 2      │
│  - Ingress    │  │  - Backups      │  │  - Node 3      │
└───────────────┘  └─────────────────┘  └────────────────┘
        │
        └───────────────┐
                        │
                ┌───────▼───────┐
                │  MONITORING   │
                │  - Prometheus │
                │  - Grafana    │
                │  - ELK Stack  │
                └───────────────┘
```

## 10. Flujo de Notificaciones

```
[EVENTO] Transacción validada
    │
    ├─► [NOTIFICATION SERVICE]
    │   │
    │   ├─► Webhook a Farmacia
    │   │   POST {webhook_url}/transaction-validated
    │   │
    │   ├─► Email a Farmacia
    │   │   "Transacción #{id} validada"
    │   │
    │   └─► SMS (si crítico)
    │
    ▼
[EVENTO] Conciliación completada
    │
    ├─► [NOTIFICATION SERVICE]
    │   │
    │   ├─► Webhook a Farmacia
    │   ├─► Webhook a Isapre/Fonasa
    │   ├─► Email a ambos
    │   └─► Dashboard update (WebSocket)
    │
    ▼
[EVENTO] Liquidación generada
    │
    └─► [NOTIFICATION SERVICE]
        │
        ├─► Webhook a Laboratorio
        ├─► Email a Laboratorio
        ├─► Email a Farmacia
        └─► Dashboard update
```

---

**Notas para Software Factory:**
- Estos diagramas pueden ser convertidos a formato visual usando herramientas como:
  - Mermaid.js (para documentación web)
  - Draw.io / Lucidchart (para presentaciones)
  - PlantUML (para documentación técnica)
- Todos los diagramas están en formato texto para facilitar su modificación y versionado.
