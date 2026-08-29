import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double currentKm = 0;
  double lastOilChangeKm = 0;
  double oilIntervalKm = 5000;
  bool isTracking = false;
  StreamSubscription<Position>? positionStream;
  Position? lastPosition;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // بارگذاری اطلاعات ذخیره شده
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentKm = prefs.getDouble('currentKm') ?? 0.0;
      lastOilChangeKm = prefs.getDouble('lastOilChangeKm') ?? 0.0;
      oilIntervalKm = prefs.getDouble('oilIntervalKm') ?? 5000.0;
    });
  }

  // ذخیره اطلاعات
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('currentKm', currentKm);
    await prefs.setDouble('lastOilChangeKm', lastOilChangeKm);
    await prefs.setDouble('oilIntervalKm', oilIntervalKm);
  }

  // فعال/غیرفعال کردن ردیاب کیلومتر با GPS
  Future<void> _toggleTracking() async {
    if (isTracking) {
      positionStream?.cancel();
      setState(() => isTracking = false);
      _saveData();
    } else {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      setState(() => isTracking = true);
      lastPosition = null;

      positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        if (lastPosition != null) {
          double distanceInMeters = Geolocator.distanceBetween(
            lastPosition!.latitude,
            lastPosition!.longitude,
            position.latitude,
            position.longitude,
          );
          setState(() {
            currentKm += (distanceInMeters / 1000);
          });
          _saveData();
        }
        lastPosition = position;
      });
    }
  }

  // ثبت سرویس روغن جدید
  void _recordOilChange() {
    setState(() {
      lastOilChangeKm = currentKm;
    });
    _saveData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تعویض روغن با موفقیت ثبت شد.')),
    );
  }

  // ویرایش دستی کیلومتر
  void _editKmDialog() {
    final controller = TextEditingController(text: currentKm.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تنظیم کارکرد خودرو (کیلومتر)', textAlign: TextAlign.right),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              double? val = double.tryParse(controller.text);
              if (val != null) {
                setState(() => currentKm = val);
                _saveData();
              }
              Navigator.pop(ctx);
            },
            child: const Text('ذخیره'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double kmPassed = currentKm - lastOilChangeKm;
    double kmRemaining = oilIntervalKm - kmPassed;
    double progress = (kmPassed / oilIntervalKm).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت سرویس خودرو (سرویس‌یار)'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // کارت کیلومترشمار و ردیاب
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'کارکرد فعلی خودرو',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${currentKm.toStringAsFixed(1)} کیلومتر',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _editKmDialog,
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('تنظیم دستی'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: _toggleTracking,
                            icon: Icon(isTracking ? Icons.stop : Icons.play_arrow),
                            label: Text(isTracking ? 'توقف ردیاب' : 'شروع ردیاب GPS'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isTracking ? Colors.red : Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // وضعیت روغن موتور
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.oil_barrel, color: Colors.amber, size: 28),
                          SizedBox(width: 8),
                          Text(
                            'وضعیت روغن موتور',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(6),
                        color: progress > 0.85 ? Colors.red : Colors.indigo,
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('کارکرد با روغن فعلی: ${kmPassed.toStringAsFixed(0)} km'),
                          Text(
                            kmRemaining > 0
                                ? 'باقی‌مانده: ${kmRemaining.toStringAsFixed(0)} km'
                                : 'نیاز به تعویض فوری!',
                            style: TextStyle(
                              color: kmRemaining > 0 ? Colors.green[700] : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _recordOilChange,
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('ثبت تعویض روغن جدید'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
