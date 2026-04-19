# Quickstart: Another fitness app Foundation

## Local Development Setup

### 1. Mobile (Flutter)
- Ensure Flutter 3.x is installed: `flutter doctor`
- Navigate to `mobile/` directory.
- Install dependencies: `flutter pub get`
- Generate database code: `flutter pub run build_runner build`
- Run the app: `flutter run`

### 2. Backend (Serverless)
- Navigate to `api/` directory.
- Install dependencies: `npm install`
- Configure environment variables in `.env` (refer to `.env.example`).
- Deploy locally for testing: `npm run dev`

### 3. Security
- Use the provided script in `api/scripts/gen_ecc_test_keys.js` to generate a test key pair.
- Copy the public key to the API environment and the private key to the mobile's secure storage.

## Project Workflow
1. **Spec-First**: Always update `specs/` before changing requirements.
2. **Contract-Driven**: Changes to API must be reflected in `contracts/api-v1.yaml` first.
3. **Modular Implementation**: Implement features step-by-step using the Feature-by-Layer structure.
