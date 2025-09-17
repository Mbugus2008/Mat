import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/member_controller.dart';
import '../../../models/member.dart';
import 'widgets/account_snapshot_section.dart';
import 'widgets/error_banner.dart';
import 'widgets/loans_section.dart';
import 'widgets/member_header.dart';
import 'widgets/vehicles_section.dart';

class MemberDashboardPage extends GetView<MemberController> {
  const MemberDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && !controller.hasData) {
            return const _LoadingState();
          }

          if (controller.errorMessage.value != null && !controller.hasData) {
            return _ErrorState(
              message: controller.errorMessage.value!,
              onRetry: controller.loadMember,
            );
          }

          if (!controller.hasData) {
            return const _LoadingState();
          }

          final Member member = controller.member!;

          return Stack(
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
                        child: MemberHeader(
                          member: member,
                          totalBalance: member.totalBalance,
                          totalArrears: member.totalArrears,
                          lastSynced: controller.lastUpdated.value,
                        ),
                      ),
                    ),
                    if (controller.errorMessage.value != null)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        sliver: SliverToBoxAdapter(
                          child: ErrorBanner(
                            message: controller.errorMessage.value!,
                            onRetry: () => controller.loadMember(forceRefresh: true),
                            onDismiss: controller.dismissError,
                          ),
                        ),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      sliver: SliverToBoxAdapter(
                        child: AccountSnapshotSection(member: member),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      sliver: SliverToBoxAdapter(
                        child: VehiclesSection(
                          vehicles: member.vehiclesByStartDate,
                          typeBreakdown: member.vehicleTypeBreakdown,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                      sliver: SliverToBoxAdapter(
                        child: LoansSection(
                          loans: member.loansByApplicationDate,
                          totalDisbursed: member.totalDisbursed,
                          totalPaid: member.totalPaid,
                          totalOutstanding: member.totalBalance,
                          totalArrears: member.totalArrears,
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
        }),
      ),
    );
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
