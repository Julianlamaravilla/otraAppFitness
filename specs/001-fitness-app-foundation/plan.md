# Implementation Plan: Initial Application Specification

**Branch**: `001-initial-spec` | **Date**: 2026-04-18 | **Spec**: [spec.md](file:///Users/julianrestrepo/Documents/otra_app_fitness/specs/001-fitness-app-foundation/spec.md)
**Input**: Feature specification from `/specs/001-fitness-app-foundation/spec.md`

## Summary

This feature establishes the foundation for "Another fitness app", implementing a modular mobile architecture that supports on-demand personalized routine and diet generation. The technical approach leverages a Local-First strategy for offline accessibility, secured by military-grade encryption (AES-256/ECC) and a robust data verification registration flow.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.24.x (Mobile), TypeScript/Node.js 20.x (Serverless)  
**Primary Dependencies**: flutter_bloc (8.1+), drift (2.32+), encrypt (5.0+), pointycastle (3.9+)  
**Cloud Infrastructure (AWS)**: API Gateway, Lambda (Node 20), DynamoDB, Cognito, KMS, S3  
**Storage**: SQLite (Drift) for local persistence; DynamoDB for cloud backup/sync  
**Testing**: flutter_test (Unit), Golden Tests (UI), Pact (Contract), integration_test (E2E)  
**Target Platform**: iOS 15+, Android 10+  
**Project Type**: Mobile App + AWS Serverless API  
**Performance Goals**: <4s screen load; <10s routine generation  
**Constraints**: 100% manual entry (no external sync); 10 entries/month limit; 100% offline konsultation  
**Scale/Scope**: MVP focused on 5 core use cases; Modular architecture for future habit expansion

## Constitution Check

| Principle | Condition to Pass | Status |
|-----------|-------------------|--------|
| **Performance First** | Dashboard and graphs must load in <4s. | 🟡 PENDING |
| **User-Centric Design** | Registration flow must include a data verification summary screen. | 🟡 PENDING |
| **High Availability** | Serverless architecture with Multi-AZ support for backup sync. | 🟢 PASSED (Design) |
| **Data Continuity** | Local-First data model allows offline consulting of the last 10 entries. | 🟢 PASSED (Design) |
| **Effective Personalization** | Routine generation logic must only trigger on "verified" biometric state. | 🟢 PASSED (Design) |

## Resilience & Fault Tolerance

To ensure the application remains functional even when individual services fail:
- **Modular Circuit Breaker**: Each feature module (Routines, Nutrition, Progress) is wrapped in an isolation layer. A failure in the Cloud Generation service will trigger a **Local Fallback**, displaying the last known stable data from the SQLite DB.
- **Graceful UI Degradation**: If a specific module fails to load, a "Service Temporarily Unavailable" widget is displayed *only* for that module, allowing the user to continue using the rest of the app.
- **Retry Strategy**: All API calls use exponential backoff (e.g., 1s, 2s, 4s) to handle transient network issues without blocking the main thread.

## Testing Roadmap

### Module-Specific Testing
1. **Auth & Profile**: Unit tests for the data verification flow; Integration tests for profile creation.
2. **Routines**: Logic tests for the "Verified Biometrics" guard and the bi-weekly expiration logic.
3. **Progress**: Validation tests for the "10-entry monthly limit" (enforced both in mobile and AWS).
4. **Security**: Audit tests to verify AES-256 encryption on the physical `.db` file.
5. **UI/UX**: Golden tests for Glassmorphism components and gradients to ensure aesthetic consistency.

### Global Testing
- **Contract Tests**: Ensuring mobile-to-AWS communication follows `api-v1.yaml`.
- **Sync Reliability**: Automated tests for offline-to-online data consistency (SC-007).

## Project Structure

### Documentation (this feature)

```text
specs/001-fitness-app-foundation/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
api/
├── src/
│   ├── routines/        # Generation logic
│   ├── nutrition/       # Suggestion engine
│   └── shared/          # Security & Encryption utilities
└── tests/

mobile/
├── lib/
│   ├── features/
│   │   ├── auth/        # Verification & Confirmation flow
│   │   ├── routines/    # Dynamic routine display
│   │   ├── progress/    # Graphs & Metric tracking
│   │   └── profile/     # Biometric capture
│   ├── core/            # Encryption (AES/ECC), Local DB
│   └── shared/          # UI Components (Glassmorphism, Gradients)
└── test/
```

**Structure Decision**: Selected a Clean Architecture approach with a "Feature-by-Layer" structure inside the mobile module to ensure the modularity requested for routines and diets.
