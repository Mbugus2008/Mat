enum LoanStatusCode {
  newLoan('New', 'New'),
  disbursed('Disbursed', 'Disbursed'),
  cleared('Cleared', 'Cleared');

  const LoanStatusCode(this.soapValue, this.label);

  final String soapValue;
  final String label;

  static LoanStatusCode fromSoapValue(String? value) {
    if (value == null || value.isEmpty) {
      return LoanStatusCode.disbursed;
    }
    return LoanStatusCode.values.firstWhere(
      (status) => status.soapValue == value,
      orElse: () => LoanStatusCode.disbursed,
    );
  }
}

class Loan {
  Loan({
    this.Key,
    this.Loan_No,
    this.Loan_Type,
    this.Product_Name,
    this.Member_No,
    this.Member_Name,
    this.Principle_Amount,
    this.Loan_Balance,
    LoanStatusCode? Status,
    this.Repayment_Start_Date,
    this.Installments,
    this.Repayment_End_Date,
    this.Interest_Rate,
    this.Monthly_Interest,
    this.Monthly_Installment,
  }) : Status = Status ?? LoanStatusCode.disbursed;

  final String? Key;
  final String? Loan_No;
  final String? Loan_Type;
  final String? Product_Name;
  final String? Member_No;
  final String? Member_Name;
  final double? Principle_Amount;
  final double? Loan_Balance;
  final LoanStatusCode Status;
  final DateTime? Repayment_Start_Date;
  final int? Installments;
  final DateTime? Repayment_End_Date;
  final double? Interest_Rate;
  final double? Monthly_Interest;
  final double? Monthly_Installment;

  String? get key => Key;
  String get loanNo => Loan_No ?? '';
  String get loanType => Loan_Type ?? Product_Name ?? '';
  String get productName => Product_Name ?? '';
  String get memberNo => Member_No ?? '';
  String get memberName => Member_Name ?? '';
  double get amountApplied => Principle_Amount ?? 0;
  double get balance => Loan_Balance ?? 0;
  double get rate => Interest_Rate ?? 0;
  double get monthlyInterest => Monthly_Interest ?? 0;
  double get monthlyInstallment => Monthly_Installment ?? 0;
  double get arrears => monthlyInterest;
  int get tenureMonths => Installments ?? 0;
  LoanStatusCode get loanStatusCode => Status;

  DateTime get applicationDate => Repayment_Start_Date ?? DateTime.now();

  DateTime get completionDate {
    if (Repayment_End_Date != null) {
      return Repayment_End_Date!;
    }
    if (Installments != null && Installments! > 0) {
      return DateTime(
        applicationDate.year,
        applicationDate.month + Installments!,
        applicationDate.day,
      );
    }
    return applicationDate;
  }

  double get paidAmount {
    final paid = amountApplied - balance;
    if (paid <= 0) {
      return 0;
    }
    if (paid >= amountApplied) {
      return amountApplied;
    }
    return paid;
  }

  double get progress =>
      amountApplied <= 0 ? 0 : (paidAmount / amountApplied).clamp(0, 1);

  bool get isCompleted =>
      balance <= 0 || loanStatusCode == LoanStatusCode.cleared;

  bool get isInArrears => arrears > 0;

  String get status {
    if (loanStatusCode != LoanStatusCode.disbursed) {
      return loanStatusCode.label;
    }
    if (isCompleted) return 'Completed';
    if (isInArrears) return 'In arrears';
    return 'Active';
  }

  String get tenureLabel => '${tenureMonths} months';

  double get paidPercentage => progress * 100;

  String get progressLabel => '${paidPercentage.toStringAsFixed(0)}% repaid';

  int get monthsElapsed {
    final now = DateTime.now();
    int months = (now.year - applicationDate.year) * 12 +
        now.month -
        applicationDate.month;
    if (now.day < applicationDate.day) {
      months -= 1;
    }
    if (months < 0) {
      months = 0;
    }
    if (months > tenureMonths) {
      months = tenureMonths;
    }
    return months;
  }

  int get monthsRemaining {
    final remaining = tenureMonths - monthsElapsed;
    return remaining < 0 ? 0 : remaining;
  }

  DateTime get nextRepaymentDate {
    if (isCompleted) {
      return completionDate;
    }
    final nextInstallmentIndex = monthsElapsed + 1;
    final tentative = DateTime(
      applicationDate.year,
      applicationDate.month + nextInstallmentIndex,
      applicationDate.day,
    );
    if (tentative.isAfter(completionDate)) {
      return completionDate;
    }
    return tentative;
  }
}
