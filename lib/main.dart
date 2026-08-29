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
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorSchemeSeed: const Color(0xFF1E88E5),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomeScreen(),
      ),
    );
  }
}

class ServiceItem {
  String id;
  String title;
  int intervalKm;
  int lastServiceKm;
  IconData icon;
  Color color;

  ServiceItem({
    required this.id,
    required this.title,
    required this.intervalKm,
    required this.lastServiceKm,
    required this.icon,
    required this.color,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String carName = "پژو ۲۰۶";
  String licensePlate = "ایران ۱۱ - ۱۲۳ ج ۴۵";
  int currentKm = 45000;

  List<ServiceItem> services = [
    ServiceItem(
      id: '1',
      title: 'روغن موتور و فیلتر روغن',
      intervalKm: 6000,
      lastServiceKm: 42000,
      icon: Icons.oil_barrel,
      color: Colors.amber.shade700,
    ),
    ServiceItem(
      id: '2',
      title: 'فیلتر هوا و اتاق',
      intervalKm: 10000,
      lastServiceKm: 40000,
      icon: Icons.air,
      color: Colors.teal,
    ),
    ServiceItem(
      id: '3',
      title: 'شمع و وایر',
      intervalKm: 30000,
      lastServiceKm: 25000,
      icon: Icons.electric_bolt,
      color: Colors.deepOrange,
    ),
    ServiceItem(
      id: '4',
      title: 'تسمه تایم و دینام',
      intervalKm: 60000,
      lastServiceKm: 0,
      icon: Icons.sync,
      color: Colors.blueGrey,
    ),
    ServiceItem(
      id: '5',
      title: 'لنت ترمز جلو',
      intervalKm: 25000,
      lastServiceKm: 30000,
      icon: Icons.speed,
      color: Colors.indigo,
    ),
  ];

  // متد ویرایش کیلومتر فعلی
  void _editCurrentKm() {
    TextEditingController controller =
        TextEditingController(text: currentKm.toString());

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('ویرایش کارکرد فعلی خودرو'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'کیلومتر فعلی خودرو',
              suffixText: 'کیلومتر',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('انصراف'),
            ),
            ElevatedButton(
              onPressed: () {
                int? newKm = int.tryParse(controller.text);
                if (newKm != null && newKm >= 0) {
                  setState(() {
                    currentKm = newKm;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('ذخیره'),
            ),
          ],
        ),
      ),
    );
  }

  // متد منوی تنظیمات (چرخ‌دنده)
  void _openSettings() {
    TextEditingController nameController = TextEditingController(text: carName);
    TextEditingController plateController =
        TextEditingController(text: licensePlate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'تنظیمات پروفایل خودرو',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'نام و مدل خودرو',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_car),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: plateController,
                decoration: const InputDecoration(
                  labelText: 'شماره پلاک خودرو',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (nameController.text.trim().isNotEmpty) {
                        carName = nameController.text.trim();
                      }
                      licensePlate = plateController.text.trim();
                    });
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('ثبت و ذخیره تغییرات'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // متد ثبت سرویس جدید
  void _addServiceDialog() {
    ServiceItem? selectedItem = services.first;
    TextEditingController kmController =
        TextEditingController(text: currentKm.toString());

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('ثبت انجام سرویس دوره‌ای'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<ServiceItem>(
                  value: selectedItem,
                  decoration: const InputDecoration(
                    labelText: 'انتخاب قطعه / سرویس',
                    border: OutlineInputBorder(),
                  ),
                  items: services.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text(s.title, style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setDialogState(() {
                      selectedItem = val;
                    });
                  },
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: kmController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'در چه کیلومتری تعویض شد؟',
                    border: OutlineInputBorder(),
                    suffixText: 'کیلومتر',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('انصراف'),
              ),
              ElevatedButton(
                onPressed: () {
                  int? km = int.tryParse(kmController.text);
                  if (km != null && selectedItem != null) {
                    setState(() {
                      selectedItem!.lastServiceKm = km;
                      if (km > currentKm) {
                        currentKm = km;
                      }
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('ثبت سرویس'),
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
      body: SafeArea(
        child: Column(
          children: [
            // هدر بالای صفحه
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'سرویس‌یار | $carName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (licensePlate.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                licensePlate,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ],
                      ),
                      // دکمه چرخ‌دنده تنظیمات خودرو
                      IconButton(
                        onPressed: _openSettings,
                        icon: const Icon(Icons.settings, color: Colors.white, size: 26),
                        tooltip: 'تنظیمات خودرو',
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  InkWell(
                    onTap: _editCurrentKm,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.35)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'کارکرد فعلی خودرو (برای ویرایش لمس کنید)',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.95),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.edit,
                                      color: Colors.white, size: 15),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$currentKm کیلومتر',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // عنوان بخش قطعات
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'وضعیت قطعات و سرویس‌ها',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  Text(
                    '${services.length} قطعه ثبت‌شده',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // لیست قطعات
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final item = services[index];
                  int usedKm = currentKm - item.lastServiceKm;
                  if (usedKm < 0) usedKm = 0;
                  int remainingKm = item.intervalKm - usedKm;
                  double progress = (usedKm / item.intervalKm).clamp(0.0, 1.0);

                  Color statusColor = Colors.green;
                  if (remainingKm <= 0) {
                    statusColor = Colors.red;
                  } else if (remainingKm < 1500) {
                    statusColor = Colors.orange;
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: item.color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(item.icon,
                                    color: item.color, size: 26),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      remainingKm > 0
                                          ? 'باقیمانده: $remainingKm کیلومتر'
                                          : 'نیازمند تعویض فوری! (${-remainingKm} کیلومتر گذشته)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: statusColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'دوره ${item.intervalKm ~/ 1000}k',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                remainingKm <= 0
                                    ? Colors.red
                                    : (remainingKm < 1500
                                        ? Colors.orange
                                        : Colors.green),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addServiceDialog,
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('ثبت سرویس جدید'),
      ),
    );
  }
}
