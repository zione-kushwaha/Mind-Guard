# 🛡️ MindGuard — AI-Powered PTSD Support & Mental Wellness App

> *"Healing is not linear. MindGuard walks every step with you."*

---

## 🧠 What is PTSD?

Post-Traumatic Stress Disorder (PTSD) is a serious mental health condition triggered by experiencing or witnessing a traumatic event. It affects **millions of people worldwide** and is one of the most underdiagnosed and undertreated mental health conditions.

### Key Statistics

- **~70%** of adults worldwide experience at least one traumatic event in their lifetime
- **~20%** of those who experience trauma develop PTSD
- **8 million** adults in the US alone are diagnosed with PTSD each year
- PTSD affects **veterans, abuse survivors, accident victims, first responders**, and anyone who has faced severe trauma
- Only **~50%** of people with PTSD ever seek treatment — largely due to stigma, lack of access, and unawareness
- Untreated PTSD leads to depression, substance abuse, relationship breakdown, and in severe cases, suicide

### Common PTSD Symptoms

- **Re-experiencing**: Flashbacks, nightmares, intrusive memories
- **Avoidance**: Staying away from people, places, or thoughts related to trauma
- **Hyperarousal**: Being easily startled, difficulty sleeping, irritability
- **Negative cognition**: Guilt, shame, emotional numbness, detachment
- **Dissociation**: Feeling disconnected from reality or one's own body

---

## 💡 The Problem We're Solving

Mental health support for PTSD is:

- **Expensive** — therapy sessions cost $100–$300/hour
- **Inaccessible** — long waitlists, limited therapists in rural areas
- **Stigmatized** — many people avoid seeking help due to social shame
- **Reactive** — most tools only help during a crisis, not proactively

**MindGuard bridges this gap** — providing a science-backed, always-available, private, and compassionate digital companion for PTSD recovery and daily mental wellness.

---

## 🚀 What is MindGuard?

**MindGuard** is a cross-platform Flutter mobile application designed to support individuals living with PTSD and anxiety. It combines evidence-based therapeutic techniques, binaural audio science, mindfulness practices, and smart self-assessment tools into one beautifully designed app.

Built during **USNepal Hackathon**, MindGuard is not just an app — it's a **mental wellness ecosystem** that empowers users to understand, manage, and heal from trauma at their own pace.

---

## ✨ Key Features

### 1. 🧪 PTSD Self-Assessment Tool

A clinically-inspired, multi-category assessment system that helps users understand their trauma profile.

- **5 Trauma Categories**: Abuse, Assault, War/Combat, Accident, Other
- **12 targeted questions** per category with validated scoring
- **4-tier risk scoring**: Low → Moderate → High → Severe
- Animated result visualization with personalized recommendations
- Immediate guidance on next steps based on severity level

### 2. 🌬️ Guided Breathing Exercises

Scientifically proven breathing techniques to activate the parasympathetic nervous system and reduce acute anxiety.

- **4 breathing patterns**: 4-7-8, Box Breathing (4-4-4-4), 5-5-5, and more
- Animated breathing circle with real-time inhale/hold/exhale guidance
- Customizable session duration (1–15 minutes)
- Breath count tracking per session

### 3. 🧘 Meditation & Mindfulness

A full-featured meditation suite with multiple categories and session types.

- **Guided Meditation**: Trauma Healing, Anxiety Relief, Sleep Preparation, Grounding
- **Body Scan**: Full Body Scan, Tension Release
- **Breathing Meditations**: Box Breathing, Calming Breath
- **Loving Kindness**: Self-Compassion, Forgiveness
- Built-in meditation timer (5–60 minutes)
- Progress tracking with streak counter

### 4. 🎵 Neural Beats (Binaural Audio Therapy)

Binaural beats are a scientifically studied auditory processing artifact that can help synchronize brainwaves to specific frequencies.

