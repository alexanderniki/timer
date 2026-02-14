import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class CustomSoundsService {
  static final CustomSoundsService _instance = CustomSoundsService._internal();
  factory CustomSoundsService() => _instance;
  CustomSoundsService._internal();

  /// Get or create the custom sounds directory
  /// Returns: ./share/data/sounds/ relative to app root
  Future<Directory> getCustomSoundsDirectory() async {
    try {
      // Get the current directory (where the app is running)
      final currentDir = Directory.current;

      // Create path: ./share/data/sounds/
      final customSoundsPath = path.join(
        currentDir.path,
        'share',
        'data',
        'sounds',
      );

      final customSoundsDir = Directory(customSoundsPath);

      // Create directory if it doesn't exist
      if (!await customSoundsDir.exists()) {
        await customSoundsDir.create(recursive: true);
        debugPrint('CustomSoundsService: Created directory: $customSoundsPath');
      } else {
        debugPrint('CustomSoundsService: Directory exists: $customSoundsPath');
      }

      return customSoundsDir;
    } catch (e) {
      debugPrint('CustomSoundsService: Error accessing directory: $e');
      rethrow;
    }
  }

  /// List all .mp3 files in the custom sounds directory
  Future<List<File>> listCustomSounds() async {
    try {
      final dir = await getCustomSoundsDirectory();

      final List<FileSystemEntity> entities = await dir.list().toList();

      final List<File> mp3Files = entities
          .whereType<File>()
          .where((file) => path.extension(file.path).toLowerCase() == '.mp3')
          .toList();

      debugPrint('CustomSoundsService: Found ${mp3Files.length} MP3 files');

      return mp3Files;
    } catch (e) {
      debugPrint('CustomSoundsService: Error listing files: $e');
      return [];
    }
  }

  /// Watch the custom sounds directory for changes
  Stream<FileSystemEvent> watchDirectory() async* {
    try {
      final dir = await getCustomSoundsDirectory();
      debugPrint('CustomSoundsService: Watching directory: ${dir.path}');
      yield* dir.watch(events: FileSystemEvent.all, recursive: false);
    } catch (e) {
      debugPrint('CustomSoundsService: Error watching directory: $e');
    }
  }
}
