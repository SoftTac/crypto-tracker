```markdown
# 💰 Crypto Tracker - Flutter

![Flutter](https://img.shields.io/badge/Flutter-3.16.9-%2302569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.2.1-%230175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-%23brightgreen)

A sleek cryptocurrency price tracker with real-time rates, platform-adaptive UI, and smooth animations.

| ![Home Screen](https://i.imgur.com/JqkX9zl.png) | ![Currency Picker](https://i.imgur.com/Vn4Wz9p.png) |
|-------------------------------------------------|----------------------------------------------------|

![Screenshot_20250427_144725](https://github.com/user-attachments/assets/ab3609bd-4b92-4b1b-b70a-03c7915952dd)

## ✨ Features
- **Real-time prices** for BTC, ETH, LTC, XRP, BNB
- **20+ fiat currencies** (USD, EUR, GBP, JPY, etc.)
- **iOS/Android optimized** (Cupertino/Material widgets)
- **Shimmer loading** effects
- **Auto-refresh** with error handling
- **Beautiful animations** using `flutter_animate`

## 🛠️ Tech Stack
- **Frontend**: Flutter (Dart)
- **API**: [CoinGecko](https://www.coingecko.com/en/api) (Free tier)
- **State Management**: Built-in `setState`
- **Key Packages**:
  - `http` for API calls
  - `shimmer` for loading effects
  - `flutter_animate` for animations
  - `connectivity_plus` for network checks

## 🚀 Quick Start
```bash
git clone https://github.com/your-username/crypto-tracker.git
cd crypto-tracker
flutter pub get
flutter run
```

## 📁 Project Structure
```
lib/
├── main.dart          # App entry point
├── price_screen.dart  # Main UI with currency picker
└── coin_data.dart     # API service & data processing
```

## 🌟 Roadmap
- [ ] Add price change percentages
- [ ] Portfolio tracking
- [ ] Push notifications for price alerts
- [ ] Dark/light theme toggle

## 🤝 How to Contribute
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/your-feature`)
5. Open a Pull Request

## 📜 License
MIT © 2023 [Your Name]  
See [LICENSE](LICENSE) for details.

---
🔗 **Live Demo**: [Coming Soon]  
⭐ **Like this project? Give it a star!**
```
   ```
