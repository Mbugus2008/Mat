import 'package:intl/intl.dart';

class Vehicle {
  const Vehicle({
    required this.vehicleNo,
    required this.memberNo,
    required this.startDate,
    required this.vehicleType,
    this.route,
  });

  final String vehicleNo;
  final String memberNo;
  final DateTime startDate;
  final String vehicleType;
  final String? route;

  static final DateFormat _dateFormat = DateFormat('d MMM y');

  String get startDateLabel => _dateFormat.format(startDate);
}
