import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timer_model.dart';
import '../providers/timer_provider.dart';
import '../services/audio_service.dart';

import '../l10n/app_localizations.dart';

class TimerDialog extends StatefulWidget {
  final TimerModel? timer;

  const TimerDialog({super.key, this.timer});

  bool get isEditMode => timer != null;

  @override
  State<TimerDialog> createState() => _TimerDialogState();

  /// Show dialog for creating a new timer
  static Future<void> showCreate(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const TimerDialog(),
    );
  }

  /// Show dialog for editing an existing timer
  static Future<void> showEdit(BuildContext context, TimerModel timer) {
    return showDialog(
      context: context,
      builder: (context) => TimerDialog(timer: timer),
    );
  }
}

class _TimerDialogState extends State<TimerDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _commandController;
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  late TextEditingController _secondsController;
  String? _selectedSound;
  List<String> _availableSounds = [];
  List<String> _customSounds = [];
  bool _loadingSounds = true;

  bool get _isEditMode => widget.timer != null;

  @override
  void initState() {
    super.initState();

    if (_isEditMode) {
      final timer = widget.timer!;
      _labelController = TextEditingController(text: timer.label);
      _commandController = TextEditingController(text: timer.command ?? '');

      final duration = timer.duration;
      _hoursController = TextEditingController(
        text: duration.inHours > 0 ? duration.inHours.toString() : '',
      );
      _minutesController = TextEditingController(
        text: duration.inMinutes.remainder(60) > 0
            ? duration.inMinutes.remainder(60).toString()
            : '',
      );
      _secondsController = TextEditingController(
        text: duration.inSeconds.remainder(60) > 0
            ? duration.inSeconds.remainder(60).toString()
            : '',
      );
      _selectedSound = timer.soundFile;
    } else {
      _labelController = TextEditingController();
      _commandController = TextEditingController();
      _hoursController = TextEditingController();
      _minutesController = TextEditingController();
      _secondsController = TextEditingController();
    }

    _loadSounds();
  }

  Future<void> _loadSounds() async {
    final audioService = AudioService();
    await audioService.loadAvailableSounds();
    setState(() {
      _availableSounds = audioService.availableSounds;
      _customSounds = audioService.customSounds;
      _loadingSounds = false;
      if (_selectedSound == null) {
        if (_availableSounds.isNotEmpty) {
          _selectedSound = _availableSounds.first;
        } else {
          _selectedSound = "";
        }
      }
    });
  }

  @override
  void dispose() {
    _labelController.dispose();
    _commandController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      final hours = int.tryParse(_hoursController.text) ?? 0;
      final minutes = int.tryParse(_minutesController.text) ?? 0;
      final seconds = int.tryParse(_secondsController.text) ?? 0;

      final duration = Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
      );

      if (duration.inSeconds == 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pleaseSetDuration)));
        return;
      }

      final label = _labelController.text.isEmpty
          ? l10n.defaultTimerLabel
          : _labelController.text;
      final command = _commandController.text.isEmpty
          ? null
          : _commandController.text;

      if (_isEditMode) {
        context.read<TimerProvider>().updateTimer(
          widget.timer!.id,
          label: label,
          duration: duration,
          command: command,
          soundFile: _selectedSound,
        );
      } else {
        context.read<TimerProvider>().addTimer(
          label,
          duration,
          command,
          _selectedSound,
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isEditMode ? l10n.editTimerTitle : l10n.newTimerTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.nameLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                TextFormField(
                  controller: _labelController,
                  decoration: InputDecoration(
                    hintText: l10n.nameHint,
                    border: const UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.durationLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _timeInput(l10n.hoursLabel, _hoursController),
                    _timeInput(l10n.minutesLabel, _minutesController),
                    _timeInput(l10n.secondsLabel, _secondsController),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.soundLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                _loadingSounds
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String?>(
                        initialValue: _selectedSound,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem<String?>(
                            value: "",
                            child: Text(l10n.none),
                          ),
                          ..._availableSounds.map(
                            (s) => DropdownMenuItem<String?>(
                              value: s,
                              child: Text(s.replaceAll('.mp3', '')),
                            ),
                          ),
                          ..._customSounds.map(
                            (s) => DropdownMenuItem<String?>(
                              value: s,
                              child: Text(
                                '📁 ${s.split(Platform.pathSeparator).last.replaceAll('.mp3', '')}',
                              ),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() => _selectedSound = v),
                      ),
                const SizedBox(height: 24),
                Text(
                  l10n.shellCommandLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                TextFormField(
                  controller: _commandController,
                  decoration: InputDecoration(
                    hintText: l10n.shellCommandHint,
                    border: const UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: Text(
                      _isEditMode ? l10n.saveChanges : l10n.createTimer,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                if (_isEditMode) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<TimerProvider>().deleteTimer(
                          widget.timer!.id,
                        );
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Text(
                        l10n.deleteTimer,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeInput(String label, TextEditingController controller) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
