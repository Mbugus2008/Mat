import 'package:flutter/material.dart';

import '../../../../models/vehicle.dart';
import 'dashboard_empty.dart';
import 'dashboard_section.dart';
import 'vehicle_card.dart';

class VehiclesSection extends StatelessWidget {
  const VehiclesSection({
    super.key,
    required this.vehicles,
    required this.typeBreakdown,
  });

  final List<Vehicle> vehicles;
  final Map<String, int> typeBreakdown;

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: 'Fleet (${vehicles.length})',
      subtitle: 'Track vehicles registered under your SACCO membership.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (typeBreakdown.isNotEmpty) ...[
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: typeBreakdown.entries
                  .map(
                    (entry) => Chip(
                      avatar: const Icon(Icons.directions_bus_filled, size: 18),
                      label: Text('${entry.value} × ${entry.key}'),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 18),
          ],
          if (vehicles.isEmpty)
            const DashboardEmpty(
              icon: Icons.directions_bus_outlined,
              title: 'No vehicles yet',
              message:
                  'Your registered matatus will appear here once the SACCO onboards them.',
            )
          else
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: vehicles.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) => VehicleCard(
                  vehicle: vehicles[index],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
