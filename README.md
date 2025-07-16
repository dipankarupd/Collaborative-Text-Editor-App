# Collaborative Document Editor - Flutter Web Frontend

A real-time collaborative document editing Flutter web application built with modern architecture patterns and state management. This frontend provides a Google Docs-like experience with real-time collaboration capabilities.

## 🔗 Live Application & Backend

- **Live Application**: [https://collaborative-text-edito-92724.web.app/](https://collaborative-text-edito-92724.web.app/)
- **Backend Repository**: [Collaborative Text Editor Server](https://github.com/dipankarupd/Collaborative-Text-Editor-Server/blob/main/Readme.md)
- **Backend API**: [https://collaborative-text-editor-server-l8lp.onrender.com](https://collaborative-text-editor-server-l8lp.onrender.com)

## 📢 Current Status

**This is v1.0 of the application**. While the core functionality is working, there are minor bugs being actively fixed and new features being added regularly.

## 🚀 Upcoming Features

### High Priority (Coming Soon)
- **OAuth Google Login** - Seamless Google authentication
- **Document Sharing** - Share documents with friends via URL
- **Export Documents** - Download documents as Word/PDF files
- **Offline Support** - Ability to work while offline, and later update changes when online

### Future Features (Minor Priority)
- **AI Integration** - Text summarization and AI-assisted content writing
- **Voice Meetings** - Talk while editing documents together
- **Digital Whiteboard** - Interactive whiteboard for discussions

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Flutter Web Frontend                        │
├─────────────────────────────────────────────────────────────────┤
│  Presentation Layer (UI)                                        │
│  ├── Auth Pages (Login/Register)                                │
│  ├── Home Page (Document List)                                  │
│  └── Document Editor (Real-time Collaboration)                  │
├─────────────────────────────────────────────────────────────────┤
│  BLoC State Management                                          │
│  ├── AuthBloc (Authentication State)                            │
│  ├── DocumentBloc (Document Management)                         │
│  └── EditorBloc (Real-time Editing)                             │
├─────────────────────────────────────────────────────────────────┤
│  Domain Layer                                                   │
│  ├── Entities (User, Document, etc.)                            │
│  ├── Use Cases (Login, CreateDocument, etc.)                    │
│  └── Repository Interfaces                                      │
├─────────────────────────────────────────────────────────────────┤
│  Data Layer                                                     │
│  ├── Repository Implementations                                 │
│  ├── Data Sources (Remote API, Local Storage)                   │
│  └── Models (JSON Serialization)                                │
├─────────────────────────────────────────────────────────────────┤
│  External Dependencies                                          │
│  ├── Dio HTTP Client (with Auto-refresh Interceptor)           │
│  ├── WebSocket Channel (Real-time Communication)               │
│  ├── Shared Preferences (Token Storage)                        │
│  └── Flutter Quill (Rich Text Editor)                          │
└─────────────────────────────────────────────────────────────────┘
```

## 🛠️ Tech Stack & Architecture

### Core Architecture
- **Clean Architecture** - Separation of concerns with clear layers
- **SOLID Principles** - Maintainable and scalable code structure
- **Feature-Based Development** - Modular code organization
- **Dependency Injection** - GetIt for service location

### State Management
- **BLoC Pattern** - Reactive state management
- **Stream-based** - Real-time updates and events

### Networking & Data
- **Dio HTTP Client** - REST API communication
- **Auto-refresh Interceptor** - Automatic token refresh on expiry
- **WebSocket Channel** - Real-time collaborative editing
- **Shared Preferences** - Local token storage
- **JSON Serialization** - Type-safe data models

### UI & Editor
- **Flutter Web** - Cross-platform web application
- **Flutter Quill** - Rich text editor with Delta operations
- **Responsive Design** - Works on desktop and mobile browsers

### Development Tools
- **Logger** - Request/response logging
- **Proper Abstractions** - Interface-based development

## 📱 Application Routes

```dart
class AppRoutes {
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const home = '/home';
  static String documentWithId(String id) => '/document/$id';
}
```

## 🔐 Authentication Flow

```
1. User opens app → Check for stored tokens
2. No tokens → Show login/register screen
3. User authenticates → Store tokens in SharedPreferences
4. Access token expires → Dio interceptor auto-refreshes
5. User logs out → Clear tokens from storage
```

## 🔄 Real-time Collaboration Flow

```
1. User opens document → Establish WebSocket connection
2. User types → Generate Quill Delta operations
3. Send Delta to server → Broadcast to other clients
4. Receive Delta from others → Apply to local editor
5. Auto-save every 2 seconds → Persist to backend
```

## 🔧 Key Features Implementation

1. Automatic Token Refresh
2. Real-time WebSocket Integration
3. BLoC State Management
4. Clean Architecture Repository Pattern

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Web browser (Chrome, Firefox, Safari, Edge)
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/dipankarupd/Collaborative-Text-Editor-App.git
cd app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure environment**
Create `lib/core/constants/app_constants.dart`:
```dart
class AppConstants {
  static const String baseUrl = 'https://collaborative-text-editor-server-l8lp.onrender.com';
  static const String wsUrl = 'wss://collaborative-text-editor-server-l8lp.onrender.com';
  
  // For local development
  // static const String baseUrl = 'http://localhost:8080';
  // static const String wsUrl = 'ws://localhost:8080';
}
```

4. **Run the application**
```bash
flutter run -d chrome
```

The application will open in your default web browser at `http://localhost:3000`

## 🚀 Building for Production

### Web Build
```bash
flutter build web --release
```

### Firebase Hosting Deployment
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase project
firebase init hosting

# Deploy to Firebase
firebase deploy
```


## 📊 Performance Considerations

### Optimization Techniques
- **Lazy Loading** - Load documents on demand
- **Connection Pooling** - Reuse HTTP connections
- **State Caching** - Cache frequently accessed data
- **WebSocket Management** - Proper connection lifecycle
- **Memory Management** - Dispose of unused resources


## 🔧 Common Issues & Solutions

### CORS Issues
- Ensure backend has proper CORS configuration
- Check network requests in browser DevTools

### WebSocket Connection Problems
- Verify WebSocket URL format
- Check if document ID is valid
- Ensure proper token authentication

### Token Refresh Issues
- Check interceptor implementation
- Verify refresh token storage
- Monitor network requests

### Editor Sync Issues
- Ensure Delta operations are properly formatted
- Check WebSocket message handling
- Verify document state management

## 📱 Browser Compatibility

| Browser | Support | Notes |
|---------|---------|-------|
| Chrome | ✅ Full | Recommended for development |
| Firefox | ✅ Full | Good performance |
| Safari | ✅ Full | Some WebSocket quirks |
| Edge | ✅ Full | Chromium-based |

## 🤝 Contributing

### Development Guidelines
1. Follow Clean Architecture principles
2. Write tests for new features
3. Use BLoC for state management
4. Implement proper error handling
5. Add logging for debugging
6. Update documentation

### Code Style
- Follow feature-based clean Architecture
- Follow Dart/Flutter conventions
- Use meaningful variable names
- Add proper documentation


### Pull Request Process
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📊 Application Flow

### Authentication Flow
```
App Start → Check Local Tokens → Valid? → Home Page
    ↓              ↓                ↓
Login Page → API Call → Store Tokens → Home Page
```

### Document Editing Flow
```
Home Page → Select Document → Connect WebSocket → Editor Page
    ↓              ↓                ↓               ↓
Load Documents → API Call → Real-time Updates → Save Changes
```

## 🔒 Security Considerations

- **Token Security** - Secure storage in SharedPreferences
- **WebSocket Security** - Authenticated connections only
- **Input Validation** - Sanitize user inputs
- **HTTPS Only** - Secure communication
- **Auto-logout** - Clear sensitive data on logout

## 🐛 Known Issues (v1.0)

- Minor UI glitches on mobile browsers
- Occasional WebSocket reconnection needed
- Document loading performance with large documents
- Limited offline capabilities

## 📈 Analytics & Monitoring

- **Performance Monitoring** - Track app performance
- **Error Tracking** - Monitor and fix crashes
- **User Analytics** - Understand user behavior
- **Real-time Metrics** - WebSocket connection health

## 🔄 Future Improvements

### Technical Debt
- Implement proper offline support
- Add comprehensive error boundaries
- Optimize for mobile browsers
- Add progressive web app features

### New Features
- Comments and suggestions
- Version history
- Advanced formatting options
- Document templates

## 📞 Support & Resources

- **Documentation** - This README and code comments
- **Issues** - GitHub Issues for bug reports
- **Discussions** - GitHub Discussions for questions
- **Backend API** - [API Documentation](https://github.com/dipankarupd/Collaborative-Text-Editor-Server/blob/main/Readme.md)


**Built with ❤️ using Flutter Web & Clean Architecture**

**Happy Coding! 🚀**