import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'custom_sounds_service.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  List<String> _availableSounds = [];
  List<String> _customSounds = [];
  bool _initialized = false;
  StreamSubscription<FileSystemEvent>? _directoryWatcher;
  final CustomSoundsService _customSoundsService = CustomSoundsService();

  // Cache loaded audio bytes
  final Map<String, Uint8List> _audioCache = {};

  List<String> get availableSounds => _availableSounds;
  List<String> get customSounds => _customSounds;

  /// Load list of MP3 files from assets/sounds/ and custom sounds
  Future<void> loadAvailableSounds() async {
    if (_initialized) return;

    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifest = json.decode(manifestContent);
      _availableSounds = manifest.keys
          .where(
            (key) => key.startsWith('assets/sounds/') && key.endsWith('.mp3'),
          )
          .map((key) => key.replaceFirst('assets/sounds/', ''))
          .toList();
      debugPrint(
        'AudioService: Found ${_availableSounds.length} asset sounds: $_availableSounds',
      );
    } catch (e) {
      debugPrint('AudioService: Manifest load failed: $e');
      _availableSounds = ['default_alarm.mp3'];
    }

    // Load custom sounds
    await _loadCustomSounds();

    // Start watching directory
    _startWatchingCustomSounds();

    _initialized = true;
  }

  /// Load custom sounds from share/data/sounds/
  Future<void> _loadCustomSounds() async {
    try {
      final files = await _customSoundsService.listCustomSounds();
      _customSounds = files.map((file) => file.path).toList();
      debugPrint('AudioService: Found ${_customSounds.length} custom sounds');
    } catch (e) {
      debugPrint('AudioService: Failed to load custom sounds: $e');
      _customSounds = [];
    }
  }

  /// Watch custom sounds directory for changes
  void _startWatchingCustomSounds() {
    _directoryWatcher?.cancel();
    _directoryWatcher = _customSoundsService.watchDirectory().listen(
      (event) {
        debugPrint('AudioService: Directory changed: ${event.type}');
        // Reload custom sounds on any change
        _loadCustomSounds();
      },
      onError: (error) {
        debugPrint('AudioService: Watcher error: $error');
      },
    );
  }

  /// Load audio bytes from asset
  Future<Uint8List?> _loadAudioBytes(String filename) async {
    if (_audioCache.containsKey(filename)) {
      return _audioCache[filename];
    }

    try {
      final assetPath = 'assets/sounds/$filename';
      debugPrint('AudioService: Loading asset from: $assetPath');
      final ByteData data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      _audioCache[filename] = bytes;
      debugPrint('AudioService: Loaded ${bytes.length} bytes');
      return bytes;
    } catch (e) {
      debugPrint('AudioService: Failed to load asset: $e');
      return null;
    }
  }

  /// Play sound (null = default/first available, empty = silence)
  Future<void> play(String? soundFile) async {
    if (soundFile != null && soundFile.isEmpty) return;
    await loadAvailableSounds();

    final file =
        soundFile ??
        (_availableSounds.isNotEmpty
            ? _availableSounds.first
            : 'default_alarm.mp3');

    debugPrint('AudioService: Playing: $file');

    // Check if it's a custom sound (file path)
    if (file.contains(Platform.pathSeparator)) {
      // Custom sound from file system
      await _playFromFile(file);
    } else {
      // Built-in asset sound
      final bytes = await _loadAudioBytes(file);
      if (bytes != null) {
        try {
          await _player.play(BytesSource(bytes));
          debugPrint('AudioService: Play started successfully');
        } catch (e) {
          debugPrint('AudioService: Error playing sound: $e');
        }
      } else {
        debugPrint('AudioService: No audio bytes to play');
      }
    }
  }

  /// Play sound from file system
  Future<void> _playFromFile(String filePath) async {
    try {
      await _player.play(DeviceFileSource(filePath));
      debugPrint('AudioService: Playing from file: $filePath');
    } catch (e) {
      debugPrint('AudioService: Error playing from file: $e');
    }
  }

  void dispose() {
    _directoryWatcher?.cancel();
    _player.dispose();
  }
}
