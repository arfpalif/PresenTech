import 'package:flutter/material.dart';
import 'package:presentech/shared/styles/color_style.dart';
import 'package:presentech/configs/themes/themes.dart';

import 'package:presentech/utils/enum/absence_status.dart';
import 'package:presentech/utils/enum/permission_status.dart';

class ComponentBadgets extends StatelessWidget {
  final dynamic status;
  final String? text;
  final Color? color;

  const ComponentBadgets({super.key, this.status, this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final statusStr = _getStatusString(status);
    final displayColor = color ?? _getStatusColor(statusStr);
    final displayText = text ?? _getStatusText(statusStr);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: displayColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: displayColor.withOpacity(0.3), width: 1.2),
      ),
      child: Text(
        displayText,
        style: AppTextStyle.smallText.copyWith(
          color: displayColor,
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _getStatusString(dynamic status) {
    if (status == null) return '';
    if (status is AbsenceStatus) {
      if (status == AbsenceStatus.terlambat) return 'telat';
      return status.name;
    }
    if (status is PermissionStatus) {
      return status.name;
    }
    return status.toString().toLowerCase().split('.').last;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'hadir':
      case 'approved':
      case 'low':
      case 'success':
        return ColorStyle.greenPrimary;
      case 'telat':
      case 'terlambat':
      case 'pending':
      case 'medium':
      case 'warning':
        return ColorStyle.yellowPrimary;
      case 'alfa':
      case 'rejected':
      case 'high':
      case 'error':
        return ColorStyle.redPrimary;
      case 'todo':
        return Colors.blue;
      case 'on_progress':
        return Colors.orange;
      case 'finished':
        return ColorStyle.greenPrimary;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    if (status.isEmpty) return "-";
    if (status == 'terlambat' || status == 'telat') return 'Telat';
    if (status == 'on_progress') return 'On Progress';
    if (status == 'todo') return 'To Do';
    return status[0].toUpperCase() + status.substring(1);
  }
}

class StatusBadge extends StatelessWidget {
  final dynamic status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final statusStr = _getStatusString(status);
    final color = _getStatusColor(statusStr);
    
    return Container(
      height: 14,
      width: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }

  String _getStatusString(dynamic status) {
    if (status == null) return '';
    if (status is AbsenceStatus) {
      if (status == AbsenceStatus.terlambat) return 'telat';
      return status.name;
    }
    if (status is PermissionStatus) {
      return status.name;
    }
    return status.toString().toLowerCase().split('.').last;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'hadir':
      case 'approved':
        return ColorStyle.greenPrimary;
      case 'telat':
      case 'terlambat':
      case 'pending':
        return ColorStyle.yellowPrimary;
      case 'alfa':
      case 'rejected':
        return ColorStyle.redPrimary;
      default:
        return Colors.grey;
    }
  }
}
