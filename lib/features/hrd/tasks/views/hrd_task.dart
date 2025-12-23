import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:presentech/features/views/themes/themes.dart';

class HrdTask extends StatefulWidget {
  const HrdTask({super.key});

  @override
  State<HrdTask> createState() => _HrdTaskState();
}

class _HrdTaskState extends State<HrdTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HRD Task', style: AppTextStyle.heading1.copyWith(color: Colors.white),),
      backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[AppColors.colorPrimary, AppColors.colorSecondary],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('src/images/ic_signup.svg'),
            SizedBox(height: 20),
            Text("Coming Soon", style: AppTextStyle.heading1),
          ],
        ),
      ),
    );
  }
}
