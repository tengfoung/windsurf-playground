#!/bin/bash

# Check if xcodegen is installed
if ! command -v xcodegen &> /dev/null; then
    echo "xcodegen not found. Installing via Homebrew..."
    brew install xcodegen
fi

# Generate Xcode project
echo "Generating Xcode project..."
xcodegen generate

# Install dependencies if needed
# Uncomment the following lines if you add dependencies via CocoaPods or Swift Package Manager
# echo "Installing dependencies..."
# pod install

echo "Setup complete! Open BOS.xcodeproj to get started."
