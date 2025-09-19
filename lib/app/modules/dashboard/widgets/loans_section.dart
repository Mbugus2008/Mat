import 'package:flutter/material.dart';

import '../../../../models/loan.dart';
import '../../../utils/formatters.dart';
import 'dashboard_empty.dart';
import 'dashboard_section.dart';
import 'loan_card.dart';

class LoansSection extends StatelessWidget {
  const LoansSection({
    super.key,
    required this.loans,
    required this.totalDisbursed,
    required this.totalPaid,
    required this.totalOutstanding,
    required this.totalArrears,
  });

  final List<Loan> loans;
  final double totalDisbursed;
  final double totalPaid;
  final double totalOutstanding;
  final double totalArrears;

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: 'Loans (${loans.length})',
      subtitle: 'Monitor facility balances, repayments, and arrears health.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _SummaryChip(
                icon: Icons.payments_outlined,
                label: 'Total disbursed',
                value: Formatters.currencyValue(totalDisbursed),
              ),
              _SummaryChip(
                icon: Icons.savings_outlined,
                label: 'Repaid',
                value: Formatters.currencyValue(totalPaid),
              ),
              _SummaryChip(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Outstanding',
                value: Formatters.currencyValue(totalOutstanding),
              ),
              _SummaryChip(
                icon: Icons.report_problem_outlined,
                label: 'Arrears',
                value: Formatters.currencyValue(totalArrears),
                highlight: totalArrears > 0,
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (loans.isEmpty)
            const DashboardEmpty(
              icon: Icons.account_balance_outlined,
              title: 'No loans yet',
              message: 'Loan applications will be listed here once disbursed.',
            )
          else
            Column(
              children: loans
                  .map((loan) => LoanCard(loan: loan))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = highlight ? const Color(0xFFD64550) : theme.colorScheme.primary;
    return Chip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(value),
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: color,
      ),
      side: BorderSide(color: color.withOpacity(0.35)),
      backgroundColor: color.withOpacity(0.12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}
