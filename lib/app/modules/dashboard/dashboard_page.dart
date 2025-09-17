import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/member_controller.dart';
import '../../../models/member.dart';
import '../../utils/formatters.dart';
import 'widgets/account_snapshot_section.dart';
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
            if (controller.isRefreshing.value)
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F6E8C), Color(0xFF16324F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your member profile',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    member.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Member No. ${member.memberNo}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  if (lastSynced != null) ...[
                    const SizedBox(height: 18),
                    Text(
                      'Last synced ${Formatters.timestamp(lastSynced!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            AccountSnapshotSection(member: member),
          ],
        ),
      ),
    );
  }
}
