import 'package:flutter/material.dart';

class HrdLocation extends StatefulWidget {
  const HrdLocation({super.key});

  @override
  State<HrdLocation> createState() => _HrdLocationState();
}

class _HrdLocationState extends State<HrdLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("location page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("location page")
            ],
          ),
        ),
      ),
    );
  }
}