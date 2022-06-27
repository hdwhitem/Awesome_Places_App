import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PreviewMap extends StatelessWidget {
  final LatLng location;
  final MapController mapController;

  const PreviewMap({
    Key? key,
    required this.location,
    required this.mapController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: location,
        zoom: 12.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: location,
              builder: (ctx) => const Icon(
                Icons.location_on,
                color: Colors.purple,
                size: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
