import 'package:flutter/material.dart';
import 'package:taller_itla_app/theme/app_colors.dart';
import 'package:taller_itla_app/theme/app_text_styles.dart';

class MotivationalBanner extends StatefulWidget {
  final List<String> messages;

  const MotivationalBanner({super.key, required this.messages});

  @override
  State<MotivationalBanner> createState() => _MotivationalBannerState();
}

class _MotivationalBannerState extends State<MotivationalBanner> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _rotateMessages);
  }

  void _rotateMessages() {
    if (mounted) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.messages.length;
      });
      Future.delayed(const Duration(seconds: 4), _rotateMessages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.messages[_currentIndex],
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
