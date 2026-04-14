# 🚀 Hazir — *bhai hazir hai!*

A Flutter-based service discovery and queue management app that connects **service consumers** with nearby **service providers** in real time.

---

## 📱 Overview

**Hazir** lets users find nearby local service shops (barbers, mechanics, karyana stores, etc.), view live queues, and join them remotely — all without leaving home. Service providers get a simple dashboard to manage their queue, walk-in customers, and shop profile.

---

## ✨ Features

### For Consumers
- 🗺️ **Map-based discovery** — Browse nearby service providers on an interactive map (powered by MapTiler)
- 📍 **Live location** — Auto-detect current location with GPS
- 🏪 **Shop profiles** — View shop name, owner, contact, services, and pricing
- 🔢 **Join queue remotely** — Pick a service and get a ticket number instantly
- 🧭 **Navigation** — Open Google Maps / Waze directions to any shop
- 📋 **My Bookings** — Track active bookings with queue position and estimated wait
- ❌ **Cancel booking** — Swipe to cancel and auto-reorder the queue

### For Providers
- 🟢 **Open/Closed toggle** — Control shop availability with one tap
- 📊 **Live queue management** — See real-time queue, start service, remove customers, call next
- 🚶 **Walk-in entry** — Add walk-in customers manually with service and price selection
- 🛍️ **Catalog / Shop profile** — Update shop name, description, location, category, and rate list
- 💈 **Rate list management** — Add, edit, and delete services with pricing

### Auth & Accounts
- 📧 Email/password sign up with **email verification**
- 🔑 Role-based login (Consumer vs Provider)
- 🔒 Password reset via email link
- 👤 Editable profile (name)

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Backend / Auth | Firebase Auth |
| Database | Cloud Firestore |
| Maps | flutter_map + MapTiler tiles |
| Geocoding | geocoding package |
| Location | geolocator package |
| Navigation | url_launcher (Google Maps / Waze / Apple Maps) |
| UI | Material Design 3 |

---

## 📂 Project Structure

```
lib/
├── main.dart                  # Entry point, auth routing
├── authentication/
│   ├── login.dart             # Login screen
│   └── sign_up.dart           # Sign up with email verification
├── consumer/
│   ├── consumer_screen.dart   # Map + category discovery
│   ├── customer_join_screen.dart  # Shop profile + join queue
│   ├── my_bookings.dart       # Active bookings list
│   ├── profile.dart           # Consumer profile
│   ├── settings.dart          # Logout, change password
│   └── help.dart              # Contact developers
├── provider/
│   ├── provider_screen.dart   # Tab container (Queue / Walk-in / Catalog)
│   ├── Queue_screen.dart      # Live queue management
│   ├── walkin_screen.dart     # Walk-in customer entry
│   ├── catalog_screen.dart    # Shop profile editor
│   ├── add_Service.dart       # Add/edit/remove services
│   └── map_screen.dart        # Location picker map
└── models/
    └── provider_model.dart    # ProviderData model
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.27.0`
- Dart SDK `>=3.6.0`
- A Firebase project with **Authentication** and **Firestore** enabled
- Android `minSdk = 23`

### Setup

1. **Clone the repo**
   ```bash
   git clone https://github.com/your-username/hazir.git
   cd hazir
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase configuration**
   - Add your `google-services.json` to `android/app/`
   - Make sure Firebase Auth (Email/Password) and Cloud Firestore are enabled in your Firebase console

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🗄️ Firestore Data Structure

### `userConsumer/{uid}`
```json
{
  "name": "string",
  "mail": "string",
  "contactNumber": "string",
  "isVerified": true,
  "location": { "latitude": 0.0, "longitude": 0.0 },
  "currentQueue": [
    {
      "bookingId": "string",
      "providerId": "string",
      "shopName": "string",
      "service": "string",
      "price": 0,
      "queuePosition": 1,
      "status": "Waiting | Serving | Completed",
      "joinedAt": "timestamp"
    }
  ]
}
```

### `userProvider/{uid}`
```json
{
  "name": "string",
  "ownerName": "string",
  "mail": "string",
  "contactNumber": "string",
  "description": "string",
  "shopType": "Barber | Karyana Store | Car Mechanic | ...",
  "status": "Open | Closed",
  "isVerified": true,
  "location": "GeoPoint",
  "rateList": [
    { "service": "Haircut", "price": 200 }
  ],
  "customers": [
    {
      "bookingId": "string",
      "uid": "string",
      "name": "string",
      "service": "string",
      "price": 0,
      "queuePosition": 1,
      "notes": "string",
      "prepaid": "Yes | No"
    }
  ]
}
```

---

## 🏪 Supported Shop Categories

- 🛒 Karyana Store
- 💈 Barber
- 🚗 Car Mechanic
- 🏍️ Bike Mechanic
- 🪵 Carpenter
- 🥩 Meat Shop
- etc etc

---



## 👨‍💻 Developers

| Name | Email |
|---|---|
| Abdullah Shafique | abdullahshafique1214@gmail.com |
| Abdullah Shahzad | abdullah.s7062@gmail.com |

---

## 📄 License

This project was developed as a semester project. All rights reserved.
