# 🔧 GreaseMonkey - Auto Shop Management iOS App

GreaseMonkey is a streamlined iOS application designed to help auto repair shops manage their vehicle repairs and service jobs efficiently. Built with Swift and using Realm for data persistence, it provides an intuitive interface for tracking vehicles, jobs, and deadlines.

## ✨ Features

### 🚗 Vehicle Management
- Track vehicles by registration number
- Record check-in and promised completion dates
- Store customer and contact information
- Add detailed notes for each vehicle

### 📋 Job Tracking
- Create and manage multiple jobs per vehicle
- Mark jobs as complete/incomplete
- Flag important or urgent jobs
- Track completion percentage per vehicle

### 🎨 Smart Status System
Color-coded status indicators for quick visual reference:
- 🟣 Purple: Vehicle ready for pickup (overdue)
- 🟢 Green: On track
- 🟡 Orange: Deadline approaching (≤2 days)
- 🔴 Red: Overdue
- ⚪ Grey: No promised date set

### 📱 User Interface
- Intuitive swipe actions for job management
- Search functionality for vehicles
- Custom date picker for easy date selection
- Support for both iPad and iPhone layouts
- Keyboard management optimization

## 🛠️ Technical Details

### 📚 Tech Stacks
- iOS 13.0+
- Xcode 11.0+
- Swift 5.0+

### 📦 Dependencies
- RealmSwift: Local database management
- Charts: Visual progress representation
- SwipeCellKit: Swipe gesture handling
- IQKeyboardManager: Keyboard interaction management

## 💻 Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/GreaseMonkey.git
```

2. Install dependencies via CocoaPods
```bash
cd GreaseMonkey
pod install
```

3. Open `GreaseMonkey.xcworkspace` in Xcode

4. Build and run the project

## 📊 Data Model

### 🚙 Car
- Registration number (rego)
- Check-in date
- Promised completion date
- Customer details
- Contact information
- Notes
- Associated jobs

### ⚡ Job
- Name/description
- Completion status
- Flag status
- Creation date
- Associated car reference

## 🧪 Testing

The project includes unit tests for core functionality:
- Date handling
- Status calculations
- Data persistence
- UI state management

Run tests in Xcode using `⌘U`

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details

## 🙏 Acknowledgments

- Built with ❤️ for auto repair professionals
- UI/UX inspired by real workshop feedback
- Special thanks to all contributors

---

For support, please open an issue in the repository. 💬 