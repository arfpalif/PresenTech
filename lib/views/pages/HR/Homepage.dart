import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HrdHomepage extends StatefulWidget {
  const HrdHomepage({super.key});

  @override
  State<HrdHomepage> createState() => _HrdHomepageState();
}

class _HrdHomepageState extends State<HrdHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Ini user HRD")
          ],
        ),
      ),
    );
  }
}