# otra app fitness - Especificaciones No Funcionales (ENF)

Este documento define los atributos de calidad, restricciones y criterios de operación que garantizan que **"otra app fitness"** sea un sistema seguro, eficiente y escalable, más allá de sus funciones específicas.

---

## 1. Rendimiento y Eficiencia
* **Tiempos de Respuesta:** El sistema debe procesar y mostrar los "datos calientes" (biometría y rutina diaria) en un tiempo máximo de **4.0 segundos** tras la solicitud del usuario.
* **Capacidad de Carga:** El sistema debe mantener su estabilidad y tiempos de respuesta sin degradación con un volumen de hasta **500 usuarios concurrentes** durante la fase MVP.
* **Eficiencia de Recursos:** El consumo de datos móviles y almacenamiento local debe estar optimizado para no penalizar a usuarios con planes de datos limitados o dispositivos con poco espacio.

## 2. Seguridad y Privacidad
* **Confidencialidad de Datos Sensibles:** Toda la información relacionada con lesiones, condiciones médicas, peso e historial de salud debe ser tratada como datos de alta sensibilidad, siendo inaccesibles para cualquier entidad externa al usuario.
* **Integridad y Rigidez del Plan:** Se deben implementar mecanismos que aseguren que los datos de progreso y rutinas no sufran alteraciones no autorizadas por el usuario. La arquitectura debe forzar la inmutabilidad del plan diario a menos que se cumplan disparadores médicos o de periodo.
* **Control de Acceso:** El sistema debe garantizar que solo el usuario autenticado pueda visualizar y modificar su perfil biométrico y plan de hábitos.

## 3. Disponibilidad y Fiabilidad
* **Continuidad del Servicio:** La plataforma debe garantizar una disponibilidad del **99.5%**, minimizando las ventanas de mantenimiento programado.
* **Resiliencia (Modo Offline):** Las funciones críticas de consulta (rutina del día y plan nutricional) deben ser operables incluso en condiciones de intermitencia de red mediante persistencia de datos local.
* **Recuperación ante Fallos:** El sistema debe contar con mecanismos de respaldo diarios para asegurar una pérdida de datos mínima en caso de un evento catastrófico en los servidores.

## 4. Usabilidad y Accesibilidad
* **Facilidad de Uso:** El diseño debe permitir que un usuario nuevo complete su diagnóstico inicial y visualice su primera rutina en menos de **5 minutos** mediante una navegación intuitiva.
* **Adaptabilidad de Interfaz:** La interfaz debe ser completamente adaptable (Responsive) a diferentes resoluciones de pantalla, priorizando la experiencia en dispositivos móviles.
* **Inclusión:** El sistema debe cumplir con estándares de contraste y legibilidad que permitan su uso por personas con deficiencias visuales leves (ej. daltonismo).

## 5. Mantenibilidad y Escalabilidad
* **Escalabilidad Horizontal:** El diseño del sistema debe permitir el incremento de su capacidad de procesamiento de forma modular ante un crecimiento exponencial de la base de usuarios.
* **Modularidad:** Los módulos de nutrición, entrenamiento y gestión de perfil deben estar desacoplados para permitir actualizaciones independientes sin afectar la integridad global del sistema.
* **Trazabilidad de Errores:** El sistema debe registrar eventos y fallos de manera interna para permitir un diagnóstico rápido y una mejora continua del software.

---
**Nota:** Estas especificaciones actúan como los criterios de aceptación para las pruebas de rendimiento, seguridad y experiencia de usuario del proyecto.