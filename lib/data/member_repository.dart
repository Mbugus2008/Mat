import 'dart:math';

import '../models/loan.dart';
import '../models/member.dart';
import '../models/vehicle.dart';

abstract class MemberRepository {
  Future<Member> fetchMember({bool forceRefresh = false});
}

class DemoMemberRepository implements MemberRepository {
  Member? _cached;
  final Random _random = Random();

  @override
  Future<Member> fetchMember({bool forceRefresh = false}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    if (_cached != null && !forceRefresh) {
      return _cached!;
    }

    final arrearsAdjustment = forceRefresh ? _random.nextInt(20) * 5000 : 0;
    final refreshedLoans = _buildLoans(arrearsAdjustment: arrearsAdjustment);

    _cached = Member(
      memberNo: 'SACCO-00254',
      name: 'Jane Muthoni',
      nationalId: '22658745',
      phone: '+254 712 345 678',
      gender: Gender.female,
      joinedOn: DateTime(2018, 7, 4),
      branch: 'CBD Express Branch',
      email: 'jane.muthoni@sacco.co.ke',
      vehicles: _buildVehicles(),
      loans: refreshedLoans,
    );

    return _cached!;
  }

  List<Vehicle> _buildVehicles() {
    return const [
      Vehicle(
        vehicleNo: 'KBN 512B',
        memberNo: 'SACCO-00254',
        startDate: DateTime(2019, 3, 12),
        vehicleType: '14 Seater',
        route: 'CBD ↔ Thika',
      ),
      Vehicle(
        vehicleNo: 'KCP 203Q',
        memberNo: 'SACCO-00254',
        startDate: DateTime(2021, 8, 2),
        vehicleType: '33 Seater',
        route: 'CBD ↔ Juja',
      ),
      Vehicle(
        vehicleNo: 'KDA 781L',
        memberNo: 'SACCO-00254',
        startDate: DateTime(2023, 5, 18),
        vehicleType: '25 Seater',
        route: 'CBD ↔ Westlands',
      ),
    ];
  }

  List<Loan> _buildLoans({int arrearsAdjustment = 0}) {
    return [
      Loan(
        loanNo: 'LN-784512',
        loanType: 'Vehicle Upgrade Facility',
        applicationDate: DateTime(2022, 9, 15),
        amountApplied: 2400000,
        tenureMonths: 48,
        rate: 11.5,
        balance: 1260000,
        arrears: 85000 + arrearsAdjustment,
        completionDate: DateTime(2026, 9, 15),
      ),
      Loan(
        loanNo: 'LN-905631',
        loanType: 'Working Capital Boost',
        applicationDate: DateTime(2024, 2, 3),
        amountApplied: 850000,
        tenureMonths: 24,
        rate: 10.2,
        balance: 620000,
        arrears: 0,
        completionDate: DateTime(2026, 2, 3),
      ),
    ];
  }
}
