import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:process_run/shell.dart';
import '../models/timer_model.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';

class TimerProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final AudioService _audioService = AudioService();
  final _uuid = const Uuid();

  List<TimerModel> _timers = [];
  Timer? _ticker;

  List<TimerModel> get timers => _timers;

  TimerProvider() {
    _loadInitialTimers();
    _startTicker();
  }

  Future<void> _loadInitialTimers() async {
    final loadedTimers = await _storageService.loadTimers();

    // Reset running or paused timers to idle state with full duration
    _timers = loadedTimers.map((timer) {
      if (timer.status == TimerStatus.running ||
          timer.status == TimerStatus.paused) {
        return timer.copyWith(
          status: TimerStatus.idle,
          remainingTime: timer.duration,
        );
      }
      return timer;
    }).toList();

    // Save reset state if needed
    if (_timers.isNotEmpty) {
      _storageService.saveTimers(_timers);
    }

    notifyListeners();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      _tick();
    });
  }

  void _tick() {
    bool changed = false;
    for (int i = 0; i < _timers.length; i++) {
      if (_timers[i].status == TimerStatus.running) {
        final remaining = _timers[i].remainingTime.inSeconds - 1;
        if (remaining <= 0) {
          _onTimerComplete(_timers[i]);
          _timers[i] = _timers[i].copyWith(
            remainingTime: Duration.zero,
            status: TimerStatus.completed,
          );
        } else {
          _timers[i] = _timers[i].copyWith(
            remainingTime: Duration(seconds: remaining),
          );
        }
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  Future<void> _onTimerComplete(TimerModel timer) async {
    // Play completion sound
    await _audioService.play(timer.soundFile);

    // Execute command if exists
    if (timer.command != null && timer.command!.trim().isNotEmpty) {
      try {
        final shell = Shell();
        await shell.run(timer.command!);
      } catch (e) {
        debugPrint('Error executing command: $e');
      }
    }
  }

  void addTimer(
    String label,
    Duration duration,
    String? command,
    String? soundFile,
  ) {
    final newTimer = TimerModel(
      id: _uuid.v4(),
      label: label,
      duration: duration,
      remainingTime: duration,
      command: command,
      soundFile: soundFile,
    );
    _timers.add(newTimer);
    _storageService.saveTimers(_timers);
    notifyListeners();
  }

  void startTimer(String id) {
    final index = _timers.indexWhere((t) => t.id == id);
    if (index != -1) {
      _timers[index] = _timers[index].copyWith(status: TimerStatus.running);
      _storageService.saveTimers(_timers);
      notifyListeners();
    }
  }

  void pauseTimer(String id) {
    final index = _timers.indexWhere((t) => t.id == id);
    if (index != -1) {
      _timers[index] = _timers[index].copyWith(status: TimerStatus.paused);
      _storageService.saveTimers(_timers);
      notifyListeners();
    }
  }

  void resetTimer(String id) {
    final index = _timers.indexWhere((t) => t.id == id);
    if (index != -1) {
      _timers[index] = _timers[index].copyWith(
        remainingTime: _timers[index].duration,
        status: TimerStatus.idle,
      );
      _storageService.saveTimers(_timers);
      notifyListeners();
    }
  }

  void updateTimer(
    String id, {
    String? label,
    Duration? duration,
    String? command,
    String? soundFile,
  }) {
    final index = _timers.indexWhere((t) => t.id == id);
    if (index != -1) {
      final timer = _timers[index];
      _timers[index] = timer.copyWith(
        label: label ?? timer.label,
        duration: duration ?? timer.duration,
        remainingTime: duration ?? timer.remainingTime,
        command: command,
        soundFile: soundFile,
        status: TimerStatus.idle,
      );
      _storageService.saveTimers(_timers);
      notifyListeners();
    }
  }

  void deleteTimer(String id) {
    _timers.removeWhere((t) => t.id == id);
    _storageService.saveTimers(_timers);
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
