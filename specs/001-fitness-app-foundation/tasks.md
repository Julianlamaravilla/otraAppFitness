# Tasks: Initial Application Specification (Step-by-Step Service Implementation)

## Phase 1: Setup & Workspace

- [x] T001 Initialize Flutter 3.24 project in `mobile/` with modular folder structure
- [x] T002 [P] Setup Serverless Framework in `api/` targeting Node.js 20.x
- [x] T003 [P] Configure `mobile/pubspec.yaml` with verified versions (bloc 8.1, drift 2.32, encrypt 5.0)
- [x] T004 Define AWS IAM roles and Cognito User Pool in `api/serverless.yml`

## Phase 2: Foundational Security & Data (Core)

- [x] T005 Implement AES-256 service for local file encryption in `mobile/lib/core/security/aes_vault.dart`
- [x] T006 Implement ECC service for API request signing in `mobile/lib/core/security/ecc_vault.dart`
- [x] T007 Setup Drift Database with global `ProgressEntries` and `UserMetadata` tables in `mobile/lib/core/db/database.dart`
- [x] T008 [P] Implement base Network Client with `dio_smart_retry` in `mobile/lib/core/network/api_client.dart`

## Phase 3: [US4] Registration & Data Verification Service (P1)

- [x] T009 [US4] Implement Biometric Data Collection BLoC in `mobile/lib/features/auth/bloc/auth_bloc.dart`
- [x] T010 [US4] Create Biometric Summary Presentation Screen in `mobile/lib/features/auth/presentation/verify_screen.dart`
- [x] T011 [US4] Implement Data Verification Logic (Summary check) in `mobile/lib/features/auth/domain/verification_service.dart`
- [x] T012 [US4] Create "Account Confirmed" transition with ECC key initialization in `mobile/lib/features/auth/domain/registration_service.dart`
- [x] T013 [P] [US4] Unit Test: Validate Biometric Verification state flow in `mobile/test/features/auth/auth_bloc_test.dart`

## Phase 4: [US1] Personalized Routine Generation Service (P1)

- [x] T014 [US1] Implement Routine Generation Lambda handler in `api/src/routines/generate.ts`
- [x] T015 [US1] Build Routine Generation Logic (Strategy Pattern) in `api/src/routines/logic/routine_engine.ts`
- [x] T016 [US1] Implement the `VerifiedSnapshot` guard to prevent generation without verification in `api/src/routines/middleware/guard.ts`
- [x] T017 [US1] Create Routine Display BLoC and State in `mobile/lib/features/routines/bloc/routine_bloc.dart`
- [x] T018 [US1] Build Routine Dashboard with Glassmorphism cards in `mobile/lib/features/routines/presentation/routine_view.dart`
- [x] T019 [P] [US1] Contract Test: Verify `/v1/routines/generate` against OpenAPI spec in `mobile/test/contracts/routine_contract_test.dart`

## Phase 5: [US2] Progress Tracking & Analytics Service (P2)

- [x] T020 [US2] Implement Progress Entry DAO with monthly count validation in `mobile/lib/core/db/daos/progress_dao.dart`
- [x] T021 [US2] Implement Habit Consistency Score formula (Exponential Decay) in `mobile/lib/features/progress/domain/analytics_service.dart`
- [x] T022 [US2] Create Progress Submission Form (Manual Entry) in `mobile/lib/features/progress/presentation/add_entry_screen.dart`
- [x] T023 [US2] Implement Dynamic Line Charts for Biometrics in `mobile/lib/features/progress/presentation/charts_view.dart`
- [x] T024 [P] [US2] Unit Test: Verify 10-entry/month limit enforcement in `mobile/test/features/progress/analytics_test.dart`
- [x] T025 [US2] Golden Test: Verify Graph UI rendering in `mobile/test/features/progress/graph_golden_test.dart`

## Phase 6: [US3] Nutritional Recommendations Service (P2)

- [x] T026 [US3] Implement Nutrition Suggestion Lambda handler in `api/src/nutrition/suggest.ts`
- [x] T027 [US3] Build Dietary Restriction Exclusion Filter (e.g. Allergy exclusion) in `api/src/nutrition/logic/exclusion_engine.ts`
- [x] T028 [US3] Implement Nutrition BLoC for on-demand fetching in `mobile/lib/features/nutrition/bloc/nutrition_bloc.dart`
- [x] T029 [US3] Build Nutrition Suggestion View in `mobile/lib/features/nutrition/presentation/nutrition_dashboard.dart`
- [x] T030 [P] [US3] Integration Test: Verify Peanut Allergy exclusion in `api/tests/nutrition/exclusion_test.ts`

## Phase 7: Final Integration & Reliability

- [x] T031 Implement Global Error Boundary and Circuit Breaker widgets in `mobile/lib/shared/widgets/error_boundary.dart`
- [x] T032 Create Background Sync Manager for offline-to-online reconciliation in `mobile/lib/core/sync/sync_manager.dart`
- [x] T033 [P] Perform E2E Security Audit (DB encryption & ECC sign verification)
- [x] T034 Final UI Polish (Transitions, Theme consistency, and Animations)

## Dependencies & Strategy

### Story Completion Order
`[Auth (US4)] -> [Routines (US1)] -> [Progress (US2)] -> [Nutrition (US3)]`

### Parallel Tracks
- **Track A (Backend)**: T014, T015, T026, T027 can be built while UI is being drafted.
- **Track B (Security)**: T005, T006 are blockers for all data-handling tasks.
- **Track C (Design)**: T010, T018, T023 can follow a parallel aesthetic track.

### MVP Scope
User Story 4 and User Story 1 are the mandatory requirements for the first internal release.
