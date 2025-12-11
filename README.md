# JustSpeak

Seminar paper for the course Software Development II

## Setup Instructions

Password for `.zip` files is `fit`

### Backend Setup

1. Extract `fit-build-2025-12-07-env`
2. Place the `.env` file into `\JustSpeak\backend`
3. Open `\JustSpeak\backend` in terminal and run: `docker compose up --build`

### Desktop Application Setup

1. Extract `fit-build-2025-12-07-desktop`
2. Run `justspeak_desktop.exe` from the "Release" folder
3. Login with admin credentials (see below)

### Mobile Application Setup

1. Uninstall the app from Android emulator if it already exists
2. Extract `fit-build-2025-12-07-mobile`
3. Drag the `.apk` file from "flutter-apk" folder to the emulator
4. Wait for installation to complete
5. Launch the app and login with credentials (see below)

## Testing Guide

### Main Testing Flow

The core functionality follows this flow: **Tutor creates schedule → Student books session → Both join and complete session**

#### Step 1: Tutor Creates Schedule (Mobile)

1. Login as tutor
2. Go to "Calendar" → "Add Schedule"
3. **Important for testing:** Create a schedule for **TODAY** with duration of 1 minute
4. Add your Schedule

#### Step 2: Student Books Session (Mobile)

1. Login as student (use different device/emulator or logout first)
2. Browse Tutor you previously created schedule for
3. Select a session from the tutor's schedule
4. Click "Book Session"
5. Complete payment with test card

#### Step 3: Join and Complete Session

**Tutor:**
1. Go to "Calendar"
2. Find the booked session
3. Click "Start Session" to activate it
   - **Note:** Tutors can only start sessions scheduled for TODAY
4. Click "Join Session"

**Student:**
1. Go to "My Sessions"
2. Click "Join Session" (enabled after tutor activates)
3. Video call starts



**After Session:**
- Tutor can leave note for student.

- **Duration:** Set session duration to 1 minute for quick testing of the timer functionality

## Credentials

**Desktop - Admin:**
- Email: `admin@test.com`
- Password: `test123`

**Mobile - Tutor:**
- Email: `tutor@test.com`
- Password: `test123`

**Mobile - Student:**
- Email: `student@test.com`
- Password: `test123`

**Stripe Test Card:**
- Card: `4242 4242 4242 4242`
- Expiry: `12/34`
- CVC: `123`
- ZIP: `12345`

## Known Issues / Testing Limitations

### Audio/Video Testing
- **Sound/Audio functionality could not be fully tested via Android emulators** - Emulators have limitations with audio input/output, so video call audio features (microphone, speakers) may not work correctly in emulator environments.

## Technology Stack

- **Backend:** ASP.NET Core, SQL Server, RabbitMQ, Docker
- **Frontend:** Flutter (Mobile & Desktop)
- **Integrations:** Stripe (payments), Agora (video calls)


