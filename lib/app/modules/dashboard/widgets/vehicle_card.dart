import 'package:flutter/material.dart';

import '../../../../models/vehicle.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F6F8), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD8F1F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  vehicle.vehicleNo,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F304E),
                  ),
                ),
              ),
              Chip(
                label: Text(vehicle.vehicleType),
                avatar: const Icon(Icons.directions_bus, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (vehicle.route != null) ...[
            Row(
              children: [
                Icon(
                  Icons.route,
                  size: 18,
                  color: Colors.blueGrey.shade400,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    vehicle.route!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B9AAA),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                size: 18,
                color: Colors.blueGrey.shade400,
              ),
              const SizedBox(width: 8),
              Text(
                'Onboarded ${vehicle.startDateLabel}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            'Member ${vehicle.memberNo}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
