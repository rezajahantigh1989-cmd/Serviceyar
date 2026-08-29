import 'package:flutter/material.dart';

/// نقطه شروع اپلیکیشن سرویس‌یار
void main() {
  runApp(const ServiceYarApp());
}

class ServiceYarApp extends StatelessWidget {
  const ServiceYarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سرویس‌یار',
      debugShowCheckedModeBanner: false, // حذف نوار قرمز Debug از گوشه صفحه
      
      // --- تنظیمات ظاهری (Theme) ---
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8), // رنگ اصلی آبی برند سرویس‌یار
          primary: const Color(0xFF1A73E8),
          secondary: const Color(0xFF34A853),
        ),
        // تنظیم فونت و استایل متن‌ها در آینده اینجا اضافه می‌شود
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),

      // --- تعیین صفحه اول اپلیکیشن ---
      // فعلاً ما یک صفحه موقت (Placeholder) می‌سازیم تا ساختار درست باشد
      home: const SplashScreen(), 
    );
  }
}

/// یک صفحه موقت برای تست اولیه و شروع پروژه
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          // یک گرادینت زیبا برای شروع کار
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // اینجا در آینده لوگوی سرویس‌یار قرار می‌گیرد
            const Icon(
              Icons.construction,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'سرویس‌یار',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'در حال آماده‌سازی...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
