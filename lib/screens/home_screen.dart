import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/service_item.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('سرویس‌یار'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'به سرویس‌یار خوش آمدید',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'شروع کار',
                onPressed: () {
                  // در آینده منطق برنامه اینجا اضافه می‌شود
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
