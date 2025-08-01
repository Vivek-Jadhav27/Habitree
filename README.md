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
┣ core/                  # Routes, mock data, constants
┣ data/
┃ ┣ models/              # Habit, Tree, User models
┃ ┣ services/            # Firebase services (Auth, Firestore)
┣ presentation/
┃ ┣ painters/            # Custom painters (tree, forest)
┃ ┣ screens/             # Screens (login, signup, home, forest, wizard)
┃ ┣ widgets/             # UI components
┣ providers/             # State management (habit, auth, forest providers)
┣ firebase_options.dart  # Firebase configuration
┣ main.dart              # Entry point of the app

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
2. Create a feature branch  
3. Commit your changes  
4. Open a Pull Request

### Demo



https://github.com/user-attachments/assets/2ffca67f-848a-4242-a9b0-44e605cfe931

