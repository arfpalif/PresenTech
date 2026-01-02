import 'package:flutter/material.dart';
import 'package:presentech/features/hrd/tasks/views/ui/hrd_task_list.dart';

class HrdTask extends StatefulWidget {
  const HrdTask({super.key});

  @override
  State<HrdTask> createState() => _HrdTaskState();
}

class _HrdTaskState extends State<HrdTask> {
  @override
  Widget build(BuildContext context) {
    return const HrdTaskList();
  }
}
