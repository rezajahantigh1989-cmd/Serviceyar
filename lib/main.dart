import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ServiceYarApp());
}

class ServiceYarApp extends StatelessWidget {
  const ServiceYarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'سرویس‌یار',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const HomeScreen(), // هدایت به صفحه اصلی که ساختیم
    );
  }
}
