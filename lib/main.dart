import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomeScreen(),
      ),
    );
  }
}

class ServiceItem {
  final String title;
  final int lastKm;
  final int intervalKm;
  final IconData icon;

  ServiceItem({
    required this.title,
    required this.lastKm,
    required this.intervalKm,
    required this.icon,
  });

  int get nextKm => lastKm + intervalKm;
  int remainingKm(int currentKm) => nextKm - currentKm;
  double progress(int currentKm) {
    int passed = currentKm - lastKm;
    if (passed <= 0) return 0.0;
    if (passed >= intervalKm) return 1.0;
    return (passed / intervalKm).clamp(0.0, 1.0);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentMileage = 125400;

  final List<ServiceItem> services = [
    ServiceItem(title: 'روغن موتور و فیلتر روغن', lastKm: 120000, intervalKm: 6000, icon: Icons.oil_barrel_rounded),
    ServiceItem(title: 'فیلتر هوا', lastKm: 120000, intervalKm: 10000, icon: Icons.air_rounded),
    ServiceItem(title: 'شمع و وایر', lastKm: 100000, intervalKm: 30000, icon: Icons.electric_bolt_rounded),
    ServiceItem(title: 'تسمه تایم', lastKm: 80000, intervalKm: 60000, icon: Icons.change_circle_rounded),
    ServiceItem(title: 'لنت ترمز جلو', lastKm: 110000, intervalKm: 25000, icon: Icons.car_repair_rounded),
  ];

  void _showAddServiceDialog() {
    final titleController = TextEditingController();
    final kmController = TextEditingController();
    final intervalController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ثبت سرویس جدید',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'عنوان سرویس (مثلاً روغن موتور)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.build_circle_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: kmController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'کیلومتر فعلی تعویض',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.speed),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: intervalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'دوره تعویض (کیلومتر)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.timelapse),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        kmController.text.isNotEmpty &&
                        intervalController.text.isNotEmpty) {
                      setState(() {
                        services.insert(
                          0,
                          ServiceItem(
                            title: titleController.text,
                            lastKm: int.tryParse(kmController.text) ?? currentMileage,
                            intervalKm: int.tryParse(intervalController.text) ?? 5000,
                            icon: Icons.check_circle_outline,
                          ),
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('افزودن به لیست', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('سرویس‌یار | خودرو من', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1E88E5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Text('کارکرد فعلی خودرو', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                  '$currentMileage کیلومتر',
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('وضعیت قطعات و سرویس‌ها', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
                Text('${services.length} مورد', style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final item = services[index];
              final remaining = item.remainingKm(currentMileage);
              final progress = item.progress(currentMileage);

              Color statusColor = const Color(0xFF43A047);
              if (remaining <= 500) {
                statusColor = const Color(0xFFE53935);
              } else if (remaining <= 1500) {
                statusColor = const Color(0xFFFB8C00);
              }

              return Card(
                elevation: 1,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(item.icon, color: statusColor, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(height: 4),
                                Text(
                                  remaining > 0 ? 'باقیمانده: $remaining کیلومتر' : 'نیاز فوری به تعویض!',
                                  style: TextStyle(color: statusColor, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Text('دوره ${item.intervalKm ~/ 1000}k', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddServiceDialog,
        backgroundColor: const Color(0xFF1E88E5),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('ثبت سرویس', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
