import 'package:flutter/material.dart';
import '/models/place.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  const MapScreen(
      {Key? key,
      this.initialLocation = const PlaceLocation(
          latitude: 41.139747, longitude: -8.609290, address: ''),
      this.isSelecting = false})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _kMapCenter = LatLng(41.139747, -8.609290);
  late LatLng _pickedLocation = _kMapCenter;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Map'),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            )
        ],
      ),
      body: Stack(children: [
        if (widget.isSelecting)
          FlutterMap(
            options: MapOptions(
              onTap: (tapPosition, point) async {
                setState(() {
                  _pickedLocation = point;
                });
              },
              center: _pickedLocation,
              zoom: 12.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _pickedLocation,
                    builder: (ctx) => const Icon(
                      Icons.location_on,
                      color: Colors.purple,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        if (widget.isSelecting == false)
          FlutterMap(
            options: MapOptions(
              center: LatLng(widget.initialLocation.latitude,
                  widget.initialLocation.longitude),
              zoom: 12.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(widget.initialLocation.latitude,
                        widget.initialLocation.longitude),
                    builder: (ctx) => const Icon(
                      Icons.location_on,
                      color: Colors.purple,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ]),
    );
  }
}