| Beat Type          | Frequency  | Benefit                             |
| ------------------ | ---------- | ----------------------------------- |
| Alpha Waves        | 8–12 Hz   | Relaxation, Focus, Creativity       |
| Beta Waves         | 12–30 Hz  | Alertness, Problem Solving          |
| Theta Waves        | 4–8 Hz    | Deep Meditation, Healing, Intuition |
| Delta Waves        | 0.5–4 Hz  | Deep Sleep, Recovery                |
| Gamma Waves        | 30–100 Hz | Peak Performance, Insight           |
| Schumann Resonance | 7.83 Hz    | Grounding, Natural Harmony          |

- Real-time volume control
- Animated wave visualizations while playing
- Loop mode for extended sessions

### 5. 🌊 Calming Sounds Library

A rich ambient soundscape library for relaxation, focus, and sleep.

- **Nature**: Gentle Rain, Ocean Waves, Forest Sounds, Gentle Wind, Distant Thunder
- **Meditation**: Tibetan Bowl, Om Chanting, Temple Bells
- **Focus**: White Noise, Brown Noise, Pink Noise
- **Cozy**: Fireplace, Coffee Shop, Library
- Custom sound mixing with individual volume sliders
- Favorites system and sleep timer (5 min – 2 hours)

### 6. 🌿 5-4-3-2-1 Grounding Exercise

A clinically recognized technique for managing dissociation and panic attacks by anchoring the user to the present moment through the five senses.

- Step-by-step guided walkthrough
- Animated progress indicators
- Completion celebration with reflection prompt
- Ideal for acute anxiety and flashback management

### 7. 🧘 Yoga & Movement Therapy

Trauma-informed yoga routines designed to reconnect the mind and body — a core component of somatic PTSD therapy.

- **Gentle Morning**: Mountain Pose, Cat-Cow, Child's Pose
- **Anxiety Relief**: Legs Up the Wall, Gentle Twist, Savasana
- **Evening Unwind**: Forward Fold, Supine Spinal Twist, Meditation
- Pose-by-pose timer with animated breathing guide
- Session completion tracking

### 8. 🎮 Mindful Games

Therapeutic games designed to engage the prefrontal cortex and reduce hyperarousal.

- **Breathing Exercise Game**: Visual breathing cues with gamification
- **Memory Garden**: Match flowers to improve focus and working memory
- **Mindful Coloring**: Color mandalas to practice present-moment awareness

### 9. 📓 Secure Encrypted Journal

A private, encrypted journaling space for emotional processing — a cornerstone of trauma therapy.

- Mood tagging with 8 emotional states (😊 Happy, 😢 Sad, 😰 Anxious, 😌 Calm, 😠 Angry, 🙏 Grateful, 🌟 Hopeful, 😐 Neutral)
- Therapeutic tag system: `#trigger`, `#progress`, `#therapy`, `#breakthrough`, `#coping`, and more
- Encrypted local storage via Hive + Flutter Secure Storage
- Mood analytics dashboard
- Staggered animation entry list

### 10. 🚨 Emergency Support System

A one-tap emergency response system for crisis moments.

- **Call 911** — direct emergency services dial
- **Crisis Hotline (988)** — National Suicide & Crisis Lifeline
- **Location Sharing** — GPS-based location sharing with trusted contacts
- Haptic feedback on activation
- Emergency Mode UI — entire app shifts to red alert theme
- Persistent emergency banner when active

### 11. 📊 Progress & Profile Dashboard

Track your healing journey with data-driven insights.

- Session streak counter
- Total sessions completed
- Progress percentage visualization
- Mood trend charts (fl_chart)
- Calendar-based activity tracking (table_calendar)
- Assessment history

---

## 🏗️ Architecture

MindGuard follows a clean, scalable **Feature-First Architecture** with **Riverpod** for state management.

