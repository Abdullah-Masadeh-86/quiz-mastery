import 'package:flutter/material.dart';
import '../../core/theme.dart';

class TimerWidget extends StatelessWidget {
  final int remainingTime;
  final int totalTime;

  const TimerWidget({
    super.key,
    required this.remainingTime,
    required this.totalTime,
  });

  double get progress => remainingTime / totalTime;

  Color get timerColor {
    if (remainingTime > 20) return AppTheme.correctColor;
    if (remainingTime > 10) return AppTheme.warningColor;
    return AppTheme.wrongColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                ),
              ),
              Icon(Icons.timer, color: timerColor, size: 28),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time Remaining',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '$remainingTime seconds',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: timerColor,
                  ),
                ),
              ],
            ),
          ),
          if (remainingTime <= 10)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.wrongColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: AppTheme.wrongColor,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Hurry!',
                    style: TextStyle(
                      color: AppTheme.wrongColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
