import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '/screens/map_screen.dart';
import '/widgets/previewMap.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  const LocationInput({Key? key, required this.onSelectPlace})
      : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool _previewMap = false;
  LatLng _locData = LatLng(0.0, 0.0);
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      setState(() {
        _locData = LatLng(locData.latitude!, locData.longitude!);
        _previewMap = true;
      });
    } catch (error) {
      return;
    }

    try {
      _mapController.move(LatLng(_locData.latitude, _locData.longitude), 12);
    } catch (error) {
      print("error mapController: $error");
    }

    widget.onSelectPlace(_locData.latitude, _locData.longitude);
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(isSelecting: true),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    setState(() {
      _locData = LatLng(selectedLocation.latitude, selectedLocation.longitude);
      _previewMap = true;
    });
    try {
      _mapController.move(
          LatLng(selectedLocation.latitude, selectedLocation.longitude), 12);
    } catch (error) {
      print("error mapController: $error");
    }
    widget.onSelectPlace(_locData.latitude, _locData.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: _previewMap == false
                ? const Text(
                    'No Location Chosen',
                    textAlign: TextAlign.center,
                  )
                : PreviewMap(
                    location: _locData,
                    mapController: _mapController,
                  )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _selectOnMap,
            )
          ],
        )
      ],
    );
  }
}