```
lib/
├── main.dart                    # App entry point, Hive init, auth gate
├── app/
│   ├── router.dart              # Named route management
│   ├── model/                   # Data models (Assessment, Auth, Camera)
│   ├── data/                    # Static data & scoring logic
│   ├── provider/                # Riverpod providers (Auth, Camera)
│   ├── service/                 # API, Auth, Token, Storage services
│   └── view/                    # Auth screens, Assessment screens
├── core/
│   ├── theme/app_theme.dart     # Global Material theme
│   └── providers/app_providers.dart  # Global state providers
├── features/                    # Feature modules (self-contained)
│   ├── breathing/               # Breathing exercise
│   ├── meditation/              # Meditation & mindfulness
│   ├── grounding/               # 5-4-3-2-1 grounding
│   ├── journal/                 # Secure journal
│   ├── neural_beats/            # Binaural beats player
│   ├── sounds/                  # Calming sounds library
│   ├── yoga/                    # Yoga & movement
│   └── games/                   # Mind relaxation games
├── games/                       # Game implementations
│   ├── breathing_game.dart
│   ├── memory_game.dart
│   └── mindful_coloring.dart
├── home/
│   ├── presentation/view.dart   # Main home screen
│   └── widgets/                 # Reusable home widgets
│       ├── emergency_button.dart
│       ├── mood_check_widget.dart
│       ├── quick_access_bar.dart
│       └── welcome_header.dart
└── pages/
    ├── journal/journal_page.dart
    └── profile/profile_page.dart
```

---

## 🔄 Application Flow

```
App Launch
    │
    ▼
Hive Initialization (local encrypted DB)
    │
    ▼
Auth Check (Riverpod isAuthenticatedProvider)
    │
    ├── Not Authenticated ──► Login Screen ──► Register Screen
    │                                │
    │                                ▼
    │                         JWT Token Storage (Secure Storage)
    │
    └── Authenticated ──────► Home Screen (MindGuard Dashboard)
                                    │
                    ┌───────────────┼───────────────┐
                    ▼               ▼               ▼
               Home Tab        Journal Tab      Profile Tab
                    │
          ┌─────────┼──────────────────────────────┐
          ▼         ▼         ▼         ▼           ▼
    Assessment  Breathing  Meditation  Neural    Grounding
    (5 categories) Exercise  Sessions   Beats    5-4-3-2-1
          │
          ▼
    12 Questions
          │
          ▼
    Risk Scoring (0–48 pts)
          │
          ▼
    Results + Recommendations
          │
          ▼
    Therapeutic Tools (matched to risk level)
```

---

## 🛠️ Tech Stack

### Framework & Language

| Technology            | Purpose                                         |
| --------------------- | ----------------------------------------------- |
| **Flutter 3.x** | Cross-platform UI framework (iOS, Android, Web) |
| **Dart**        | Programming language                            |

### State Management

| Package                     | Purpose                   |
| --------------------------- | ------------------------- |
| `flutter_riverpod ^2.6.1` | Reactive state management |

### Audio & Sound

| Package                   | Purpose                                          |
| ------------------------- | ------------------------------------------------ |
| `audioplayers ^6.1.0`   | Sound playback for calming sounds & neural beats |
| `just_audio ^0.9.40`    | Advanced audio streaming                         |
| `flutter_tts ^4.1.0`    | Text-to-speech for guided meditation             |
| `speech_to_text ^7.0.0` | Voice journaling input                           |

### Storage & Security

| Package                            | Purpose                                     |
| ---------------------------------- | ------------------------------------------- |
| `hive ^2.2.3` + `hive_flutter` | Fast local NoSQL database                   |
| `flutter_secure_storage ^9.2.2`  | Encrypted key-value storage for tokens      |
| `shared_preferences ^2.2.2`      | Lightweight preferences                     |
| `crypto ^3.0.3`                  | Data hashing & encryption                   |
| `local_auth ^2.3.0`              | Biometric authentication (fingerprint/face) |

### UI & Animations

