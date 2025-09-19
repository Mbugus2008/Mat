import 'package:flutter/material.dart';

import '../../../../models/member.dart';
import '../../../utils/formatters.dart';

class MemberHeader extends StatelessWidget {
  const MemberHeader({
    super.key,
    required this.member,
    required this.totalBalance,
    required this.totalArrears,
    this.lastSynced,
    this.onViewAccount,
  });

  final Member member;
  final double totalBalance;
  final double totalArrears;
  final DateTime? lastSynced;
  final VoidCallback? onViewAccount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F6E8C), Color(0xFF16324F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F6E8C).withOpacity(0.25),
            offset: const Offset(0, 18),
            blurRadius: 36,
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.directions_bus_filled,
                  size: 38,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.verified, size: 18, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Active member',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onViewAccount != null) ...[
                    const SizedBox(height: 12),
                    _AccountShortcut(onPressed: onViewAccount!),
                  ],
                  if (lastSynced != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Synced ${Formatters.timestamp(lastSynced!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _HeaderStat(
                label: 'Fleet',
                value: member.vehicles.length.toString(),
              ),
              _HeaderStat(
                label: 'Active loans',
                value: member.activeLoans.toString(),
              ),
              _HeaderStat(
                label: 'Outstanding balance',
                value: Formatters.currencyValue(totalBalance),
              ),
              _HeaderStat(
                label: 'Arrears',
                value: Formatters.currencyValue(totalArrears),
                highlight: member.hasArrears,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: highlight ? Colors.white.withOpacity(0.24) : Colors.white10,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: highlight ? Colors.white70 : Colors.white24,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _AccountShortcut extends StatelessWidget {
  const _AccountShortcut({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.account_circle_outlined),
      label: const Text('Account snapshot'),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white.withOpacity(0.16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.white.withOpacity(0.35)),
        ),
      ),
    );
  }
}
