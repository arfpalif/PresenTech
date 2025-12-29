import 'package:flutter/material.dart';
import 'package:presentech/features/employee/homepage/view/components/absence_list_homepage.dart';
import 'package:presentech/features/employee/homepage/view/components/card_absence.dart';
import 'package:presentech/features/employee/homepage/view/components/header.dart';
import 'package:presentech/features/employee/homepage/view/components/menu.dart';
import 'package:presentech/features/employee/homepage/view/components/task_list_homepage.dart';

class EmployeeHomepage extends StatelessWidget {
  const EmployeeHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(),
              SizedBox(height: 20),
              CardAbsence(),
              SizedBox(height: 20),
              Menu(),
              SizedBox(height: 20),
              AbsenceListHomepage(),
              SizedBox(height: 20),
              TaskListHomepage(),
            ],
          ),
        ),
      ),
    );
  }
}
