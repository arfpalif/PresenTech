import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presentech/shared/models/absence.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/shared/view/widgets/app_card.dart';
import 'package:presentech/configs/themes/themes.dart';

class AbsenceCard extends StatelessWidget {
  final Absence absence;
  final String? title;
  final EdgeInsets? margin;

  const AbsenceCard({
    super.key,
    required this.absence,
    this.title,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    String formatTime(String? time) {
      if (time == null || time.isEmpty) return '-';
      try {
        return time.length >= 5 ? time.substring(0, 5) : time;
      } catch (_) {
        return time;
      }
    }

    return AppCard(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: StatusBadge(status: absence.status),
        title: Text(
          title ?? DateFormat('EEEE, dd MMM yyyy').format(absence.date),
          style: AppTextStyle.heading2.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              const Icon(
                Icons.login,
                size: 14,
                color: Colors.green,
              ),
              const SizedBox(width: 4),
              Text(
                formatTime(absence.clockIn),
                style: AppTextStyle.normal.copyWith(
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.logout, size: 14, color: Colors.red),
              const SizedBox(width: 4),
              Text(
                formatTime(absence.clockOut),
                style: AppTextStyle.normal.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        trailing: ComponentBadgets(status: absence.status),
      ),
    );
  }
}
