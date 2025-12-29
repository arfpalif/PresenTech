import 'package:flutter/material.dart';

class HrdReports extends StatefulWidget {
  const HrdReports({super.key});

  @override
  State<HrdReports> createState() => _HrdReportsState();
}

class _HrdReportsState extends State<HrdReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("reports page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("reports page")],
          ),
        ),
      ),
    );
  }
}
