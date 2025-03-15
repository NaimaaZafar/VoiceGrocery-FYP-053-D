import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp/screens/fav.dart';
import 'package:fyp/screens/profile.dart';
import 'package:fyp/screens/search_product.dart';
import 'package:fyp/screens/settings.dart';
import 'package:fyp/utils/colors.dart';
import 'package:fyp/widgets/navbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fyp/screens/my_cart.dart';
import 'package:fyp/screens/category.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceRecognitionScreen extends StatefulWidget {
  const VoiceRecognitionScreen({super.key});

  @override
  State<VoiceRecognitionScreen> createState() => _VoiceRecognitionScreenState();
}

class _VoiceRecognitionScreenState extends State<VoiceRecognitionScreen> {
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String _recordingPath = '';
  String _text = 'Press the microphone button to start speaking';
  String _intentText = '';
  String _detectedIntent = '';
  List<String> _detectedItems = [];
  bool _isProcessing = false;
  bool _isTranscribing = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _selectedIndex = 4; // For navbar selection
  String _detectedLanguage = '';
  
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  // Request necessary permissions
  Future<void> _requestPermissions() async {
    // Only check for iOS simulator, otherwise just request permission without blocking
    if (Platform.isIOS) {
      bool isIosSimulator = !await _audioRecorder.hasPermission();
      
      if (isIosSimulator) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Microphone access is not available in iOS simulator. Please use a physical device for full functionality.';
        });
        return;
      }
    }

    // Just request permissions without blocking on the result
    // The actual recording attempt will determine if we have permission
    await Permission.microphone.request();
    await Permission.storage.request();
    
    // Clear any previous error messages
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
  }

  // Start recording audio
  Future<void> _startRecording() async {
    // Clear any previous error state
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
    
    try {
      final tempDir = await getTemporaryDirectory();
      _recordingPath = '${tempDir.path}/audio_recording.m4a';
      
      // Start recording - if this fails, we'll catch the exception
      final audioConfig = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );
      
      await _audioRecorder.start(
        audioConfig,
        path: _recordingPath,
      );
      
      setState(() {
        _isRecording = true;
        _text = 'Recording...';
        _intentText = '';
        _detectedIntent = '';
        _detectedItems = [];
        _detectedLanguage = '';
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        // Provide a more user-friendly error message
        _errorMessage = 'Could not access microphone. If you\'ve already granted permission in settings, please restart the app.';
      });
      
      // Try requesting permission again as a last resort
      await Permission.microphone.request();
    }
  }

  // Stop recording and process the audio
  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _isTranscribing = true;
        _text = 'Processing your voice...';
      });
      
      // First transcribe the audio, then process the intent
      final transcription = await _transcribeAudio();
      if (transcription != null && transcription.isNotEmpty) {
        await _processIntentWithGPT4o(transcription);
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _hasError = true;
        _errorMessage = 'Error stopping recording: $e';
      });
    }
  }

  // Step 1: Transcribe audio using Whisper API
  Future<String?> _transcribeAudio() async {
    try {
      final apiKey = dotenv.env['OPENAI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        setState(() {
          _isTranscribing = false;
          _hasError = true;
          _errorMessage = 'OpenAI API key not found. Please add it to the .env file and restart the app.';
        });
        return null;
      }
      
      // Check if file exists
      final file = File(_recordingPath);
      if (!await file.exists()) {
        setState(() {
          _isTranscribing = false;
          _hasError = true;
          _errorMessage = 'Audio file not found';
        });
        return null;
      }
      
      // Prepare the request for transcription
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.openai.com/v1/audio/transcriptions'),
      );
      
      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $apiKey',
      });
      
      // Add file and fields
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _recordingPath,
      ));
      
      // Use the more capable model for better multilingual support
      request.fields['model'] = 'whisper-1';
      request.fields['response_format'] = 'verbose_json'; // Get detailed response with language info
      
      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String transcription = data['text'];
        
        // Extract language if available
        if (data.containsKey('language')) {
          final String langCode = data['language'];
          
          // Map language code to full name for display
          final Map<String, String> languageNames = {
            'en': 'English',
            'ur': 'Urdu',
            'hi': 'Hindi', // Sometimes Urdu might be detected as Hindi
            'pa': 'Punjabi',
          };
          
          _detectedLanguage = languageNames[langCode] ?? langCode;
        }
        
        setState(() {
          _text = transcription;
        });
        
        return transcription;
      } else {
        setState(() {
          _isTranscribing = false;
          _hasError = true;
          _errorMessage = 'Error transcribing audio: ${response.statusCode} - ${response.body}';
        });
        return null;
      }
    } catch (e) {
      setState(() {
        _isTranscribing = false;
        _hasError = true;
        _errorMessage = 'Error transcribing audio: $e';
      });
      return null;
    }
  }

  // Step 2: Process the transcription with GPT-4o for intent detection
  Future<void> _processIntentWithGPT4o(String transcription) async {
    try {
      final apiKey = dotenv.env['OPENAI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        setState(() {
          _isTranscribing = false;
          _hasError = true;
          _errorMessage = 'OpenAI API key not found. Please add it to the .env file and restart the app.';
        });
        return;
      }
      
      // Prepare the request to chat completions API
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': '''You are a helpful assistant that identifies user intents for a grocery shopping app.
The user may speak in English or Urdu but your response should be in English. Regardless of the language, identify if the user wants to:
1) add item(s) to cart
2) search for item(s)
3) go to cart

