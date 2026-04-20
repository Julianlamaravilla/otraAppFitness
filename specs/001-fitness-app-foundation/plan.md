# Implementation Plan: Workflow-First Fitness App (Local-First Stage)

This plan focuses on a **Local-First / On-Premise Simulator** approach. All services, including the API and database, will run on the local machine to ensure a healthy and verified foundation before migrating to the AWS Cloud.

## User Review Required

> [!IMPORTANT]
> **On-Premise Simulation**: The backend will run locally using `serverless-offline` or a local Node.js server. Cloud-specific services (Cognito, DynamoDB) will be mocked or used via local equivalents (e.g., SQLite for both mobile and local API storage).

> [!TIP]
> Migration to AWS will be a separate phase *only* after all local functional tests pass 100%.

## Proposed Changes

### Phase 1: Local Shell & Core Security
Establish the local environment and core security.
- [NEW] `mobile/lib/main.dart` (Basic shell with navigation)
- [NEW] `mobile/lib/core/security/aes_vault.dart` (Encryption basics)
- [NEW] `api/` (Local Node.js environment setup with `serverless-offline`)
- **Infrastructure**: Localhost simulation for all endpoints.

### Phase 2: [US4] The Onboarding Experience (Constitution-Compliant)
Implement the full Registration & Data Verification flow as per US4 and FR-007.
- [MODIFY] `mobile/lib/features/auth/presentation/registration_screen.dart` (Add Age, Goals, Injuries, and Restrictions)
- [MODIFY] `mobile/lib/features/auth/presentation/verify_screen.dart` (Complete summary of all data)
- [MODIFY] `api/src/auth/register.ts` (Handle expanded user profile)
- **Security**: Encrypt injuries and medical data using `AesVault` before transmission.
- **Goal**: Capture complete profile (Biometrics + Goal + Health) and verify accuracy on a summary screen.

### Phase 3: [US1] The "Personal Coach" (Screen 2)
Implement the Routine Generation and Dashboard with strict Goal & Safety logic.
- [NEW] `mobile/lib/features/routines/presentation/routine_view.dart`
- [NEW] `api/src/routines/generate.ts` (Logic: Adjust exercises by Goal and exclude by Injuries)
- [MODIFY] `mobile/lib/features/auth/presentation/verify_screen.dart` (Add navigation to Dashboard)
- **Goal**: User transitions from registration to a personalized dashboard with routines that are verified as safe for their profile.

### Phase 4: [US2] The "Progress Tracker" (Screen 3)
Implement Progress Entry forms and Interactive Analytics with Consistency Tracking.
- [NEW] `mobile/lib/features/progress/presentation/add_entry_screen.dart` (Weight + Workout Logging)
- [NEW] `mobile/lib/features/progress/presentation/analytics_dashboard.dart` (Line Charts + Consistency Score)
- [MODIFY] `mobile/lib/main.dart` (Implement Bottom Navigation Shell for Flow)
- **Goal**: User can switch between Routine and Progress views, log completions, and see both weight and consistency metrics update.

### Phase 5: [US3] The "Nutritionist" (Screen 4)
Implement Nutritional Suggestions with Calorie/Macro calculation and Safety filtering.
- [NEW] `mobile/lib/features/nutrition/presentation/nutrition_view.dart`
- [NEW] `api/src/nutrition/suggest.ts` (Logic: Calorie/Macro calculation + Restriction/Allergy safety filtering)
- [MODIFY] `mobile/lib/main.dart` (Connect Nutrition View to Bottom Navigation)
- **Goal**: User receives tailored meal suggestions and macro targets that respect their captured health restrictions and fitness goals.

### Phase 6: On-Premise Verification & Cloud Prep
Final local integration, reliability tests, and preparation of AWS cloud templates.
- [NEW] `mobile/lib/core/sync/sync_manager.dart` (Simulated local sync)
- [NEW] `api/serverless.yml` (AWS definitions ready for later migration)
- **Visual**: Final "Healthy State" system architecture diagram.

## Verification Plan

### Local Verification
- **On-Premise Test**: Verify all endpoints return 200 OK from `localhost`.
- **Visual Verification**: Every UI phase MUST include a generated iPhone mockup to validate premium aesthetics and layout.
- **Phase 2-5 Tests**: Same as previous plan, but running against the local backend.
