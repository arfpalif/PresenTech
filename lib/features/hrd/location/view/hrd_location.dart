import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:presentech/features/views/components/Gradient_btn.dart';
import 'package:presentech/features/views/themes/themes.dart';

class HrdLocation extends StatefulWidget {
  const HrdLocation({super.key});

  @override
  State<HrdLocation> createState() => _HrdLocationState();
}

class _HrdLocationState extends State<HrdLocation> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _acceptanceController = TextEditingController();
  String? selectedLevel;
  String? selectedPriority;
  MapController mapController = MapController(
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "location page",
          style: AppTextStyle.heading1.copyWith(color: Colors.white),
        ),
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: OSMFlutter(
                  controller: mapController,
                  onMapIsReady: (isReady) async {
                    if (isReady) {
                      await mapController.setZoom(zoomLevel: 15);
                      await mapController.goToLocation(
                        GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
                      );
                    }
                  },
                  osmOption: OSMOption(
                    userTrackingOption: const UserTrackingOption(
                      enableTracking: true,
                      unFollowUser: false,
                    ),
                    zoomOption: const ZoomOption(
                      initZoom: 8,
                      minZoomLevel: 3,
                      maxZoomLevel: 19,
                    ),
                    userLocationMarker: UserLocationMaker(
                      personMarker: const MarkerIcon(
                        icon: Icon(
                          Icons.location_history_rounded,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                      directionArrowMarker: const MarkerIcon(
                        icon: Icon(Icons.double_arrow, size: 48),
                      ),
                    ),
                    roadConfiguration: const RoadOption(
                      roadColor: Colors.yellowAccent,
                    ),
                  ),
                ),
              ),
              Text("Location name", style: AppTextStyle.heading1),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _taskTitleController,
                obscureText: false,
                decoration: InputDecoration(prefixIcon: Icon(Icons.email)),
              ),
              Text("Address", style: AppTextStyle.heading1),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _taskTitleController,
                obscureText: false,
                decoration: InputDecoration(prefixIcon: Icon(Icons.email)),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Level", style: AppTextStyle.heading1),
                        ),
                        DropdownButton<String>(
                          value: selectedLevel,
                          hint: const Text("Level"),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLevel = newValue;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              value: "easy",
                              child: Text("easy"),
                            ),
                            DropdownMenuItem(
                              value: "medium",
                              child: Text("medium"),
                            ),
                            DropdownMenuItem(
                              value: "hard",
                              child: Text("hard"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Priority", style: AppTextStyle.heading1),
                        ),
                        DropdownButton<String>(
                          value: selectedPriority,
                          hint: const Text("Priority"),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPriority = newValue;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              value: "high",
                              child: Text("high"),
                            ),
                            DropdownMenuItem(
                              value: "medium",
                              child: Text("medium"),
                            ),
                            DropdownMenuItem(value: "low", child: Text("low")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text("Acceptance criteria", style: AppTextStyle.heading1),
              TextField(
                keyboardType: TextInputType.text,
                controller: _acceptanceController,
                obscureText: false,
                decoration: InputDecoration(prefixIcon: Icon(Icons.email)),
              ),
              SizedBox(height: 10),
              AppGradientButton(text: "Submit", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