Return ONLY a valid JSON object with:
- "intent" field (one of: "add_to_cart", "search", "go_to_cart", or "unknown")
- "items" array containing any item names mentioned, ALWAYS TRANSLATED TO ENGLISH regardless of the language spoken

Examples:
English: "I want to buy apples and bananas" → {"intent": "add_to_cart", "items": ["apple", "banana"]}
Urdu: "میں سیب اور کیلے خریدنا چاہتا ہوں" → {"intent": "add_to_cart", "items": ["apple", "banana"]}
English: "Show me tomatoes" → {"intent": "search", "items": ["tomato"]}
Urdu: "مجھے ٹماٹر دکھائیں" → {"intent": "search", "items": ["tomato"]}
English: "Go to my cart" → {"intent": "go_to_cart", "items": []}
Urdu: "میرے کارٹ پر جائیں" → {"intent": "go_to_cart", "items": []}

Common grocery items in Urdu and their English translations:
- سیب = apple
- کیلے = banana
- ٹماٹر = tomato
- پیاز = onion
- آلو = potato
- گوشت = meat
- مرغی = chicken
- مچھلی = fish
- دودھ = milk
- پنیر = cheese
- روٹی = bread
- چاول = rice
- دال = lentils

IMPORTANT: Your response must be a valid JSON object and nothing else. No explanations, no markdown formatting, just the JSON.'''
            },
            {
              'role': 'user',
              'content': transcription
            }
          ],
          'temperature': 0.1, // Lower temperature for more consistent JSON formatting
        }),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String content = data['choices'][0]['message']['content'];
        
        // Clean up the content to ensure it's valid JSON
        content = _sanitizeJsonString(content);
        
        // Parse the JSON response
        try {
          final Map<String, dynamic> intentData = json.decode(content);
          
          setState(() {
            _isTranscribing = false;
            _intentText = content;
            
            if (intentData.containsKey('intent')) {
              _detectedIntent = intentData['intent'];
              if (intentData.containsKey('items') && intentData['items'] is List) {
                _detectedItems = List<String>.from(intentData['items']);
              }
              
              // Handle navigation based on intent
              _handleIntentNavigation();
            }
          });
        } catch (e) {
          // JSON parsing failed, try to extract intent and items using fallback method
          _extractIntentWithFallback(content, transcription);
        }
      } else {
        setState(() {
          _isTranscribing = false;
          _hasError = true;
          _errorMessage = 'Error processing intent: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _isTranscribing = false;
        _hasError = true;
        _errorMessage = 'Error processing intent: $e';
      });
    }
  }
  
  // Sanitize the string to ensure it's valid JSON
  String _sanitizeJsonString(String jsonString) {
    // Remove any markdown code block markers
    jsonString = jsonString.replaceAll('```json', '').replaceAll('```', '');
    
    // Trim whitespace
    jsonString = jsonString.trim();
    
    // If the string doesn't start with {, try to find the first {
    if (!jsonString.startsWith('{')) {
      final startIndex = jsonString.indexOf('{');
      if (startIndex >= 0) {
        jsonString = jsonString.substring(startIndex);
      }
    }
    
    // If the string doesn't end with }, try to find the last }
    if (!jsonString.endsWith('}')) {
      final endIndex = jsonString.lastIndexOf('}');
      if (endIndex >= 0) {
        jsonString = jsonString.substring(0, endIndex + 1);
      }
    }
    
    return jsonString;
  }
  
  // Fallback method to extract intent and items when JSON parsing fails
  void _extractIntentWithFallback(String content, String originalTranscription) {
    // Set default values
    String intent = 'unknown';
    List<String> items = [];
    
    try {
      // Check for intent keywords in the content or original transcription
      String textToCheck = content.toLowerCase() + ' ' + originalTranscription.toLowerCase();
      
      if (textToCheck.contains('add') || 
          textToCheck.contains('buy') || 
          textToCheck.contains('purchase') ||
          textToCheck.contains('cart') && textToCheck.contains('add')) {
        intent = 'add_to_cart';
      } else if (textToCheck.contains('search') || 
                textToCheck.contains('find') || 
                textToCheck.contains('show') ||
                textToCheck.contains('look')) {
        intent = 'search';
      } else if (textToCheck.contains('cart') || 
                textToCheck.contains('checkout') || 
                textToCheck.contains('basket')) {
        intent = 'go_to_cart';
      }
      
      // Try to extract items using regex
      RegExp itemsRegex = RegExp(r'"items":\s*\[(.*?)\]');
      final match = itemsRegex.firstMatch(content);
      if (match != null && match.groupCount >= 1) {
        final itemsString = match.group(1) ?? '';
        items = itemsString
            .split(',')
            .map((item) => item.trim().replaceAll('"', '').replaceAll("'", ""))
            .where((item) => item.isNotEmpty)
            .toList();
      }
      
      setState(() {
        _isTranscribing = false;
        _intentText = 'Fallback processing: Intent=$intent, Items=$items';
        _detectedIntent = intent;
        _detectedItems = items;
        
        // Handle navigation based on intent
        _handleIntentNavigation();
      });
    } catch (e) {
      setState(() {
        _isTranscribing = false;
        _hasError = true;
        _errorMessage = 'Error in fallback processing: $e\nOriginal error was with parsing JSON response.';
      });
    }
  }

  // Handle navigation based on detected intent
  void _handleIntentNavigation() {
    // Add a slight delay to show the intent before navigating
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      switch (_detectedIntent) {
        case 'add_to_cart':
          if (_detectedItems.isNotEmpty) {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(
                builder: (_) => const CategoryScreen(categoryName: 'MeatsFishes')
              )
            );
          }
          break;
        case 'search':
          if (_detectedItems.isNotEmpty) {
            // Use showSearch with ProductSearchDelegate
            showSearch(
              context: context,
              query: _detectedItems.first,
              delegate: ProductSearchDelegate(category: "All")
            );
          }
          break;
        case 'go_to_cart':
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_) => const MyCart())
          );
          break;
        default:
          // Stay on the same page
          break;
      }
    });
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const CategoryScreen(categoryName: 'MeatsFishes')
        )
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const FavScreen())
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const AccountsPage())
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const SettingsScreen())
      );
    } else if (index == 4) {
      // We're already on the Voice Recognition screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Assistant'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.normal,
        ),
        backgroundColor: bg_dark,
        elevation: 10,
      ),
      body: Column(
        children: [
          // Detected language display
          if (_detectedLanguage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Detected Language:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _detectedLanguage,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          
          // Transcribed text
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _isTranscribing
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Transcribing your audio...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Voice Input:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _text.isEmpty ? 'Press the microphone button to start speaking' : _text,
                            style: TextStyle(
                              fontSize: 16,
                              color: _text.isEmpty ? Colors.grey : Colors.black,
                            ),
                          ),
                          if (_hasError) ...[
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
          ),
          
          // Detected intent
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detected Intent:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_detectedIntent.isNotEmpty) ...[
                            _buildIntentDisplay(),
                          ] else ...[
                            const Text(
                              'Speak to detect your intent',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _isRecording ? _stopRecording : _startRecording,
        tooltip: _isRecording ? 'Stop recording' : 'Start recording',
        backgroundColor: _isRecording ? Colors.red : bg_dark,
        child: Icon(_isRecording ? Icons.stop : Icons.mic),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
  
  Widget _buildIntentDisplay() {
    IconData intentIcon;
    String intentLabel;
    Color intentColor;
    
    switch (_detectedIntent) {
      case 'add_to_cart':
        intentIcon = Icons.add_shopping_cart;
        intentLabel = 'Add to Cart';
        intentColor = Colors.green;
        break;
      case 'search':
        intentIcon = Icons.search;
        intentLabel = 'Search';
        intentColor = Colors.blue;
        break;
      case 'go_to_cart':
        intentIcon = Icons.shopping_cart;
        intentLabel = 'Go to Cart';
        intentColor = Colors.orange;
        break;
      default:
        intentIcon = Icons.question_mark;
        intentLabel = 'Unknown Intent';
        intentColor = Colors.grey;
        break;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(intentIcon, color: intentColor, size: 24),
            const SizedBox(width: 8),
            Text(
              intentLabel,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: intentColor,
              ),
            ),
          ],
        ),
        if (_detectedItems.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text(
            'Items:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _detectedItems
                .map(
                  (item) => Chip(
                    label: Text(item),
                    backgroundColor: Colors.grey.shade100,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
  
  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }
} 