# otra app fitness - Especificaciones Técnicas (v1.1)

Este documento detalla la arquitectura, estándares de seguridad y decisiones tecnológicas para la implementación de **"otra app fitness"**, alineado con las especificaciones funcionales y no funcionales previas.

---

## 1. Modelo de Computación en la Nube (Cloud Computing)

### 1.1 Modelo de Responsabilidad Compartida
Se utilizará un proveedor de nube (AWS/Azure/GCP) bajo el siguiente esquema:

| Capa | Responsabilidad del Proveedor (Cloud) | Responsabilidad de "otra app fitness" |
| :--- | :--- | :--- |
| **Infraestructura** | Seguridad física de centros de datos, redes y hardware. | N/A |
| **Plataforma** | Parches del SO, virtualización y servicios gestionados. | Configuración de políticas de acceso y red. |
| **Datos y Aplicación** | Disponibilidad del servicio (SLA). | Cifrado de datos, gestión de identidades y lógica de negocio. |

### 1.2 Estrategia de Servicios: Serverless (FaaS) sobre BaaS
De acuerdo con las **Especificaciones No Funcionales** (optimización de recursos, escalabilidad horizontal y respuesta < 4s), se opta por un modelo **Serverless**:

- **FaaS (Function as a Service):** La lógica de negocio (recalibración quincenal, motor de rutinas) se ejecutará en funciones independientes (ej. AWS Lambda). Esto garantiza escalabilidad automática para los 500 usuarios concurrentes sin gestionar servidores.
- **BaaS (Backend as a Service):** Se delegarán servicios comunes como:
    - **Autenticación:** (ej. Firebase Auth o AWS Cognito).
    - **Base de Datos:** (ej. MongoDB Atlas o AWS DynamoDB).
    - **Notificaciones:** (ej. FCM).

### 1.3 Disponibilidad, Persistencia y Redundancia (Server-Side)
Para garantizar la continuidad del negocio y la integridad de los datos en el servidor, se delegan las siguientes funciones al proveedor de nube (BaaS):

- **Persistencia de Datos (Durabilidad):** Se utilizarán servicios de bases de datos con almacenamiento distribuido (ej. AWS DynamoDB o MongoDB Atlas). Los datos se escriben en múltiples dispositivos físicos de almacenamiento dentro de una misma zona para evitar pérdidas por fallos de hardware local.
- **Redundancia Geográfica (Multi-AZ):** Las bases de datos y funciones FaaS se desplegarán en un esquema de **Múltiples Zonas de Disponibilidad (Multi-AZ)**. Si un centro de datos físico falla, el tráfico se redirige automáticamente a otro centro de datos en la misma región sin pérdida de servicio.
- **Backups Automatizados:** Se configurarán copias de seguridad incrementales automáticas con una retención de 30 días y capacidad de Point-in-Time Recovery (PITR) para restaurar la base de datos a cualquier segundo específico en caso de corrupción lógica.
- **Alta Disponibilidad (SLA):** El uso de servicios gestionados garantiza una disponibilidad del **99.9%** a nivel de infraestructura, alineado con el requerimiento de disponibilidad global del sistema.

---

## 2. Arquitectura de Microservicios

### 2.1 Descomposición de Servicios
La aplicación se estructurará en microservicios desacoplados para facilitar el mantenimiento independiente:
- **API Gateway:** Único punto de entrada. Gestiona seguridad, autenticación y ECC.
- **Servicio de Perfil (Profile MS):** Gestión de biometría y condiciones médicas.
- **Motor de Entrenamiento (Fitness Engine MS):** Lógica de generación de rutinas, matriz de anatomía funcional y validador de integridad (impide cambios manuales no justificados médicamente).
- **Servicio de Nutrición (Nutrition MS):** Filtros de exclusión y sugerencias alimenticias.
- **Servicio de Progreso (Analytics MS):** Cálculos de desviación y recalibración.

### 2.2 Patrones de Diseño
- **CQRS (Command Query Responsibility Segregation):** Separación de flujos para lectura rápida de "datos calientes" y escritura de actualizaciones biométricas.
- **Event-Driven Architecture:** Comunicación asíncrona entre microservicios para procesos no críticos (ej. generar reporte de progreso tras actualización de peso).

---

## 3. Estrategia de Seguridad y Cifrado

### 3.1 Capas de Seguridad
1. **Perímetro:** WAF y Protección anti-DDoS.
2. **Red:** Aislamiento en VPC con subredes privadas.
3. **Aplicación:** JWT con rotación de llaves.
4. **Datos:** Aislamiento lógico multi-tenant.

### 3.2 Estándares de Cifrado y Comunicación
- **AES-256:** Cifrado obligatorio para datos en reposo (lesiones e historial médico).
- **ECC (Elliptic Curve Cryptography):** Protocolo para comunicación **Server-to-Device**. 
    - *Justificación:* Menor consumo de batería y datos móviles (cumpliendo ENF #1.3) manteniendo alta seguridad.
- **TLS 1.3:** Para todos los datos en tránsito.

---

## 4. Stack Tecnológico y Limitaciones de Lenguajes

### 4.1 Tecnologías Propuestas
- **Backend (FaaS):** TypeScript (Node.js).
    - *Limitación:* Latencia de "Cold Start" en FaaS. Se mitigará usando *Provisioned Concurrency* en funciones críticas para asegurar respuesta < 4s.
- **Mobile:** Flutter.
    - *Limitación:* El puente (bridge) con código nativo para cifrado ECC complejo. Se usarán plugins optimizados en C++/Rust.
- **Persistencia Local:** Isar (Base de datos NoSQL de alto rendimiento para Flutter) para modo offline.

---

## 5. Estrategia de Disponibilidad Offline
- **Sincronización:** Patrón *Offline-First*.
- **Persistencia Local:** Los "datos calientes" se almacenan cifrados en el dispositivo del usuario para acceso inmediato sin red.

---
**Nota:** Esta arquitectura prioriza la eficiencia de costos y la velocidad de respuesta requerida para el MVP de 500 usuarios.
