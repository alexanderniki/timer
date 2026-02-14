import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timer_model.dart';
import '../providers/timer_provider.dart';
import '../utils/responsive_utils.dart';
import 'timer_dialog.dart';

class TimerCard extends StatelessWidget {
  final TimerModel timer;

  const TimerCard({super.key, required this.timer});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours == "00" ? "$minutes:$seconds" : "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimerProvider>(context, listen: false);
    final isRunning = timer.status == TimerStatus.running;
    final isCompleted = timer.status == TimerStatus.completed;

    // Responsive values
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    // Adaptive sizing
    final cardPadding = isDesktop ? 20.0 : (isTablet ? 18.0 : 16.0);
    final labelFontSize = isDesktop ? 16.0 : (isTablet ? 15.0 : 14.0);
    final timerFontSize = isDesktop ? 48.0 : (isTablet ? 44.0 : 42.0);
    final iconSize = isDesktop ? 24.0 : (isTablet ? 22.0 : 20.0);
    final commandFontSize = isDesktop ? 12.0 : (isTablet ? 11.0 : 10.0);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    timer.label.toUpperCase(),
                    style: TextStyle(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined, size: iconSize),
                  onPressed: () => TimerDialog.showEdit(context, timer),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: isDesktop ? 12 : 8),
            LayoutBuilder(
              builder: (context, constraints) {
                // For very narrow cards, stack controls below timer
                final isNarrow = constraints.maxWidth < 280;

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _formatDuration(timer.remainingTime),
                          style: TextStyle(
                            fontSize: timerFontSize,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w200,
                            color: isCompleted ? Colors.red : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _buildControlButtons(
                          provider,
                          isRunning,
                          isCompleted,
                          iconSize,
                        ),
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _formatDuration(timer.remainingTime),
                          style: TextStyle(
                            fontSize: timerFontSize,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w200,
                            color: isCompleted ? Colors.red : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ..._buildControlButtons(
                      provider,
                      isRunning,
                      isCompleted,
                      iconSize,
                    ),
                  ],
                );
              },
            ),
            if (timer.command != null && timer.command!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: isDesktop ? 12.0 : 8.0),
                child: Text(
                  '> ${timer.command}',
                  style: TextStyle(
                    fontSize: commandFontSize,
                    color: Colors.grey,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildControlButtons(
    TimerProvider provider,
    bool isRunning,
    bool isCompleted,
    double iconSize,
  ) {
    return [
      if (!isCompleted)
        IconButton(
          icon: Icon(
            isRunning ? Icons.pause : Icons.play_arrow,
            size: iconSize,
          ),
          onPressed: () => isRunning
              ? provider.pauseTimer(timer.id)
              : provider.startTimer(timer.id),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
        ),
      IconButton(
        icon: Icon(Icons.refresh, size: iconSize),
        onPressed: () => provider.resetTimer(timer.id),
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
      ),
    ];
  }
}
