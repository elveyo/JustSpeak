# JustSpeak

Seminar paper for the course Software Development II

## Setup Instructions

Password for `.zip` files is `fit`

### Backend Setup

1. Extract `fit-build-2025-08-24-env`
2. Place the `.env` file into `\JustSpeak\backend`
3. Open `\JustSpeak\backend` in terminal and run: `docker compose up --build`

### Desktop Application Setup

1. Extract `fit-build-2025-08-24-desktop`
2. Run `justspeak_desktop.exe` from the "Release" folder
3. Login with admin credentials (see below)

### Mobile Application Setup

1. Uninstall the app from Android emulator if it already exists
2. Extract `fit-build-2025-08-24-mobile`
3. Drag the `.apk` file from "flutter-apk" folder to the emulator
4. Wait for installation to complete
5. Launch the app and login with credentials (see below)

## Testing Guide

### Main Testing Flow

The core functionality follows this flow: **Tutor creates schedule → Student books session → Both join and complete session**

#### Step 1: Tutor Creates Schedule (Mobile)

1. Login as tutor
2. Go to "Calendar" → "Add Schedule"
3. Select:
   - Date and time
   - **Duration: 1 minute** (for quick testing)
   - Language
   - Level
4. Save the schedule

#### Step 2: Student Books Session (Mobile)

1. Login as student (use different device/emulator or logout first)
2. Browse available sessions
3. Select a session from the tutor's schedule
4. Click "Book Session"
5. Complete payment with test card:
   - Card: `4242 4242 4242 4242`
   - Expiry: `12/34`
   - CVC: `123`
   - ZIP: `12345`

#### Step 3: Join and Complete Session

**Tutor:**
1. Go to "Calendar"
2. Find the booked session
3. Click "Start Session" to activate it
4. Click "Join Session"

**Student:**
1. Go to "My Sessions"
2. Click "Join Session" (enabled after tutor activates)
3. Video call starts

**During Session:**
- Test video/audio controls (mute, camera on/off)
- Wait for 1-minute timer to complete
- Or click "Leave Call" to exit manually

**After Session:**
- Both users can rate each other
- Leave reviews

### Additional Features to Test

**User Registration:**
- Click "Sign Up"
- Fill in username, email, password
- Complete onboarding (select role, languages, levels)

**User Profiles:**
- View tutor profiles (bio, languages, certificates, reviews)
- View student profiles (bio, learning progress, posts)

**Posts:**
- Create posts from "Add Post"
- View posts in feed and on profiles

**Certificates (Tutor):**
- Go to "Profile" → "Certificates" → "Add Certificate"
- Upload certificate

## Important Notes

- **Duration:** Set session duration to 1 minute for quick testing of the timer functionality
- New users won't have recommendations until they complete sessions
- Only session participants can leave reviews after session ends
- All notifications are sent via email through RabbitMQ
- Session participant count updates in real-time when users join/leave

## Credentials

**Mobile - Tutor:**
- Username: `test`
- Password: `Test123!`

**Mobile - Student:**
- Create a new account via registration, or use another test account if provided

**Desktop - Admin:**
- Username: `admin`
- Password: `Test123!`

**Stripe Test Card:**
- Card: `4242 4242 4242 4242`
- Expiry: `12/34`
- CVC: `123`
- ZIP: `12345`

## Technology Stack

- **Backend:** ASP.NET Core, SQL Server, RabbitMQ, Docker
- **Frontend:** Flutter (Mobile & Desktop)
- **Integrations:** Stripe (payments), Agora (video calls)

## RabbitMQ

RabbitMQ processes email notifications asynchronously for session events (booking, start, completion, cancellation).

Access management interface at `http://localhost:15672`