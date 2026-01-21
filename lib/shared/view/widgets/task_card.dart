import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presentech/shared/models/tasks.dart';
import 'package:presentech/shared/view/components/component_badgets.dart';
import 'package:presentech/shared/view/widgets/app_card.dart';
import 'package:presentech/configs/themes/themes.dart';
import 'package:presentech/shared/styles/color_style.dart';

class TaskCard extends StatelessWidget {
  final Tasks task;
  final VoidCallback? onTap;
  final bool showPriority;
  final bool isOverdue;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.showPriority = false,
    this.isOverdue = false,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd-MM-yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: isOverdue
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: ColorStyle.redPrimary.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            )
          : null,
      child: AppCard(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        radius: 24,
        color: isOverdue ? const Color(0xFFFFF8F8) : Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              if (isOverdue)
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: 6,
                    decoration: const BoxDecoration(
                      color: ColorStyle.redPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isOverdue) const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isOverdue)
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: ColorStyle.redPrimary,
                                  size: 22,
                                ),
                              if (isOverdue) const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: AppTextStyle.heading2.copyWith(
                                    color: isOverdue
                                        ? ColorStyle.redPrimary
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: isOverdue
                                    ? ColorStyle.redPrimary.withOpacity(0.6)
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${dateFormatter.format(task.startDate)} - ${dateFormatter.format(task.endDate)}',
                                style: AppTextStyle.smallText.copyWith(
                                  color: isOverdue
                                      ? ColorStyle.redPrimary.withOpacity(0.8)
                                      : Colors.grey[600],
                                  fontWeight: isOverdue
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (isOverdue)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ColorStyle.redPrimary,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorStyle.redPrimary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              "OVERDUE",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ComponentBadgets(
                          status: showPriority
                              ? task.priority
                              : (task.status?.name ?? "todo"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
