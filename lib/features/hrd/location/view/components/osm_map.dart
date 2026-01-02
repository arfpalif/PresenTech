import 'package:flutter/widgets.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/state_manager.dart';
import 'package:presentech/features/hrd/location/controller/add_location_controller.dart';

class OsmMap extends GetView<AddLocationController> {
  const OsmMap({super.key});

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      osmOption: OSMOption(
        userTrackingOption: const UserTrackingOption(
          enableTracking: false,
          unFollowUser: false,
        ),
        zoomOption: const ZoomOption(
          initZoom: 15,
          minZoomLevel: 3,
          maxZoomLevel: 19,
        ),
      ),
      controller: controller.mapController,
      onMapIsReady: (isReady) async {
        if (isReady) {
          await controller.onMapReady();
        }
      },
      onGeoPointLongPress: (GeoPoint point) async {
        print("On long pressed point: $point");
        await controller.onLongPressed(point);
      },
    );
  }
}
