# Data Model: Another fitness app

## Overview
The data model is designed for a Local-First experience with strong encryption and business rule enforcement (e.g., entry limits).

## Entities

### User
| Field | Type | Description |
|-------|------|-------------|
| id | UUID | Primary key. |
| email | String | Unique identifier. |
| created_at | DateTime | Account creation timestamp. |
| verified_at | DateTime? | Timestamp of initial data verification. |

### UserProfile
| Field | Type | Description |
|-------|------|-------------|
| user_id | UUID | Foreign key to User. |
| age | Int | Range 18-35. |
| height_cm | Float | User height. |
| current_weight_kg | Float | Latest biometric weight. |
| fitness_goal | Enum | [WEIGHT_LOSS, MUSCLE_GAIN, ENDURANCE, FLEXIBILITY]. |
| medical_conditions | List<String> | Injuries or health warnings. |
| dietary_restrictions | List<String> | Allergies or preferences (e.g., VEGAN, NO_PEANUTS). |

### BiometricSnapshot (Verified)
*Created on-demand after verification screen. Required for Generation.*
| Field | Type | Description |
|-------|------|-------------|
| id | UUID | |
| user_id | UUID | |
| weight | Float | |
| captured_at | DateTime | |
| is_verified | Boolean | MUST be True for generation. |

### ProgressEntry
*Enforced limit: 10 per month.*
| Field | Type | Description |
|-------|------|-------------|
| id | UUID | |
| user_id | UUID | |
| metric_type | Enum | [BIOMETRIC_MEASUREMENT, CONSISTENCY_LOG]. |
| value | JSON | Value of the measurement (e.g., { "waist_cm": 85 }). |
| recorded_at | DateTime | |

### FitnessRoutine
| Field | Type | Description |
|-------|------|-------------|
| id | UUID | |
| user_id | UUID | |
| snapshot_id | UUID | Biometric snapshot used for generation. |
| exercises | List<Exercise> | |
| generated_at | DateTime | |
| expires_at | DateTime | generated_at + 14 days. |

## Relationships
- A **User** has one **UserProfile**.
- A **User** has many **ProgressEntries** (Max 10 per calendar month).
- A **User** has many **FitnessRoutines** (One active per bi-weekly cycle).
- A **FitnessRoutine** belongs to a **BiometricSnapshot**.

## Validation Rules
1. **Rule-EntryLimit**: Before saving a `ProgressEntry`, query the count of entries for the current `user_id` where `recorded_at` is in the same month. Block if count >= 10.
2. **Rule-VerifiedGen**: Generation services MUST NOT accept requests if the latest `BiometricSnapshot` has `is_verified == false`.
3. **Rule-DietaryExclusion**: Nutritional suggestions MUST be filtered against `UserProfile.dietary_restrictions` before being returned to the user.
