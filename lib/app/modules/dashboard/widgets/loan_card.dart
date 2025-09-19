import 'package:flutter/material.dart';

import '../../../../models/loan.dart';
import '../../../utils/formatters.dart';

class LoanCard extends StatelessWidget {
  const LoanCard({super.key, required this.loan});

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color statusColor;
    if (loan.isCompleted) {
      statusColor = const Color(0xFF2DB48E);
    } else if (loan.isInArrears) {
      statusColor = const Color(0xFFD64550);
    } else {
      statusColor = theme.colorScheme.primary;
    }

    final labelColor = statusColor.computeLuminance() > 0.5
        ? const Color(0xFF0F304E)
        : Colors.white;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6ECFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.loanType,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F304E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Loan ${loan.loanNo}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Chip(
                avatar: Icon(
                  loan.isCompleted
                      ? Icons.verified
                      : loan.isInArrears
                          ? Icons.error_outline
                          : Icons.auto_graph,
                  size: 18,
                  color: statusColor,
                ),
                label: Text(loan.status),
                labelStyle: theme.textTheme.labelMedium?.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(color: statusColor.withOpacity(0.28)),
                backgroundColor: statusColor.withOpacity(0.16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _LoanMetric(
                label: 'Applied on',
                value: Formatters.date(loan.applicationDate),
              ),
              _LoanMetric(
                label: 'Tenure',
                value: loan.tenureLabel,
              ),
              _LoanMetric(
                label: 'Rate',
                value: '${loan.rate.toStringAsFixed(1)}% p.a.',
              ),
              _LoanMetric(
                label: 'Amount',
                value: Formatters.currencyValue(loan.amountApplied),
              ),
              _LoanMetric(
                label: 'Repaid',
                value: Formatters.currencyValue(loan.paidAmount),
              ),
              _LoanMetric(
                label: 'Balance',
                value: Formatters.currencyValue(loan.balance),
              ),
              _LoanMetric(
                label: 'Arrears',
                value: Formatters.currencyValue(loan.arrears),
                valueColor:
                    loan.isInArrears ? const Color(0xFFD64550) : statusColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _LoanProgress(loan: loan, statusColor: statusColor),
        ],
      ),
    );
  }
}

class _LoanMetric extends StatelessWidget {
  const _LoanMetric({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF0F304E),
          ),
        ),
      ],
    );
  }
}

class _LoanProgress extends StatelessWidget {
  const _LoanProgress({required this.loan, required this.statusColor});

  final Loan loan;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: loan.progress,
            minHeight: 10,
            backgroundColor: const Color(0xFFE6ECFF),
            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            Text(
              loan.progressLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Next due ${Formatters.date(loan.nextRepaymentDate)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.blueGrey,
              ),
            ),
            Text(
              'Matures ${Formatters.date(loan.completionDate)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
