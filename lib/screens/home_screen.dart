import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/service_item.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // لیست سرویس‌ها بر اساس مدل ServiceItem
    final List<ServiceItem> services = [
      ServiceItem(
        title: 'سرویس‌های دوره‌ای',
        icon: Icons.build_circle_outlined,
        color: AppColors.primary,
      ),
      ServiceItem(
        title: 'تعویض روغن و فیلتر',
        icon: Icons.oil_barrel_outlined,
        color: AppColors.secondary,
      ),
      ServiceItem(
        title: 'باتری و برق خودرو',
        icon: Icons.electric_car_outlined,
        color: Colors.amber.shade800,
      ),
      ServiceItem(
        title: 'کارشناسی و دیاگ',
        icon: Icons.computer_outlined,
        color: AppColors.accent,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('سرویس‌یار'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // کارت بنر خوش‌آمدگویی
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'سامانه هوشمند سرویس‌یار',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'مدیریت سریع و آسان سرویس‌های دوره‌ای خودرو',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'خدمات ما',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              // لیست خدمات
              Expanded(
                child: ListView.separated(
                  itemCount: services.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = services[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item.color.withOpacity(0.15),
                          child: Icon(item.icon, color: item.color),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('انتخاب شد: ${item.title}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // دکمه درخواست سرویس جدید با استفاده از CustomButton
              CustomButton(
                title: 'درخواست سرویس جدید',
                icon: Icons.add,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('فرم درخواست به زودی اضافه می‌شود'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
