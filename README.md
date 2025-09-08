# BOS - Business Operating System

A modern iOS application built with SwiftUI following the MVVM architecture pattern.

## Features

- **Splash Screen**: Beautiful launch screen with app branding
- **Tab-Based Navigation**: Easy access to all main features
- **Insights**: View and manage business insights with pull-to-refresh
- **Mock API**: Fully functional mock networking layer for development
- **Dependency Injection**: Clean architecture with dependency injection

## Requirements

- macOS 12.0+ (for development)
- Xcode 13.0+
- Swift 5.5+
- iOS 15.0+ (deployment target)

## Project Structure

```
BOS/
├── BOS/
│   ├── Models/          # Data models
│   ├── Services/        # Networking and business logic
│   ├── ViewModels/      # ViewModels for the MVVM pattern
│   ├── Views/           # SwiftUI views
│   │   ├── MainTabView.swift
│   │   ├── SplashView.swift
│   │   ├── HomeView.swift
│   │   ├── WatchlistsView.swift
│   │   ├── TradeView.swift
│   │   ├── InsightsView.swift
│   │   └── MoreView.swift
│   ├── Resources/       # Assets, colors, and other resources
│   ├── BOSApp.swift     # App entry point
│   └── Info.plist       # App configuration
├── project.yml          # XcodeGen configuration
└── setup.sh             # Project setup script
```

## Getting Started

### Prerequisites

1. Install Xcode 13.0 or later from the Mac App Store
2. Install Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```
3. Install Homebrew (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
4. Install XcodeGen:
   ```bash
   brew install xcodegen
   ```

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd BOS
   ```

2. Generate the Xcode project:
   ```bash
   ./setup.sh
   ```
   This will:
   - Generate the Xcode project using XcodeGen
   - Set up the workspace

3. Open the project in Xcode:
   ```bash
   open BOS.xcodeproj
   ```
   Or open the workspace if you have additional dependencies:
   ```bash
   open BOS.xcworkspace
   ```

4. Build and run the project (⌘R)

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Represent the data and business logic
- **Views**: SwiftUI views that display the UI
- **ViewModels**: Handle the presentation logic and state management
- **Services**: Handle networking and other external dependencies

### Dependency Injection

The app uses a simple dependency injection system to provide services to view models:

```swift
// Example of injecting a service
class MyViewModel: ObservableObject {
    private let service: MyService
    
    init(service: MyService = DependencyContainer.shared.myService) {
        self.service = service
    }
}
```

## Features

### Splash Screen
- Displays the app logo and name
- Automatically transitions to the main app after 2 seconds

### Main Navigation
- Tab-based navigation with 5 main sections:
  1. **Home**: Dashboard view
  2. **Watchlists**: Track items of interest
  3. **Trade**: Trading interface
  4. **Insights**: Data-driven insights (default tab)
  5. **More**: Additional options and settings

### Insights
- Displays a list of business insights
- Pull-to-refresh functionality
- Error handling and loading states
- Mock data for development

## Running and Testing the Application

### Running the App

1. **Using Xcode**:
   - Open `BOS.xcodeproj` in Xcode
   - Select a simulator or connect a physical device
   - Press `⌘ + R` to build and run the application

2. **Using Command Line**:
   ```bash
   # Build the project
   xcodebuild -project BOS.xcodeproj -scheme BOS -destination 'platform=iOS Simulator,name=iPhone 15' build
   
   # Run the tests
   xcodebuild -project BOS.xcodeproj -scheme BOS -destination 'platform=iOS Simulator,name=iPhone 15' test
   ```

### Testing the Application

1. **Unit Tests**:
   - Open the project in Xcode
   - Press `⌘ + U` to run all unit tests
   - Or use the Test Navigator (⌘ + 6) to run specific test cases

2. **UI Testing**:
   - The project includes UI test targets
   - Run UI tests from the Test Navigator in Xcode
   - Or use the command line:
     ```bash
     xcodebuild -project BOS.xcodeproj -scheme BOS -destination 'platform=iOS Simulator,name=iPhone 15' test-without-building
     ```

3. **Manual Testing**:
   - **Splash Screen**: Should display for 2 seconds before transitioning to the main app
   - **Tab Navigation**: Verify all 5 tabs are accessible and display their respective views
   - **Insights Tab**: Should load and display sample insights with pull-to-refresh functionality
   - **Error Handling**: Test error states by modifying the mock service to return errors

## Development

### Adding New Features
1. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Make your changes following the MVVM pattern
3. Add tests for your changes
4. Commit and push your changes
5. Create a pull request

### Running Tests
To run tests in Xcode:
1. Press `⌘ + U` to run all tests
2. Or select `Product` > `Test` from the menu

## Dependencies

- **XcodeGen**: For generating Xcode project files
- **SwiftUI**: For building the user interface
- **Combine**: For reactive programming

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
