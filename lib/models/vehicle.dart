import 'package:intl/intl.dart';

enum VehicleTypeCode {
  blank('_blank_', 'Unspecified'),
  seater14('_x0031_4_Seater', '14 Seater'),
  seater33('_x0033_3_Seater', '33 Seater'),
  seater25('_x0032_5_Seater', '25 Seater'),
  seater29('_x0032_9_Seater', '29 Seater'),
  seater41('_41_Seater', '41 Seater'),
  seater26('_26_Seater', '26 Seater'),
  seater37('_37_Seater', '37 Seater'),
  seater51('_x0035_1_Seater', '51 Seater'),
  seater34('_x0033_4_Seater', '34 Seater'),
  seater38('_x0033_8_Seater', '38 Seater'),
  seater40('_x0034_0_Seater', '40 Seater'),
  seater46('_x0034_6_Seater', '46 Seater'),
  seater60('_x0036_0_Seater', '60 Seater'),
  seater35('_x0033_5_Seater', '35 Seater'),
  seater36('_x0033_6_Seater', '36 Seater'),
  seater39('_x0033_9_Seater', '39 Seater');

  const VehicleTypeCode(this.soapValue, this.label);

  final String soapValue;
  final String label;

  static VehicleTypeCode fromSoapValue(String? value) {
    if (value == null || value.isEmpty) {
      return VehicleTypeCode.blank;
    }
    return VehicleTypeCode.values.firstWhere(
      (type) => type.soapValue == value,
      orElse: () => VehicleTypeCode.blank,
    );
  }
}

enum VehicleStatus { active, dormant, left }

extension VehicleStatusLabel on VehicleStatus {
  String get label {
    switch (this) {
      case VehicleStatus.active:
        return 'Active';
      case VehicleStatus.dormant:
        return 'Dormant';
      case VehicleStatus.left:
        return 'Left';
    }
  }

  String get soapValue => label;
}

class Vehicle {
  Vehicle({
    this.Key,
    this.Vehicle_Number,
    VehicleTypeCode? Vehicle_Type,
    this.Daily_Contribution,
    required this.Start_Date,
    this.Code,
    this.Name,
    this.Category,
    VehicleStatus? Status,
    this.Fleet_No,
    this.Member_No,
    this.Route,
  })  : Vehicle_Type = Vehicle_Type ?? VehicleTypeCode.blank,
        Status = Status ?? VehicleStatus.active;

  final String? Key;
  final String? Vehicle_Number;
  final VehicleTypeCode Vehicle_Type;
  final double? Daily_Contribution;
  final DateTime Start_Date;
  final String? Code;
  final String? Name;
  final String? Category;
  final VehicleStatus Status;
  final String? Fleet_No;
  final String? Member_No;
  final String? Route;

  String? get key => Key;
  String get vehicleNo => Vehicle_Number ?? '';
  String get vehicleType => Vehicle_Type.label;
  String get soapVehicleType => Vehicle_Type.soapValue;
  double? get dailyContribution => Daily_Contribution;
  DateTime get startDate => Start_Date;
  String? get code => Code;
  String? get displayName => Name;
  String? get category => Category;
  VehicleStatus get vehicleStatus => Status;
  String? get fleetNo => Fleet_No;
  String get memberNo => Member_No ?? '';
  String? get route => Route;
  bool get isActive => Status == VehicleStatus.active;

  static final DateFormat _dateFormat = DateFormat('d MMM y');

  String get startDateLabel => _dateFormat.format(Start_Date);
}
