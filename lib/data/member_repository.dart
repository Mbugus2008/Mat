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
    final vehicles = _buildVehicles();
    final outstandingBalance = refreshedLoans.fold<double>(
      0,
      (sum, loan) => sum + loan.balance,
    );

    _cached = Member(
      Key: 'demo-member-key',
      No: 'SACCO-00254',
      Name: 'Jane Muthoni',
      ID_No: '22658745',
      Phone_No: '+254 712 345 678',
      E_Mail: 'jane.muthoni@sacco.co.ke',
      Customer_Posting_Group: 'MAT-CUSTOMERS',
      Loans: outstandingBalance,
      Crew_Type: CrewType.owner,
      Vehicle: vehicles.isEmpty ? null : vehicles.first.vehicleNo,
      gender: Gender.female,
      joinedOn: DateTime(2018, 7, 4),
      branch: 'CBD Express Branch',
      vehicles: vehicles,
      loanAccounts: refreshedLoans,
    );

    return _cached!;
  }

  List<Vehicle> _buildVehicles() {
    return [
      Vehicle(
        Key: 'vehicle-1',
        Vehicle_Number: 'KBN 512B',
        Member_No: 'SACCO-00254',
        Start_Date: DateTime(2019, 3, 12),
        Vehicle_Type: VehicleTypeCode.seater14,
        Daily_Contribution: 850.0,
        Code: 'THIKA-14',
        Name: 'Thika Express Shuttle',
        Category: 'Matatu',
        Status: VehicleStatus.active,
        Fleet_No: 'FLEET-14',
        Route: 'CBD - Thika',
      ),
      Vehicle(
        Key: 'vehicle-2',
        Vehicle_Number: 'KCP 203Q',
        Member_No: 'SACCO-00254',
        Start_Date: DateTime(2021, 8, 2),
        Vehicle_Type: VehicleTypeCode.seater33,
        Daily_Contribution: 900.0,
        Code: 'JUJA-33',
        Name: 'Juja Commuter',
        Category: 'Matatu',
        Status: VehicleStatus.active,
        Fleet_No: 'FLEET-33',
        Route: 'CBD - Juja',
      ),
      Vehicle(
        Key: 'vehicle-3',
        Vehicle_Number: 'KDA 781L',
        Member_No: 'SACCO-00254',
        Start_Date: DateTime(2023, 5, 18),
        Vehicle_Type: VehicleTypeCode.seater25,
        Daily_Contribution: 780.0,
        Code: 'WEST-25',
        Name: 'Westlands Connector',
        Category: 'Matatu',
        Status: VehicleStatus.active,
        Fleet_No: 'FLEET-25',
        Route: 'CBD - Westlands',
      ),
    ];
  }

  List<Loan> _buildLoans({int arrearsAdjustment = 0}) {
    return [
      Loan(
        Key: 'loan-1',
        Loan_No: 'LN-784512',
        Loan_Type: 'Vehicle Upgrade Facility',
        Product_Name: 'Vehicle Upgrade Facility',
        Member_No: 'SACCO-00254',
        Member_Name: 'Jane Muthoni',
        Principle_Amount: 2400000,
        Loan_Balance: 1260000,
        Status: LoanStatusCode.disbursed,
        Repayment_Start_Date: DateTime(2022, 9, 15),
        Installments: 48,
        Repayment_End_Date: DateTime(2026, 9, 15),
        Interest_Rate: 11.5,
        Monthly_Interest: (85000 + arrearsAdjustment).toDouble(),
        Monthly_Installment: 95000,
      ),
      Loan(
        Key: 'loan-2',
        Loan_No: 'LN-905631',
        Loan_Type: 'Working Capital Boost',
        Product_Name: 'Working Capital Boost',
        Member_No: 'SACCO-00254',
        Member_Name: 'Jane Muthoni',
        Principle_Amount: 850000,
        Loan_Balance: 620000,
        Status: LoanStatusCode.disbursed,
        Repayment_Start_Date: DateTime(2024, 2, 3),
        Installments: 24,
        Repayment_End_Date: DateTime(2026, 2, 3),
        Interest_Rate: 10.2,
        Monthly_Interest: 0,
        Monthly_Installment: 38500,
      ),
    ];
  }
}
