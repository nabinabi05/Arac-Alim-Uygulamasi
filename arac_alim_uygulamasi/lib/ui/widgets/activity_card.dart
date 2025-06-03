// lib/ui/widgets/activity_card.dart

import 'package:flutter/material.dart';
import '../../models/activity.dart';
import 'package:intl/intl.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd.MM.yyyy HH:mm');
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.notifications),
        title:
            Text(activity.title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(activity.description),
        trailing: Text(
          dateFmt.format(activity.timestamp),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
