# otra app fitness - Especificaciones Funcionales (v1.0)

Este documento detalla las especificaciones funcionales del MVP de **"otra app fitness"**, una plataforma diseñada para estructurar hábitos saludables (atléticos y alimenticios) en personas de 18 a 35 años. 

La metodología aplicada ha sido **Spec Driven Development**, evolucionando desde una base general hacia un sistema de recomendación adaptativo, preventivo y con lógica de anatomía funcional.

---

## 1. Visión General del Proyecto
- **Área de Impacto:** Salud general (hábitos atléticos y alimenticios).
- **Público Objetivo:** Personas entre 18 y 35 años interesadas en el deporte.
- **Propósito:** Organizar y estructurar hábitos saludables según el perfil del usuario.
- **Criterio de Éxito:** Interfaz intuitiva, carga de servicios en <2s, disponibilidad de "datos calientes" 24/7 y planes personalizados efectivos/seguros.

---

## 2. Especificaciones de Primer Nivel (Estructura Base)

### 2.1 Gestión del Perfil del Usuario
El sistema segmenta al usuario por biometría, propósito y salud.
- **Entradas:** - **Datos Biométricos:** Nombre, edad, peso y altura.
    - **Ruta A (Bienestar):** Mejora de calidad de vida general.
    - **Ruta B (Rendimiento):** Disciplinas específicas (Musculación, Resistencia, Velocidad, Coordinación, Agilidad o Flexibilidad).
    - **Filtro de Salud:** Condiciones médicas, lesiones o alergias/restricciones alimenticias.
- **Lógica:** Cálculo automático de IMC y TMB. Aplicación de algoritmos de exclusión para filtrar ejercicios de alto impacto según lesiones.

### 2.2 Motor de Rutinas y Nutrición
- **Módulo Atlético:** Asignación de 5 a 8 categorías de entrenamiento (Fuerza, HIIT, Resistencia, Velocidad, Coordinación, Flexibilidad).
- **Guía Nutricional:** Sistema basado en hábitos que cruza recomendaciones con etiquetas de exclusión (ej. `GLUTEN_FREE`, `DAIRY_FREE`) definidas en el perfil.

### 2.3 Recalibración Quincenal
- **Entrada:** Actualización obligatoria cada 15 días de peso, altura y actividad física realizada.
- **Lógica:** Análisis de desviación entre el progreso real vs. el estimado. Si hay estancamiento, el sistema sugiere ajustes en la intensidad o el plan alimenticio.

---

## 3. Especificaciones Avanzadas (Lógica y Flujos Críticos)

### 3.1 Flujos de Usuario (Casos de Uso)

#### CU-01: Onboarding con Mapeo de Salud
- **Entrada:** Formulario de tres capas (Biometría -> Objetivo -> Mapeo de Limitaciones).
- **Lógica:** Identificación de tipo de lesión (ligamentos, fracturas, etc.) y **Zona Corporal** afectada.
- **Salida:** Plan integral que armoniza objetivos con seguridad física.

#### CU-02: Protocolo de Decisión de Lesión (Bifurcación)
Si el sistema detecta colisión entre un objetivo (ej. Carrera) y una limitación (ej. Esguince de tobillo), ofrece:
1. **Opción Rehabilitación:** Prioriza movilidad y recuperación de la zona afectada.
2. **Opción Plan Adaptado:** Si la zona no es crítica para el movimiento (ej. lesión en muñeca para carrera), continúa el plan original bloqueando ejercicios que involucren la zona lesionada.

### 3.2 Reglas de Negocio (Validación)

- **R-01: Matriz de Anatomía Funcional:** Relación entre Actividad y Zona Corporal Crítica. Si la lesión compromete el movimiento principal, el sistema obliga a la alerta de rehabilitación.
- **R-02: Validación Nutricional Estricta:** Bloqueo total de ingredientes prohibidos en el perfil dentro de las sugerencias de menús.

---

## 4. Visualización y Disponibilidad

### 4.1 Dashboard de "Datos Calientes" (Modo Offline)
El sistema mantiene en caché local para acceso inmediato:
- Métricas base (Peso, Altura, IMC).
- Plan nutricional y guía de hidratación del día.
- Rutina diaria según fase actual (Corriente o Rehabilitación).

### 4.2 Trazabilidad y Gráficos
- **Visualización:** Gráficos de dispersión o líneas que comparan el progreso real quincenal vs. la meta establecida.
- **Interfaz:** Uso de *Skeleton Screens* para optimizar la percepción de rendimiento y carga.

---

## 5. Restricciones del MVP (Fuera de Alcance)
- No asegura resultados al 100% (depende del cumplimiento del usuario).
- No incluye reconocimiento de comida por fotos ni medición de calorías por gramaje específico.
- No incluye medición de biometría en tiempo real (sensores).
- No permite la descarga de reportes de resultados en formato externo (PDF/Excel).
- Limitado a un máximo de 5 casos de uso por categoría deportiva.

---
**Nota:** Este documento constituye el plano funcional definitivo para el inicio del desarrollo técnico y arquitectura de base de datos.