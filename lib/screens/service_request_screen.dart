import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/custom_button.dart';

class ServiceRequestScreen extends StatefulWidget {
  final String? initialService;

  const ServiceRequestScreen({super.key, this.initialService});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final _carModelController = TextEditingController();
  final _currentMileageController = TextEditingController();
  final _nextMileageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedService;
  bool _enableAlarm = true;
  int _reminderDaysBefore = 7;
  int _serviceInterval = 5000; // بازه پیش‌فرض تعویض به کیلومتر

  final List<String> _serviceTypes = [
    'سرویس‌های دوره‌ای',
    'تعویض روغن و فیلتر',
    'باتری و برق خودرو',
    'کارشناسی و دیاگ',
    'تعویض لنت و ترمز',
    'سایر خدمات',
  ];

  @override
  void initState() {
    super.initState();
    _selectedService = widget.initialService ?? _serviceTypes.first;
  }

  @override
  void dispose() {
    _carModelController.dispose();
    _currentMileageController.dispose();
    _nextMileageController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // تبدیل اعداد فارسی به انگلیسی جهت محاسبه دقیق ریاضی
  String _normalizeDigits(String input) {
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(persian[i], i.toString());
      input = input.replaceAll(arabic[i], i.toString());
    }
    return input;
  }

  // فرمول محاسبه خودکار کیلومتر بعدی: (کارکرد فعلی + بازه سرویس)
  void _autoCalculateNextMileage(String currentVal) {
    final cleanInput = _normalizeDigits(currentVal.trim());
    if (cleanInput.isEmpty) {
      _nextMileageController.clear();
      return;
    }

    final currentKm = int.tryParse(cleanInput);
    if (currentKm != null) {
      setState(() {
        _nextMileageController.text = (currentKm + _serviceInterval).toString();
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('سرویس با موفقیت ثبت شد', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🔹 نوع سرویس: $_selectedService'),
              const SizedBox(height: 6),
              Text('🚗 خودرو: ${_carModelController.text}'),
              const SizedBox(height: 6),
              Text('📍 کارکرد فعلی: ${_currentMileageController.text} کیلومتر'),
              const SizedBox(height: 6),
              Text(
                '🎯 موعد بعدی: ${_nextMileageController.text} کیلومتر',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              Text(
                _enableAlarm
                    ? '⏰ آلارم یادآور: فعال ($_reminderDaysBefore روز قبل)'
                    : '⏰ آلارم یادآور: غیرفعال',
                style: TextStyle(
                  color: _enableAlarm ? AppColors.secondary : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text('تایید و بازگشت'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ثبت سرویس و تنظیم آلارم'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // انتخاب نوع سرویس
                DropdownButtonFormField<String>(
                  value: _selectedService,
                  decoration: const InputDecoration(
                    labelText: 'نوع سرویس',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.build_outlined, color: AppColors.primary),
                  ),
                  items: _serviceTypes.map((service) {
                    return DropdownMenuItem(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedService = val;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // مدل خودرو
                TextFormField(
                  controller: _carModelController,
                  decoration: const InputDecoration(
                    labelText: 'مدل خودرو (مثال: پژو ۲۰۶)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions_car_outlined, color: AppColors.primary),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'لطفاً مدل خودرو را وارد کنید';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // کارکرد فعلی
                TextFormField(
                  controller: _currentMileageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'کیلومتر فعلی خودرو',
                    hintText: 'مثال: ۷۵۰۰۰',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.speed_outlined, color: AppColors.primary),
                  ),
                  onChanged: _autoCalculateNextMileage,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'لطفاً کیلومتر فعلی را وارد کنید';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // انتخاب دوره تعویض (دکمه‌های ۵۰۰۰، ۷۰۰۰، ۱۰۰۰۰)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'دوره تعویض بعدی:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [5000, 7000, 10000].map((interval) {
                        final isSelected = _serviceInterval == interval;
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ChoiceChip(
                            label: Text('$interval کیلومتر'),
                            selected: isSelected,
                            selectedColor: AppColors.primary.withOpacity(0.2),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _serviceInterval = interval;
                                  _autoCalculateNextMileage(_currentMileageController.text);
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // کیلومتر بعدی (محاسبه خودکار)
                TextFormField(
                  controller: _nextMileageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'کیلومتر سرویس بعدی (محاسبه خودکار)',
                    filled: true,
                    fillColor: Colors.blue.shade50.withOpacity(0.5),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.update_outlined, color: AppColors.secondary),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'لطفاً کیلومتر بعدی را مشخص کنید';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // بخش تنظیمات یادآور و آلارم
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'فعال‌سازی آلارم و یادآور سرویس',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text('هشدار خودکار قبل از رسیدن به کیلومتر تعویض'),
                          value: _enableAlarm,
                          activeColor: AppColors.primary,
                          onChanged: (bool value) {
                            setState(() {
                              _enableAlarm = value;
                            });
                          },
                        ),
                        if (_enableAlarm) ...[
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('فاصله زمانی هشدار:'),
                              DropdownButton<int>(
                                value: _reminderDaysBefore,
                                items: const [
                                  DropdownMenuItem(value: 3, child: Text('۳ روز قبل')),
                                  DropdownMenuItem(value: 7, child: Text('۱ هفته قبل')),
                                  DropdownMenuItem(value: 14, child: Text('۲ هفته قبل')),
                                  DropdownMenuItem(value: 30, child: Text('۱ ماه قبل')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _reminderDaysBefore = val;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // شماره تماس
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'شماره تماس',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'لطفاً شماره تماس را وارد کنید';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // دکمه ثبت
                CustomButton(
                  title: 'ثبت سرویس و فعال‌سازی آلارم',
                  icon: Icons.notifications_active_outlined,
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
