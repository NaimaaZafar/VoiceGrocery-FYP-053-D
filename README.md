# Voice Grocery App

A grocery shopping app with voice recognition capabilities.

## Environment Setup

1. Create a `.env` file in the root directory of the project
2. Add your OpenAI API key to this file:

```
OPENAI_API_KEY=your_openai_api_key_here
```

Replace `your_openai_api_key_here` with your actual OpenAI API key.

## Voice Recognition Features

The app supports the following voice commands:

- **Add to Cart**: "Add apples to my cart", "I want to buy bananas"
- **Search Items**: "Show me tomatoes", "Find milk"
- **Go to Cart**: "Go to my cart", "Show my basket"
- **Remove from Cart**: "Remove tomatoes from my cart", "Delete apples from cart"

## Getting Started

1. Install dependencies: `flutter pub get`
2. Add your OpenAI API key to the `.env` file
3. Run the app: `flutter run`

## Note

This app supports voice recognition in multiple languages, including English and Urdu.

## Voice Grocery

- Java SDK-17
- Flutter
- Dart
- Android Studio

Note:

- Make sure to downgrade sdk to 17 using command `flutter config --jdk-dir "C:\Program Files\Java\jdk-17"` in terminal before that make sure jdk-17 is installed. https://download.oracle.com/java/17/archive/jdk-17.0.12_windows-x64_bin.exe
- Restart your android studio.
- Run command `flutter clean'
- Run command 'flutter update'

Bugs:

- Duplication in the favourite list ==> Done
- The heart on the is not staying ==> Done
- Uploading images to the database as hash64 ==> Done
- Payment Card ==> Done
- Buy now buf ==> Done
- Cart item count update ==> Done
- Heart in database for Fav ==> Done
