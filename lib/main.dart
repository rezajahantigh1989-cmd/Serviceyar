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
      title: 'سرویس‌یار',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      // تنظیم جهت راست‌به‌چپ (RTL) برای زبان فارسی
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}
