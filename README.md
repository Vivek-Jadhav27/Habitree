# 🌱 Habitree  

Habitree is a Flutter application that helps users **build and track daily habits** while growing their own **virtual forest** 🌳.  
Every habit completed contributes to the growth of trees, making self‑improvement both fun and visually rewarding.  

---

## ✨ Features
- 📋 **Habit Wizard** – Add up to 3 habits when you first join.  
- ✅ **Habit Tracking** – Mark habits as completed and see your progress.  
- 🌳 **Virtual Forest** – Watch your forest grow as you stay consistent.  
- 🔑 **Authentication** – Secure sign‑in & sign‑up with Firebase Auth.  
- ☁️ **Cloud Sync** – Habits and progress stored with Firestore.  
- 🎨 **Custom Tree Painter** – Beautiful animations for your growing trees.  

---

## 📂 Project Structure
```plaintext
lib/
└──core/                  # Routes, mock data, constants
└──data/
   ├── models/              # Habit, Tree, User models
   ├── services/            # Firebase services (Auth, Firestore)
└── presentation/
   ├── painters/            # Custom painters (tree, forest)
   ├── screens/             # Screens (login, signup, home, forest, wizard)
   ├── widgets/             # UI components
└── providers/             # State management (habit, auth, forest providers)
└──firebase_options.dart  # Firebase configuration
└──main.dart              # Entry point of the app

```

## 🗄️ Firestore Database Structure

The app uses **Cloud Firestore** to manage users, habits, daily progress, and the virtual garden.  

---

### 📌 Collections & Documents

```plaintext
users (collection)
 └── {uid} (document)
      ├── email: string
      ├── name: string
      ├── habits: array[string]        # List of habit titles
      ├── lastCompletedDate: timestamp # Last habit completion
      ├── longestStreak: number        # Longest streak achieved
      ├── streak: number               # Current streak
      └── uid: string                  # Firebase Auth UID

      ├── dailyProgress (subcollection)
      │    └── {date} (document e.g. 2025-07-25)
      │         ├── completedList: array[bool] # Which habits completed
      │         ├── completedTasks: number     # Count of completed habits
      │         ├── date: string               # YYYY-MM-DD
      │         └── rewarded: bool             # Whether reward given

      └── garden (subcollection)
           └── {treeId} (document)
                ├── speciesId: number          # Reference to species
                ├── stage: number              # Growth stage
                ├── plantedDate: timestamp     # When tree planted
                ├── lastGrownDate: timestamp   # Last growth update
                ├── x: number                  # Position in forest (X)
                └── y: number                  # Position in forest (Y)
```

```plaintext
species (collection)
 └── {speciesId} (document)
      ├── id: number
      ├── name: string                   # Tree name (e.g., Oak Tree)
      ├── stages: number                 # Total growth stages
      └── stageRenderParams: array[map]  # Rendering parameters for CustomPainter
```

##🚀 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/Vivek-Jadhav27/Habitree.git
cd Habitree
```
### 2. Install Dependencies
```bash
flutter pub get
```

## 🔥 Firebase Setup (Required)

Since Firebase files are **not included** in the repo (for security reasons), you need to add them yourself.

---

### 🔹 Android Setup
1. Go to [Firebase Console](https://console.firebase.google.com/) → Create a new project.  
2. Add your **Android app** (package name must match `applicationId` in `android/app/build.gradle`).  
3. Download `google-services.json`.  
4. Place it inside:  
   ```plaintext
   android/app/google-services.json
   ```

### 🔹 iOS Setup
1. In Firebase Console → Add **iOS app** (bundle ID must match your Xcode project settings).  
2. Download the file: `GoogleService-Info.plist`.  
3. Place it inside your project at:  
   ```plaintext
   ios/Runner/GoogleService-Info.plist

### 🔹 FlutterFire CLI (Generates `firebase_options.dart`)

Run the following commands:  
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This will create:

```plaintext
lib/firebase_options.dart
```

### 3. Run the App
```bash
flutter run
```
## 🛠️ Tech Stack

- **Flutter** – Cross‑platform mobile app  
- **Firebase Auth** – User authentication  
- **Firestore** – Cloud database  
- **Provider** – State management  
- **CustomPainter** – Tree/forest visualization  

---

## 🤝 Contribution

Contributions are welcome!

1. Fork the repo
2. Create a branch: ```bash git checkout -b feature/your-feature ```
3. Commit changes: ```bash git commit -m "Add feature" ```
4. Push: ```bash git push origin feature/your-feature ```
5. Open a Pull Request 🚀

### Demo


https://github.com/user-attachments/assets/289f8c05-141d-454a-a1b8-7980c31e26c0


