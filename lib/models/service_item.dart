import 'package:flutter/material.dart';

class ServiceItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const ServiceItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
