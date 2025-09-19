import 'package:flutter/material.dart';

import '../../../../models/member.dart';
import '../../../utils/formatters.dart';
import 'dashboard_empty.dart';
import 'dashboard_section.dart';

class AccountBalancesSection extends StatelessWidget {
  const AccountBalancesSection({super.key, required this.accounts});

  final List<MemberAccount> accounts;

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: 'Account balances',
      subtitle:
          'Live statement totals for your shares, deposits, and facilities.',
      child: accounts.isEmpty
          ? const DashboardEmpty(
              icon: Icons.account_balance_outlined,
              title: 'No accounts found',
              message:
                  'Once your SACCO accounts sync, their balances will appear here.',
            )
          : _AccountBalancesBody(accounts: accounts),
    );
  }
}

class _AccountBalancesBody extends StatelessWidget {
  const _AccountBalancesBody({required this.accounts});

  final List<MemberAccount> accounts;

  Map<PostingType, double> get _totalsByPostingType {
    final Map<PostingType, double> totals = <PostingType, double>{};
    for (final account in accounts) {
      if (account.postingType == PostingType.blank) {
        continue;
      }
      totals.update(
        account.postingType,
        (value) => value + account.netChange,
        ifAbsent: () => account.netChange,
      );
    }
    return totals;
  }

  double get _netPosition =>
      accounts.fold<double>(0, (sum, account) => sum + account.netChange);

  @override
  Widget build(BuildContext context) {
    final totals = _totalsByPostingType;
    final netPosition = _netPosition;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _TotalChip(
              label: 'Net position',
              value: Formatters.currencyValue(netPosition),
              isNegative: netPosition < 0,
            ),
            ...totals.entries.map(
              (entry) => _TotalChip(
                label: entry.key.label,
                value: Formatters.currencyValue(entry.value),
                isNegative: entry.value < 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: accounts
              .map((account) => _AccountBalanceCard(account: account))
              .toList(),
        ),
      ],
    );
  }
}

class _TotalChip extends StatelessWidget {
  const _TotalChip({
    required this.label,
    required this.value,
    this.isNegative = false,
  });

  final String label;
  final String value;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        isNegative ? const Color(0xFFD64550) : theme.colorScheme.primary;
    return Chip(
      avatar: Icon(
        isNegative ? Icons.trending_down_rounded : Icons.trending_up_rounded,
        size: 18,
        color: color,
      ),
      label: Text('$label: $value'),
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

class _AccountBalanceCard extends StatelessWidget {
  const _AccountBalanceCard({required this.account});

  final MemberAccount account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isNegative = account.netChange < 0;
    final Color amountColor =
        isNegative ? const Color(0xFFD64550) : theme.colorScheme.primary;

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 260, height: 150),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBFF),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE3E8FF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _iconForPostingType(account.postingType),
                  color: amountColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    account.displayName.isEmpty
                        ? account.accountNo
                        : account.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF102A43),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              Formatters.currencyValue(account.netChange),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: amountColor,
              ),
            ),
            const Spacer(),
            Text(
              account.accountNo,
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.blueGrey,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForPostingType(PostingType type) {
    switch (type) {
      case PostingType.loan:
        return Icons.request_quote_outlined;
      case PostingType.deposit:
        return Icons.savings_outlined;
      case PostingType.shares:
        return Icons.stacked_line_chart;
      case PostingType.blank:
        return Icons.account_balance_wallet_outlined;
    }
  }
}
