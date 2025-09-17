import 'package:flutter/material.dart';

import '../../../../models/member.dart';
import '../../../utils/formatters.dart';
import 'dashboard_section.dart';

class AccountSnapshotSection extends StatelessWidget {
  const AccountSnapshotSection({super.key, required this.member});

  final Member member;

  @override
  Widget build(BuildContext context) {
    final tiles = <_SnapshotTile>[
      _SnapshotTile(
        icon: Icons.credit_card,
        label: 'Member number',
        value: member.memberNo,
      ),
      _SnapshotTile(
        icon: Icons.badge_outlined,
        label: 'National ID',
        value: member.maskedNationalId,
      ),
      _SnapshotTile(
        icon: Icons.phone_iphone,
        label: 'Mobile',
        value: member.phone,
      ),
      _SnapshotTile(
        icon: Icons.people_outline,
        label: 'Gender',
        value: member.gender.label,
      ),
    ];

    if (member.branch != null) {
      tiles.add(
        _SnapshotTile(
          icon: Icons.location_city_outlined,
          label: 'Branch',
          value: member.branch!,
        ),
      );
    }

    if (member.joinedOn != null) {
      tiles.add(
        _SnapshotTile(
          icon: Icons.calendar_month_outlined,
          label: 'Joined',
          value: Formatters.date(member.joinedOn!),
        ),
      );
    }

    if (member.email != null) {
      tiles.add(
        _SnapshotTile(
          icon: Icons.email_outlined,
          label: 'Email',
          value: member.email!,
        ),
      );
    }

    return DashboardSection(
      title: 'Account snapshot',
      subtitle: 'Your SACCO registration and contact details at a glance.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 680;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: tiles
                .map((tile) => _SnapshotCard(tile: tile, isWide: isWide))
                .toList(),
          );
        },
      ),
    );
  }
}

class _SnapshotTile {
  const _SnapshotTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _SnapshotCard extends StatelessWidget {
  const _SnapshotCard({required this.tile, required this.isWide});

  final _SnapshotTile tile;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = isWide ? 240.0 : 200.0;
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: width, height: 140),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFF),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE0E7FF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(tile.icon, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              tile.label,
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 0.6,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              tile.value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF102A43),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
