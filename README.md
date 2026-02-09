# 🧑‍🤝‍🧑 User Management App

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat-square&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=flat-square&logo=dart&logoColor=white)](https://dart.dev/)
[![BLoC](https://img.shields.io/badge/State--Management-BLoC%2FCubit-blue?style=flat-square)](https://bloclibrary.dev/)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-success?style=flat-square)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

A professional, feature-rich Flutter application demonstrating **Clean Architecture**, **MVVM**, and advanced state management with **BLoC/Cubit**.

## 📱 Visual Showcase

> [!NOTE]
> Add your app screenshots here! You can find a high-quality mockup placeholder in `assets/images/mockup.png`.

![App Mockup](assets/images/mockup.png)

## 📱 Features

- **Authentication**
  - Email and password login
  - Form validation
  - Secure token storage
  - Auto-login on app restart

- **User Management**
  - View paginated user list
  - Pull-to-refresh functionality
  - Infinite scroll pagination
  - View detailed user information
  - Edit user details

- **Error Handling**
  - Network error handling
  - User-friendly error messages
  - Retry mechanisms

## 🏗️ Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture with clear separation of concerns:

```
lib/
├── core/
│   ├── constants/        # App constants
│   ├── network/          # Dio client & exceptions
│   ├── storage/          # Local storage service
│   ├── utils/            # Utilities & validators
│   └── di/               # Dependency injection
├── data/
│   ├── models/           # Data models with JSON serialization
│   └── repositories/     # Repository implementations
├── domain/
│   ├── entities/         # Business entities
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Business logic use cases
└── presentation/
    ├── bloc/             # BLoC/Cubit state management
    ├── screens/          # UI screens
    └── widgets/          # Reusable widgets
```

## 🛠️ Technology Stack

- **Flutter SDK**: 3.2.0+
- **State Management**: BLoC/Cubit (flutter_bloc ^8.1.3)
- **Networking**: Dio ^5.4.0
- **Dependency Injection**: GetIt ^7.6.4
- **Local Storage**: SharedPreferences ^2.2.2
- **Immutability**: Equatable ^2.0.5

## 🔑 Key Implementation Details

### State Management
- Uses **BLoC/Cubit** pattern for predictable state management
- Separate cubits for different features (Auth, Users, UserDetail)
- Immutable states using Equatable

### Network Layer
- Dio client with interceptors for logging and token injection
- Centralized exception handling
- Type-safe API calls with proper error propagation

### Dependency Injection
- GetIt for service locator pattern
- Lazy singleton registration for repositories
- Factory registration for BLoCs/Cubits

### Repository Pattern
- Abstract repository interfaces in domain layer
- Concrete implementations in data layer
- Easy to mock for testing

## 📝 API Endpoints Used

**Base URL**: `https://reqres.in/api`

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/login` | POST | User authentication |
| `/users?page={page}` | GET | Get paginated users |
| `/users/{id}` | GET | Get user details |
| `/users/{id}` | PUT | Update user |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.2.0 or higher)
- Dart SDK (3.2.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd user_management_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🔐 Demo Credentials

Use these credentials to test the login functionality:

- **Email**: `eve.holt@reqres.in`
- **Password**: `cityslicka`

## 📱 Screens

### Login Screen
- Email and password input fields
- Real-time form validation
- Loading indicator during authentication
- Error message display
- Demo credentials helper

### Users List Screen
- Displays paginated list of users
- Pull-to-refresh functionality
- Infinite scroll for loading more users
- Smooth scrolling with loading indicators
- Navigation to user details
- Logout functionality

### User Detail Screen
- Displays complete user information
- Edit mode for updating user details
- Form validation for names
- Loading states during updates
- Success/error feedback

## 🎨 Reusable Widgets

- **CustomTextField**: Styled text input with validation
- **CustomButton**: Consistent button styling with loading states
- **UserCard**: User list item component
- **LoadingWidget**: Centered loading indicator
- **ErrorWidget**: Error display with retry functionality

## 📦 Project Structure Best Practices

1. **Clean Architecture**: Clear separation between layers
2. **SOLID Principles**: Single responsibility, dependency inversion
3. **DRY**: Reusable widgets and utilities
4. **Type Safety**: Strong typing throughout the codebase
5. **Error Handling**: Comprehensive exception handling
6. **Code Organization**: Logical folder structure

## 🧪 Testing Considerations

The architecture supports:
- Unit tests for use cases and repositories
- Widget tests for UI components
- Integration tests for complete flows
- Mock implementations via dependency injection

## 🔄 State Flow

```
User Action → BLoC/Cubit → Use Case → Repository → API
                ↓                                      ↓
           UI Update ← State ← Result ← Response ← Data
```

## 📊 Performance Optimizations

- Efficient list rendering with ListView.builder
- Hero animations for smooth transitions
- Debounced scroll events for pagination
- Lazy loading of user data
- Cached network responses
- Optimized rebuilds with BLoC

## 🔒 Security Features

- Secure token storage using SharedPreferences
- Automatic token injection in API requests
- Input validation and sanitization
- No sensitive data in logs (production mode)

## 🐛 Error Handling

The app handles various error scenarios:
- Network connectivity issues
- Server errors (400, 401, 403, 404, 500, etc.)
- Validation errors
- Timeout errors
- Cache failures

## 📈 Future Enhancements

- [ ] Unit and widget tests
- [ ] Dark mode support
- [ ] Localization/internationalization
- [ ] Offline mode with local database
- [ ] Advanced filtering and search
- [ ] User profile image upload
- [ ] Biometric authentication
- [ ] Push notifications

## 📄 License

This project is for educational and assessment purposes.

## 👨‍💻 Developer Notes

### Key Design Decisions

1. **MVVM over MVC**: Better separation of concerns and testability
2. **BLoC over Provider**: More predictable state management for complex flows
3. **Dio over http**: Better interceptor support and advanced features
4. **GetIt over inherited widget**: Cleaner dependency injection
5. **Repository pattern**: Easy to swap data sources

### Code Quality

- Consistent naming conventions
- Comprehensive documentation
- Type-safe implementations
- Null safety enabled
- Linting with flutter_lints

### Git Commit Strategy

- Feature-based commits
- Clear commit messages
- Logical progression of changes
- Separate commits for different layers

## 📞 Contact

For any questions or feedback regarding this assessment, please contact the development team.

---

**Built with ❤️ using Flutter**