| Package                                 | Purpose                      |
| --------------------------------------- | ---------------------------- |
| `flutter_animate ^4.5.0`              | Declarative animations       |
| `lottie ^3.1.2`                       | Lottie JSON animations       |
| `rive ^0.13.13`                       | Interactive Rive animations  |
| `animated_text_kit ^4.2.3`            | Text animations (app title)  |
| `convex_bottom_bar ^3.2.0`            | Animated bottom navigation   |
| `flutter_staggered_animations ^1.1.1` | List/grid stagger animations |
| `shimmer ^3.0.0`                      | Loading skeleton shimmer     |
| `smooth_page_indicator ^1.2.0`        | Page indicator dots          |
| `wave ^0.2.2`                         | Wave animation widget        |
| `liquid_pull_to_refresh ^3.0.1`       | Liquid pull-to-refresh       |
| `spring ^2.0.2`                       | Spring physics animations    |
| `circular_countdown_timer ^0.2.4`     | Countdown timer widget       |
| `google_fonts ^6.2.1`                 | Google Fonts (Inter, etc.)   |
| `font_awesome_flutter ^10.8.0`        | FontAwesome icon set         |

### Data Visualization

| Package                   | Purpose                             |
| ------------------------- | ----------------------------------- |
| `fl_chart ^0.69.0`      | Mood trend charts & progress graphs |
| `table_calendar ^3.1.2` | Activity calendar                   |

### Device & Sensors

| Package                        | Purpose                                      |
| ------------------------------ | -------------------------------------------- |
| `sensors_plus ^6.0.1`        | Accelerometer/gyroscope (movement detection) |
| `vibration ^2.0.0`           | Haptic feedback for emergency alerts         |
| `camera ^0.10.6`             | Camera for word-reading & AR features        |
| `geolocator ^13.0.1`         | GPS for emergency location sharing           |
| `permission_handler ^11.3.1` | Runtime permissions                          |

### Network & Utilities

| Package                     | Purpose                               |
| --------------------------- | ------------------------------------- |
| `http ^1.2.2`             | REST API communication                |
| `url_launcher ^6.3.2`     | Launch phone calls (911, crisis line) |
| `intl ^0.19.0`            | Date/time formatting                  |
| `uuid ^4.5.1`             | Unique ID generation                  |
| `path_provider ^2.1.4`    | File system paths                     |
| `webview_flutter ^4.13.0` | In-app web content                    |

### Extended Features

| Package                              | Purpose                             |
| ------------------------------------ | ----------------------------------- |
| `ar_flutter_plugin_updated ^0.0.1` | Augmented Reality (premium feature) |

---

## 🔐 Security & Privacy

MindGuard takes user privacy extremely seriously — especially given the sensitive nature of mental health data.

- **All journal entries** are encrypted at rest using Hive + AES encryption
- **Authentication tokens** stored in platform-level secure enclave (Keychain/Keystore)
- **Biometric authentication** support (fingerprint/Face ID) for app access
- **No data leaves the device** without explicit user consent
- **Zero PII collection** by default — the app works fully offline
- **Crypto hashing** for any sensitive data comparisons

---

## 📱 Screens Overview

| Screen             | Description                                               |
| ------------------ | --------------------------------------------------------- |
| Login / Register   | JWT-based auth with secure token storage                  |
| Home Dashboard     | Hero section, stats, quick access, therapeutic tools grid |
| PTSD Assessment    | Category selection → 12 questions → animated results    |
| Breathing Exercise | Animated breathing circle with pattern selection          |
| Meditation         | 4-tab interface: Sessions, Programs, Progress, Timer      |
| Neural Beats       | 6-beat grid with live wave animations                     |
| Calming Sounds     | 4-tab: Sounds, Mix, Favorites, Sleep Timer                |
| Grounding Exercise | Step-by-step 5-4-3-2-1 with progress tracking             |
| Yoga & Movement    | Routine selection + live pose timer                       |
| Mindful Games      | Breathing game, Memory Garden, Mindful Coloring           |
| Secure Journal     | Encrypted entries with mood + tag system                  |
| Profile & Reports  | Progress charts, streak, calendar activity                |
| Emergency Panel    | One-tap 911, 988 crisis line, location share              |

---

## 🌍 Impact & Vision

### Why This Matters

- PTSD is a **global health crisis** affecting soldiers, abuse survivors, refugees, accident victims, and everyday people
- The **treatment gap** is enormous — most people never get help
- Mobile-first mental health tools have shown **clinically significant results** in multiple studies
- Apps like MindGuard can serve as a **bridge** between crisis and professional care

### What Makes MindGuard Different

