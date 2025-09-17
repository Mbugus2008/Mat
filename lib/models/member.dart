import 'loan.dart';
import 'vehicle.dart';

enum Gender { male, female, other }

extension GenderLabel on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}

class Member {
  const Member({
    required this.memberNo,
    required this.name,
    required this.nationalId,
    required this.phone,
    required this.gender,
    required this.vehicles,
    required this.loans,
    this.joinedOn,
    this.branch,
    this.email,
  });

  final String memberNo;
  final String name;
  final String nationalId;
  final String phone;
  final Gender gender;
  final List<Vehicle> vehicles;
  final List<Loan> loans;
  final DateTime? joinedOn;
  final String? branch;
  final String? email;

  String get firstName => name.split(' ').first;

  String get maskedNationalId {
    if (nationalId.length <= 4) {
      return nationalId;
    }
    final middle = nationalId.length - 4;
    return nationalId.replaceRange(2, 2 + middle, '*' * middle);
  }

  double get totalArrears =>
      loans.fold<double>(0, (sum, loan) => sum + loan.arrears);

  double get totalBalance =>
      loans.fold<double>(0, (sum, loan) => sum + loan.balance);

  double get totalDisbursed =>
      loans.fold<double>(0, (sum, loan) => sum + loan.amountApplied);

  double get totalPaid =>
      loans.fold<double>(0, (sum, loan) => sum + loan.paidAmount);

  int get activeLoans =>
      loans.where((loan) => !loan.isCompleted).length;

  bool get hasArrears => totalArrears > 0;

  List<Vehicle> get vehiclesByStartDate {
    final sorted = [...vehicles];
    sorted.sort((a, b) => b.startDate.compareTo(a.startDate));
    return sorted;
  }

  List<Loan> get loansByApplicationDate {
    final sorted = [...loans];
    sorted.sort((a, b) => b.applicationDate.compareTo(a.applicationDate));
    return sorted;
  }

  Map<String, int> get vehicleTypeBreakdown {
    final Map<String, int> summary = <String, int>{};
    for (final vehicle in vehicles) {
      summary.update(
        vehicle.vehicleType,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return summary;
  }
}
