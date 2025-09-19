import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/member_controller.dart';
import '../../../models/member.dart';
import '../../utils/formatters.dart';
import 'widgets/error_banner.dart';
import 'widgets/loans_section.dart';
import 'widgets/member_header.dart';
import 'widgets/vehicles_section.dart';

class MemberDashboardPage extends GetView<MemberController> {
  const MemberDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool hasData = controller.hasData;
      final bool isLoading = controller.isLoading.value;
      final String? errorMessage = controller.errorMessage.value;
      final Member? member = controller.member;
      final bool isRefreshing = controller.isRefreshing.value;

      Widget body;

      if (isLoading && !hasData) {
        body = const _LoadingState();
      } else if (errorMessage != null && !hasData) {
        body = _ErrorState(
          message: errorMessage,
          onRetry: controller.loadMember,
        );
      } else if (!hasData) {
        body = const _LoadingState();
      } else {
        final Member loadedMember = member!;
        body = Stack(
          children: [
            RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
              onRefresh: controller.refreshMember,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    sliver: SliverToBoxAdapter(
                      child: Builder(
                        builder: (headerContext) => MemberHeader(
                          member: loadedMember,
                          totalBalance: loadedMember.totalBalance,
                          totalArrears: loadedMember.totalArrears,
                          lastSynced: controller.lastUpdated.value,
                          onViewAccount: () =>
                              Scaffold.maybeOf(headerContext)?.openDrawer(),
                        ),
                      ),
                    ),
                  ),
                  if (errorMessage != null)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      sliver: SliverToBoxAdapter(
                        child: ErrorBanner(
                          message: errorMessage,
                          onRetry: () =>
                              controller.loadMember(forceRefresh: true),
                          onDismiss: controller.dismissError,
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    sliver: SliverToBoxAdapter(
                      child: VehiclesSection(
                        vehicles: loadedMember.vehiclesByStartDate,
                        typeBreakdown: loadedMember.vehicleTypeBreakdown,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                    sliver: SliverToBoxAdapter(
                      child: LoansSection(
                        loans: loadedMember.loansByApplicationDate,
                        totalDisbursed: loadedMember.totalDisbursed,
                        totalPaid: loadedMember.totalPaid,
                        totalOutstanding: loadedMember.totalBalance,
                        totalArrears: loadedMember.totalArrears,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isRefreshing)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(minHeight: 2),
              ),
          ],
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Member Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh data',
              onPressed: isRefreshing || isLoading
                  ? null
                  : () => controller.refreshMember(),
            ),
          ],
        ),
        drawer: member != null
            ? _MemberAccountDrawer(
                member: member,
                lastSynced: controller.lastUpdated.value,
              )
            : null,
        body: SafeArea(child: body),
      );
    });
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function({bool forceRefresh}) onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.1),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 56,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 18),
                Text(
                  'Connection lost',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => onRetry(forceRefresh: true),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry sync'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberAccountDrawer extends StatelessWidget {
  const _MemberAccountDrawer({
    required this.member,
    this.lastSynced,
  });

  final Member member;
  final DateTime? lastSynced;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            //_MiniAccountSnapshot(member: member),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F6E8C), Color(0xFF16324F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    member.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.memberNo,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    member.phone,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (member.joinedOn != null)
                        _DrawerInfoChip(
                          icon: Icons.calendar_month_outlined,
                          label: 'Joined',
                          value: Formatters.date(member.joinedOn!),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniAccountSnapshot extends StatelessWidget {
  const _MiniAccountSnapshot({required this.member});

  final Member member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tiles = <_MiniSnapshotTileData>[
      _MiniSnapshotTileData(
        icon: Icons.credit_card,
        label: 'Member no.',
        value: member.memberNo,
      ),
      _MiniSnapshotTileData(
        icon: Icons.badge_outlined,
        label: 'National ID',
        value: member.maskedNationalId,
      ),
      _MiniSnapshotTileData(
        icon: Icons.phone_iphone,
        label: 'Mobile',
        value: member.phone,
      ),
      _MiniSnapshotTileData(
        icon: Icons.people_outline,
        label: 'Gender',
        value: member.gender.label,
      ),
    ];
    if (member.email != null && member.email!.isNotEmpty) {
      tiles.add(
        _MiniSnapshotTileData(
          icon: Icons.email_outlined,
          label: 'Email',
          value: member.email!,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4EBFF)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: tiles
            .map((tile) => _MiniSnapshotTile(tile: tile, theme: theme))
            .toList(),
      ),
    );
  }
}

class _MiniSnapshotTileData {
  const _MiniSnapshotTileData({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _MiniSnapshotTile extends StatelessWidget {
  const _MiniSnapshotTile({required this.tile, required this.theme});

  final _MiniSnapshotTileData tile;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 150, height: 90),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE3E8FF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(tile.icon, size: 18, color: theme.colorScheme.primary),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tile.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.blueGrey.shade400,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tile.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF102A43),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerInfoChip extends StatelessWidget {
  const _DrawerInfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.black),
      label: Text('$label: $value'),
      labelStyle: theme.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      backgroundColor: Colors.white.withValues(alpha: 0.18),
      side: BorderSide(color: Colors.white.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      visualDensity: VisualDensity.compact,
    );
  }
}
