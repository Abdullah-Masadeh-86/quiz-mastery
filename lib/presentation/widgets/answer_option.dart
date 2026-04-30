import 'package:flutter/material.dart';
import '../../core/theme.dart';

class AnswerOption extends StatelessWidget {
  final String text;
  final int index;
  final bool isSelected;
  final bool isCorrect;
  final bool isRevealed;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.text,
    required this.index,
    required this.isSelected,
    required this.isCorrect,
    required this.isRevealed,
    required this.onTap,
  });

  String get _optionLetter => String.fromCharCode(65 + index);

  Color get _backgroundColor {
    if (!isRevealed) {
      return isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white;
    }
    if (isCorrect) return AppTheme.correctColor.withOpacity(0.15);
    if (isSelected && !isCorrect) return AppTheme.wrongColor.withOpacity(0.15);
    return Colors.white;
  }

  Color get _borderColor {
    if (!isRevealed) {
      return isSelected ? AppTheme.primaryColor : Colors.grey.shade200;
    }
    if (isCorrect) return AppTheme.correctColor;
    if (isSelected && !isCorrect) return AppTheme.wrongColor;
    return Colors.grey.shade200;
  }

  Color get _textColor {
    if (!isRevealed) {
      return isSelected ? AppTheme.primaryColor : AppTheme.textPrimary;
    }
    if (isCorrect) return AppTheme.correctColor;
    if (isSelected && !isCorrect) return AppTheme.wrongColor;
    return AppTheme.textPrimary;
  }

  IconData? get _trailingIcon {
    if (!isRevealed) return null;
    if (isCorrect) return Icons.check_circle;
    if (isSelected && !isCorrect) return Icons.cancel;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _borderColor,
            width: isSelected || (isRevealed && isCorrect) ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected || (isRevealed && isCorrect)
                    ? _borderColor
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _optionLetter,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected || (isRevealed && isCorrect)
                        ? Colors.white
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _textColor,
                ),
              ),
            ),
            if (_trailingIcon != null)
              Icon(
                _trailingIcon,
                color: isCorrect ? AppTheme.correctColor : AppTheme.wrongColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
