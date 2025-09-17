class Loan {
  const Loan({
    required this.loanNo,
    required this.loanType,
    required this.applicationDate,
    required this.amountApplied,
    required this.tenureMonths,
    required this.rate,
    required this.balance,
    required this.arrears,
    required this.completionDate,
  });

  final String loanNo;
  final String loanType;
  final DateTime applicationDate;
  final double amountApplied;
  final int tenureMonths;
  final double rate;
  final double balance;
  final double arrears;
  final DateTime completionDate;

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

  bool get isCompleted => balance <= 0;

  bool get isInArrears => arrears > 0;

  String get status {
    if (isCompleted) return 'Completed';
    if (isInArrears) return 'In arrears';
    return 'Active';
  }

  String get tenureLabel => '$tenureMonths months';

  double get paidPercentage => progress * 100;

  String get progressLabel => '${paidPercentage.toStringAsFixed(0)}% repaid';

  int get monthsElapsed {
    final now = DateTime.now();
    int months =
        (now.year - applicationDate.year) * 12 + now.month - applicationDate.month;
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
