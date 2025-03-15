import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

/// A utility class for running Whisper locally on device.
/// 
/// This class provides functionality to download and use the Whisper model
/// for local speech-to-text transcription without requiring an internet connection
/// or API calls to OpenAI.
/// 
/// Note: Running Whisper locally requires significant computational resources.
/// Performance will vary based on device capabilities.
class LocalWhisper {
  /// The path to the downloaded Whisper model
  String? _modelPath;
  
  /// The size of the Whisper model to use
  /// Options: 'tiny', 'base', 'small', 'medium', 'large'
  final String modelSize;
  
  /// Whether to enable multilingual support
  final bool multilingual;
  
  /// Constructor for LocalWhisper
  /// 
  /// [modelSize] determines the size and accuracy of the model:
  /// - 'tiny': Fastest but least accurate
  /// - 'base': Good balance for mobile devices
  /// - 'small': Better accuracy, still reasonable on modern phones
  /// - 'medium': High accuracy, may be slow on mobile
  /// - 'large': Highest accuracy, recommended only for desktop or high-end devices
  /// 
  /// [multilingual] enables support for multiple languages (including Urdu)
  LocalWhisper({
    this.modelSize = 'base',
    this.multilingual = true,
  });
  
  /// Initialize the Whisper model by downloading it if not already available
  Future<bool> initialize() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final modelsDir = Directory('${appDir.path}/whisper_models');
      
      if (!await modelsDir.exists()) {
        await modelsDir.create(recursive: true);
      }
      
      final modelSuffix = multilingual ? 'multilingual' : 'en';
      final modelFileName = 'whisper-${modelSize}-${modelSuffix}.pt';
      final modelFile = File('${modelsDir.path}/$modelFileName');
      
      if (await modelFile.exists()) {
        _modelPath = modelFile.path;
        return true;
      }
      
      // Model doesn't exist, download it
      final modelUrl = 'https://openaipublic.azureedge.net/main/whisper/models/$modelFileName';
      
      // Show download progress
      final response = await http.get(Uri.parse(modelUrl));
      
      if (response.statusCode == 200) {
        await modelFile.writeAsBytes(response.bodyBytes);
        _modelPath = modelFile.path;
        return true;
      } else {
        throw Exception('Failed to download model: ${response.statusCode}');
      }
    } catch (e) {
      print('Error initializing Whisper: $e');
      return false;
    }
  }
  
  /// Transcribe an audio file to text
  /// 
  /// [audioPath] is the path to the audio file to transcribe
  /// [language] is the language code (e.g., 'en', 'ur') or null for auto-detection
  /// [translateToEnglish] whether to translate non-English speech to English
  Future<TranscriptionResult> transcribeAudio(
    String audioPath, {
    String? language,
    bool translateToEnglish = false,
  }) async {
    if (_modelPath == null) {
      final initialized = await initialize();
      if (!initialized) {
        return TranscriptionResult(
          text: '',
          error: 'Failed to initialize Whisper model',
          success: false,
        );
      }
    }
    
    try {
      // Convert audio to correct format if needed (16kHz mono WAV)
      final processedAudioPath = await _preprocessAudio(audioPath);
      
      // Run the Whisper model on the processed audio
      final result = await _runWhisperModel(
        processedAudioPath,
        language: language,
        translateToEnglish: translateToEnglish,
      );
      
      return result;
    } catch (e) {
      return TranscriptionResult(
        text: '',
        error: 'Error transcribing audio: $e',
        success: false,
      );
    }
  }
  
  /// Preprocess the audio file to match Whisper's requirements
  /// 
  /// Converts the audio to 16kHz mono WAV format
  Future<String> _preprocessAudio(String audioPath) async {
    final tempDir = await getTemporaryDirectory();
    final outputPath = '${tempDir.path}/processed_audio.wav';
    
    // Use FFmpeg to convert the audio
    final session = await FFmpegKit.execute(
      '-i "$audioPath" -ar 16000 -ac 1 -c:a pcm_s16le "$outputPath"'
    );
    
    final returnCode = await session.getReturnCode();
    
    if (ReturnCode.isSuccess(returnCode)) {
      return outputPath;
    } else {
      throw Exception('Failed to process audio file');
    }
  }
  
  /// Run the Whisper model on the processed audio
  /// 
  /// This is a placeholder for the actual model execution code.
  /// In a real implementation, this would use a Flutter plugin or FFI to call
  /// the Whisper C++ library or a TensorFlow Lite / PyTorch model.
  Future<TranscriptionResult> _runWhisperModel(
    String audioPath, {
    String? language,
    bool translateToEnglish = false,
  }) async {
    // This is where you would integrate with a native code plugin
    // that can run the Whisper model locally.
    // 
    // For a complete implementation, you would need to:
    // 1. Create a native plugin or use FFI to call Whisper's C++ library
    // 2. Load the model file from _modelPath
    // 3. Process the audio file
    // 4. Return the transcription
    
    // For demonstration purposes, we'll simulate a successful transcription
    // In a real implementation, replace this with actual model inference
    await Future.delayed(Duration(seconds: 2)); // Simulate processing time
    
    return TranscriptionResult(
      text: 'This is a placeholder transcription. Replace with actual Whisper model output.',
      language: language ?? 'en',
      segments: [
        TranscriptionSegment(
          text: 'This is a placeholder transcription.',
          start: 0.0,
          end: 2.0,
        ),
      ],
      success: true,
    );
  }
  
  /// Clean up resources when done
  void dispose() {
    // Clean up any resources if needed
  }
}

/// Represents the result of a transcription
class TranscriptionResult {
  /// The transcribed text
  final String text;
  
  /// The detected language code
  final String? language;
  
  /// Individual segments of the transcription with timestamps
  final List<TranscriptionSegment>? segments;
  
  /// Error message if transcription failed
  final String? error;
  
  /// Whether the transcription was successful
  final bool success;
  
  TranscriptionResult({
    required this.text,
    this.language,
    this.segments,
    this.error,
    required this.success,
  });
}

/// Represents a segment of transcribed text with timestamps
class TranscriptionSegment {
  /// The transcribed text for this segment
  final String text;
  
  /// Start time in seconds
  final double start;
  
  /// End time in seconds
  final double end;
  
  TranscriptionSegment({
    required this.text,
    required this.start,
    required this.end,
  });
}

/// Example usage:
/// ```dart
/// final whisper = LocalWhisper(modelSize: 'base', multilingual: true);
/// await whisper.initialize();
/// final result = await whisper.transcribeAudio('/path/to/audio.m4a', language: 'ur');
/// if (result.success) {
///   print('Transcription: ${result.text}');
/// } else {
///   print('Error: ${result.error}');
/// }
/// ``` 