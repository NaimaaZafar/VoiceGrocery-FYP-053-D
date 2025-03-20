import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;

class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  final FlutterTts _flutterTts = FlutterTts();
  String _currentLanguage = 'en-US'; // Default language
  bool _isSpeaking = false;

  // Factory constructor
  factory TextToSpeechService() {
    return _instance;
  }

  // Private constructor
  TextToSpeechService._internal() {
    _initTts();
  }

  // Initialize TTS settings
  Future<void> _initTts() async {
    try {
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setSpeechRate(0.45); // Slower for better clarity
      await _flutterTts.setPitch(1.0);
      
      // Add a small pause between sentences for better clarity
      await _flutterTts.setSilence(300); // 300ms pause
      
      // Basic iOS settings 
      if (Platform.isIOS) {
        await _flutterTts.setSharedInstance(true);
        // Skip the problematic iOS audio category setting for now
      }
      
      // Setup completion listener
      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
      });
      
      // Setup error listener
      _flutterTts.setErrorHandler((error) {
        _isSpeaking = false;
        print("TTS Error: $error");
      });
      
      // Log available languages for debugging
      final languages = await _flutterTts.getLanguages;
      print("Available TTS languages: $languages");
      
    } catch (e) {
      print("Error initializing TTS: $e");
    }
  }
  
  // Helper to detect iOS platform
  bool isIOS() {
    return Platform.isIOS;
  }

  // Get available languages
  Future<List<String>> getAvailableLanguages() async {
    final languages = await _flutterTts.getLanguages;
    return languages.cast<String>();
  }

  // Set language based on detected language code
  Future<void> setLanguage(String languageCode) async {
    String langTag;
    
    switch (languageCode.toLowerCase()) {
      case 'ur':
        langTag = 'hi-IN'; // Use Hindi for Urdu (they're similar)
        break;
      case 'hi':
        langTag = 'hi-IN'; // Hindi
        break;
      case 'pa':
        langTag = 'pa-IN'; // Punjabi
        break;
      case 'en':
      default:
        langTag = 'en-US'; // Default to US English
        break;
    }
    
    // Check if language is available
    final languages = await _flutterTts.getLanguages;
    
    if (languages.contains(langTag)) {
      _currentLanguage = langTag;
      await _flutterTts.setLanguage(langTag);
    } else {
      // Fallback to English if the language is not supported
      _currentLanguage = 'en-US';
      await _flutterTts.setLanguage('en-US');
    }
  }

  // Speak text in current language
  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    
    // Don't interrupt ongoing speech unless really necessary
    if (_isSpeaking) {
      await stop();
      // Small delay to ensure previous speech has stopped
      await Future.delayed(const Duration(milliseconds: 300));
    }
    
    _isSpeaking = true;
    await _flutterTts.speak(text);
  }
  
  // Speak text with specific language
  Future<void> speakWithLanguage(String text, String languageCode) async {
    if (text.isEmpty) return;
    
    try {
      // Log for debugging
      print("Speaking in language: $languageCode, Text: $text");
      
      // Get available languages
      final languages = await _flutterTts.getLanguages;
      print("Available languages: $languages");
      
      // Initialize with a default value
      String mappedLanguageCode = 'en-US';
      
      if (languageCode.toLowerCase() == 'ur') {
        // For Urdu, always use Hindi as they're similar languages
        final hindiCodes = ['hi-IN', 'hi_IN', 'hi'];
        bool hindiAvailable = false;
        
        // Try to find any Hindi variant
        for (final code in hindiCodes) {
          if (languages.contains(code)) {
            mappedLanguageCode = code;
            hindiAvailable = true;
            print("Using Hindi for Urdu: $code");
            break;
          }
        }
        
        // If Hindi not available, fallback to English
        if (!hindiAvailable) {
          print("Hindi not available for Urdu, using English");
        }
      } else if (languageCode.toLowerCase() == 'hi') {
        // For Hindi
        final hindiCodes = ['hi-IN', 'hi_IN', 'hi'];
        bool hindiFound = false;
        
        for (final code in hindiCodes) {
          if (languages.contains(code)) {
            mappedLanguageCode = code;
            hindiFound = true;
            print("Found Hindi language code: $code");
            break;
          }
        }
        
        if (!hindiFound) {
          print("Hindi not available, using English");
          // mappedLanguageCode is already set to 'en-US' by default
        }
      } else if (languageCode.toLowerCase() == 'en') {
        mappedLanguageCode = 'en-US';
      } else {
        // For other languages, try the provided code if it exists in available languages
        if (languages.contains(languageCode)) {
          mappedLanguageCode = languageCode;
        } else {
          print("Language $languageCode not available, using English");
        }
      }
      
      // Set the language directly
      print("Setting language to: $mappedLanguageCode");
      await _flutterTts.setLanguage(mappedLanguageCode);
      
      // Adjust speech rate for non-English languages
      if (mappedLanguageCode != 'en-US') {
        await _flutterTts.setSpeechRate(0.4); // Slower for better comprehension
      } else {
        await _flutterTts.setSpeechRate(0.45); // Default English rate
      }
      
      // Then speak
      _isSpeaking = true;
      await _flutterTts.speak(text);
    } catch (e) {
      print("Error in speakWithLanguage: $e");
      // Try speaking with default language as fallback
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.speak(text);
    }
  }

  // Stop speaking
  Future<void> stop() async {
    _isSpeaking = false;
    await _flutterTts.stop();
  }
  
  // Check if currently speaking
  bool get isSpeaking => _isSpeaking;
  
  // Get current language
  String get currentLanguage => _currentLanguage;
  
  // Dispose resources
  Future<void> dispose() async {
    await _flutterTts.stop();
  }
} 