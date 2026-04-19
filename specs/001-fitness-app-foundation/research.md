# Research: Initial Application Foundation

## Decision 1: Modular Architecture Pattern
- **Decision**: Feature-by-Layer with Strategy Pattern for Generation.
- **Rationale**: The user requested a modular planification where each functionality is independent. By using Feature-by-Layer, the `routines` module does not depend on the `nutrition` module. The Strategy pattern allows the system to swap or add new generation logic (e.g., "Weight Loss Strategy", "Muscle Gain Strategy") without changing the orchestration layer.
- **Alternatives Considered**: 
    - Standard Layered Architecture: Rejected because it creates tight coupling between features at the service layer.
    - Micro-frontends: Rejected for MVP due to excessive complexity in a single mobile app.

## Decision 2: Security Implementation (AES-256 / ECC)
- **Decision**: `encrypt` for AES-256 (Local) and `pointycastle` for ECC (API).
- **Rationale**: Fits the technical spec requirement for military-grade security. AES-256 will encrypt the local SQLite database file. ECC (secp256k1) will be used for signing requests to the Serverless API, ensuring authenticity without the overhead of heavy RSA keys.
- **Alternatives Considered**: 
    - RSA: Rejected due to slower performance on mobile devices compared to ECC.

## Decision 3: On-Demand Generation Logic
- **Decision**: "Verified State" Guard.
- **Rationale**: Requirement FR-001 and FR-002 mandate that routines/diets are ONLY generated after full data submission. We will implement a `ValidationService` that checks the biometric snapshot's "Verified" flag before triggering the generation event.
- **Alternatives Considered**: 
    - Background polling: Rejected because it violates the "On-Demand" requirement and wastes battery.

## Decision 4: Habit Analytics (Consistency Score)
- **Decision**: Exponential Decay Weighted Average.
- **Rationale**: A simple average of 10 entries doesn't reflect recent improvement. The consistency score will weigh the most recent 3 entries at 50% of the total score, rewarding immediate habit formation.
- **Alternatives Considered**: 
    - Binary "Yes/No" streaks: Rejected because they are demotivating if a single day is missed.

## Best Practices for Target Technologies
- **Flutter**: Use `flutter_bloc` for predictable state transitions during the verification flow.
- **SQLite (Drift)**: Use DAO (Data Access Objects) for each feature to maintain modularity at the storage layer.
- **Serverless**: Use AWS Lambda with a Warm-up plugin to ensure the <10s generation requirement (SC-001) is met despite potential cold starts.
## Resilience & Fault Tolerance Strategy
- **Isolation**: Each feature (Routines, Nutrition, Progress) uses independent BLoCs. A failure in one does not block the initialization of the others.
- **Data Persistence**: Using `Drift` for SQLite ensures that the "Data Continuity" principle is met. The app will prioritize local data and only refresh from AWS when available.
- **Encryption Integrity**: If the AES key is lost or corrupted, the system will trigger a secure "Reset to Last Cloud Sync" flow rather than crashing.

## Testing Matrix & Roadmap

### 1. Verification Flow (Auth)
- **Unit**: Validation rules for age (18-35), weight, and dietary restrictions.
- **Integration**: Testing the transition from the Summary screen to account creation.

### 2. Routine & Nutrition Engines
- **Logic**: Testing the "On-Demand" trigger ensures that generation only occurs when `is_verified == true`.
- **Contract**: Testing the `POST /generate/routine` request against the AWS mock.

### 3. Analytics & Progress
- **Math**: Verifying the Exponential Decay formula for the Consistency Score.
- **Constraint**: Edge-case testing for the 10th and 11th monthly entries.

### 4. Aesthetics (UI)
- **Golden Tests**: Capturing widget renders to ensure the "Fitness-oriented theme" and Glassmorphism design system are preserved.
