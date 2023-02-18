// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:great_places/screens/map_screen.dart';
import 'package:great_places/utils/location_util.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPosition;

  const LocationInput({
    Key? key,
    required this.onSelectPosition,
  }) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreviewImage(double latitude, double longitude) {
    final staticMapImageUrl = LocationUtil.genarateLocationPreviewImage(
      latitude: latitude,
      longitude: longitude,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreviewImage(locData.latitude!, locData.longitude!);
      widget.onSelectPosition(
        LatLng(
          locData.latitude!,
          locData.longitude!,
        ),
      );
    } catch (e) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final LatLng? selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const MapScreen(),
      ),
    );
    if (selectedPosition == null) return;

    _showPreviewImage(selectedPosition.latitude, selectedPosition.longitude);

    widget.onSelectPosition(selectedPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? const Text('Localização não informada')
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on),
              label: Text(
                'Localização atual',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: Text(
                'Selecione no mapa',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
