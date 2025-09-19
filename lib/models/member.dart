import 'loan.dart';
import 'vehicle.dart' as vehicle_model;

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

enum CrewType { owner, driver, conductor, unknown }

extension CrewTypeLabel on CrewType {
  String get label {
    switch (this) {
      case CrewType.owner:
        return 'Owner';
      case CrewType.driver:
        return 'Driver';
      case CrewType.conductor:
        return 'Conductor';
      case CrewType.unknown:
        return 'Unknown';
    }
  }
}

class Member {
  Member({
    this.Key,
    this.No,
    this.Name,
    this.Phone_No,
    this.ID_No,
    this.E_Mail,
    this.Customer_Posting_Group,
    this.Loans,
    this.Crew_Type,
    String? Vehicle,
    this.gender = Gender.other,
    List<vehicle_model.Vehicle> vehicles = const <vehicle_model.Vehicle>[],
    List<Loan> loanAccounts = const <Loan>[],
    List<MemberAccount> Accounts = const <MemberAccount>[],
    this.joinedOn,
    this.branch,
  })  : _vehicle = Vehicle,
        _vehicles = List<vehicle_model.Vehicle>.unmodifiable(vehicles),
        _loans = List<Loan>.unmodifiable(loanAccounts),
        _accounts = List<MemberAccount>.unmodifiable(Accounts);

  final String? Key;
  final String? No;
  final String? Name;
  final String? Phone_No;
  final String? ID_No;
  final String? E_Mail;
  final String? Customer_Posting_Group;
  final double? Loans;
  final CrewType? Crew_Type;
  final String? _vehicle;

  final Gender gender;
  final DateTime? joinedOn;
  final String? branch;

  final List<vehicle_model.Vehicle> _vehicles;
  final List<Loan> _loans;
  final List<MemberAccount> _accounts;

  String? get key => Key;
  String get memberNo => No ?? '';
  String get name => Name ?? '';
  String get phone => Phone_No ?? '';
  String get nationalId => ID_No ?? '';
  String? get email => E_Mail;
  String? get customerPostingGroup => Customer_Posting_Group;
  double? get loansAmount => Loans;
  CrewType? get crewType => Crew_Type;
  String? get Vehicle => _vehicle;
  String? get vehicle => Vehicle;

  String get firstName {
    final candidate = name.trim();
    if (candidate.isEmpty) {
      return '';
    }
    final segments = candidate.split(RegExp(r'\s+'));
    return segments.isEmpty ? candidate : segments.first;
  }

  String get maskedNationalId {
    final id = nationalId;
    if (id.length <= 4) {
      return id;
    }
    final middle = id.length - 4;
    return id.replaceRange(2, 2 + middle, '*' * middle);
  }

  List<vehicle_model.Vehicle> get vehicles => _vehicles;

  List<Loan> get loans => _loans;

  List<MemberAccount> get accounts => _accounts;

  double get totalArrears =>
      _loans.fold<double>(0, (sum, loan) => sum + loan.arrears);

  double get totalBalance =>
      _loans.fold<double>(0, (sum, loan) => sum + loan.balance);

  double get totalDisbursed =>
      _loans.fold<double>(0, (sum, loan) => sum + loan.amountApplied);

  double get totalPaid =>
      _loans.fold<double>(0, (sum, loan) => sum + loan.paidAmount);

  int get activeLoans => _loans.where((loan) => !loan.isCompleted).length;

  bool get hasArrears => totalArrears > 0;

  List<vehicle_model.Vehicle> get vehiclesByStartDate {
    final sorted = _vehicles.toList(growable: false);
    sorted.sort((a, b) => b.startDate.compareTo(a.startDate));
    return sorted;
  }

  List<Loan> get loansByApplicationDate {
    final sorted = _loans.toList(growable: false);
    sorted.sort((a, b) => b.applicationDate.compareTo(a.applicationDate));
    return sorted;
  }

  Map<String, int> get vehicleTypeBreakdown {
    final Map<String, int> summary = <String, int>{};
    for (final vehicle in _vehicles) {
      summary.update(
        vehicle.vehicleType,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return summary;
  }
}

enum PostingType {
  blank('_blank_', 'Unspecified'),
  loan('Loan', 'Loan'),
  deposit('Deposit', 'Deposit'),
  shares('Shares', 'Shares');

  const PostingType(this.soapValue, this.label);

  final String soapValue;
  final String label;

  static PostingType fromSoapValue(String? value) {
    if (value == null || value.isEmpty) {
      return PostingType.blank;
    }
    return PostingType.values.firstWhere(
      (type) => type.soapValue == value,
      orElse: () => PostingType.blank,
    );
  }
}

class MemberAccount {
  const MemberAccount({
    this.Key,
    this.No,
    this.Name,
    this.Search_Name,
    this.Name_2,
    this.Net_Change,
    PostingType? Posting_Type,
  }) : Posting_Type = Posting_Type ?? PostingType.blank;

  final String? Key;
  final String? No;
  final String? Name;
  final String? Search_Name;
  final String? Name_2;
  final double? Net_Change;
  final PostingType Posting_Type;

  String get accountNo => No ?? '';
  String get displayName => Name ?? Name_2 ?? '';
  String get searchName => Search_Name ?? '';
  double get netChange => Net_Change ?? 0;
  PostingType get postingType => Posting_Type;

  bool get hasPositiveBalance => netChange > 0;
}