- **Holistic approach** — not just one tool, but a complete ecosystem
- **Evidence-based** — every feature is grounded in clinical research (CBT, DBT, somatic therapy, binaural science)
- **Privacy-first** — no cloud dependency, no data harvesting
- **Beautiful UX** — mental health apps should feel calming, not clinical
- **Emergency-ready** — one-tap access to crisis resources at all times
- **Offline-capable** — works without internet, critical for users in crisis

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.8.1`
- Dart SDK `^3.8.1`
- Android Studio / Xcode
- Physical device recommended (for camera, biometrics, audio)

### Installation

```bash
# Clone the repository
git clone https://github.com/your-org/mindguard.git
cd mindguard

# Install dependencies
flutter pub get

# Run on device/emulator
flutter run
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## 📁 Assets

```
assets/
├── first/          # Onboarding & feature images
│   ├── 78.png
│   ├── ar.png
│   ├── game.png
│   ├── today.png
│   └── yoga.png
└── music/          # Ambient audio files
    ├── ocean.wav
    ├── rain.wav
    ├── temple_bells.wav
    ├── thunder.wav
    └── tibetan_bowl.wav
```

---

## 🧩 PTSD Assessment Scoring

| Score Range | Percentage | Risk Level  | Action                                      |
| ----------- | ---------- | ----------- | ------------------------------------------- |
| 0–19 pts   | 0–40%     | 🟢 Low      | Self-care, monitoring                       |
| 20–29 pts  | 40–60%    | 🟡 Moderate | Consider counseling, stress management      |
| 30–38 pts  | 60–80%    | 🟠 High     | Professional therapy recommended            |
| 39–48 pts  | 80–100%   | 🔴 Severe   | Immediate professional help, crisis support |

> ⚠️ **Disclaimer**: This assessment is a self-screening tool and is NOT a clinical diagnosis. Always consult a licensed mental health professional for proper evaluation and treatment.

---

## 🖥️ Backend — Django REST API

MindGuard is powered by a full **Django REST Framework** backend located in `Mindguard/backend/`. It handles authentication, AI-powered emotion detection, personalized story generation, and 3D AR model serving.

### Backend Structure

```
Mindguard/
├── backend/
│   ├── api/                        # Core app
│   │   ├── models.py               # DB models
│   │   ├── views.py                # API views
│   │   ├── serializers.py          # DRF serializers
│   │   ├── urls.py                 # API routes
│   │   ├── utils.py                # AI utilities (emotion + GPT)
│   │   ├── tokens.py               # Custom JWT tokens
│   │   ├── signals.py              # Auto-create UserProfile on register
│   │   └── migrations/
│   ├── backend/                    # Django project config
│   │   ├── settings.py
│   │   ├── urls.py
│   │   ├── wsgi.py
│   │   └── asgi.py
│   ├── media/
│   │   └── blender_models/         # 3D AR model files (.glb)
│   └── manage.py
├── requirements.txt
└── test_api.py
```

### API Endpoints

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| `POST` | `/api/login/` | JWT login (username or email) | ❌ |
| `POST` | `/auth/registration/` | Register new user | ❌ |
| `POST` | `/auth/token/refresh/` | Refresh JWT token | ❌ |
| `POST` | `/auth/logout/` | Logout & blacklist token | ✅ |
| `GET/PUT` | `/api/profile/` | Get or update user profile | ✅ |
| `POST` | `/api/detect/` | AI facial emotion detection | ✅ |
| `GET` | `/api/history/` | Emotion history (today/week/month) | ✅ |
| `GET` | `/api/today-story/` | AI-generated personalized daily story | ✅ |
| `GET` | `/api/blender-models/` | Fetch 3D AR model files | ✅ |
| `POST` | `/auth/google/` | Google OAuth2 social login | ❌ |
| `GET` | `/` | Swagger API documentation UI | ❌ |

### Key Backend Features

**🤖 AI Facial Emotion Detection**
- Uses HuggingFace `dima806/facial_emotions_image_detection` model
- Accepts camera frame uploads via `multipart/form-data`
- Returns dominant emotion + full probability scores for all 7 emotions
- Stores every detection in `EmotionRecord` with timestamp and session ID
- Supports filtering history by `today`, `week`, or `month`

**📖 AI-Powered Daily Story (Azure OpenAI GPT)**
- Reads user's bio and trauma type from their profile
- Calls Azure OpenAI GPT to generate a personalized, trauma-informed healing story
- Story is compassionate, under 250 words, focused on resilience and hope
- Regenerated fresh on every request and saved to `TodayStory` model

**🔐 Authentication System**
- JWT-based auth via `djangorestframework-simplejwt`
- Custom `MyTokenObtainPairSerializer` — supports login with **email or username**
- Custom JWT claims include `is_staff` and `is_superuser`
- Google OAuth2 social login via `django-allauth`
- Token rotation with blacklisting on refresh
- Access token lifetime: 3000 minutes (hackathon-friendly)

**👤 User Profile**
- Auto-created via Django signals on user registration
- Stores profile picture (auto-resized to 1080×1080), bio, and trauma category
- `Trauma` model links users to their specific PTSD trauma type

**🎮 3D AR Models**
- `BlenderModels` stores `.glb` files served via `/media/blender_models/`
- Used by the Flutter AR feature to load 3D objects in augmented reality

### Backend Tech Stack

| Technology | Purpose |
|------------|---------|
| **Django 5.2** | Web framework |
| **Django REST Framework** | REST API |
| **djangorestframework-simplejwt** | JWT authentication |
| **django-allauth** | Google OAuth2 social login |
| **dj-rest-auth** | Auth endpoints (login, register, logout) |
| **HuggingFace Transformers + PyTorch** | Facial emotion AI model |
| **Azure OpenAI (GPT)** | Personalized story generation |
| **Pillow** | Image processing for emotion detection |
| **django-resized** | Auto image resizing for profile pictures |
| **drf-yasg** | Swagger API documentation |
| **SQLite** | Database (dev) |
| **ngrok** | Tunnel for mobile app testing |

### Backend Setup

```bash
# Navigate to backend
cd Mindguard/backend

# Install dependencies
pip install -r ../requirements.txt

# Create .env file with Azure OpenAI credentials
# endpoint=https://your-endpoint.openai.azure.com/
# model_name=gpt-4
# deployment=your-deployment-name
# subscription_key=your-api-key
# api_version=2024-02-01

# Run migrations
python manage.py migrate

# Start server
python manage.py runserver

# For mobile testing with ngrok
ngrok http 8000
```

### Full Project Structure

```
DeerHack/
├── deerhack/                   # Flutter mobile app
│   ├── lib/                    # Dart source code
│   ├── assets/                 # Images & audio
│   ├── android/                # Android config
│   ├── ios/                    # iOS config
│   └── pubspec.yaml
└── Mindguard/                  # Backend
    ├── backend/                # Django project
    └── requirements.txt
```

---

## 🤝 Contributing

We welcome contributions from developers, mental health professionals, and UX designers.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-therapy-tool`)
3. Commit your changes (`git commit -m 'Add new grounding technique'`)
4. Push to the branch (`git push origin feature/new-therapy-tool`)
5. Open a Pull Request

---

## 📜 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 👥 Team Members

MindGuard was built by a passionate team at **USNepal Hackathon**:

| Name | Role |
|------|------|
| **Jeevan Kumar Kushwaha** | Full Stack Developer (Flutter + Django) |
| **Dipesh Acharya** | Backend Developer & AI Integration |
| **Kritam Bhattarai** | Flutter Developer & UI/UX |
| **Jenisha Shrestha** | Flutter Developer & Feature Design |

---

## 🙏 Acknowledgements

- National Institute of Mental Health (NIMH) for PTSD research data
- Veterans Affairs PTSD research programs
- The Flutter & Dart open-source community
- All mental health advocates who inspired this project

---

> *MindGuard was built with empathy, purpose, and the belief that everyone deserves access to mental health support — regardless of where they are or what they can afford.*

**Built with ❤️ at USNepal Hackathon**
