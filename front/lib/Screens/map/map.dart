import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sayyarti/model/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const Place(
      latitude: 32.227551,
      longitude: 35.2180505,
      address: 'An-Najah National University',
    ),
    this.isSelecting = true,
  });

  final Place location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
        actions: !widget.isSelecting
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    Navigator.of(context).pop(_pickedLocation);
                  },
                ),
              ],
      ),
      body: GoogleMap(
        onTap:!widget.isSelecting ?null:(position) {
          setState(() {
            _pickedLocation = position;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 16,
        ),
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation != null
                      ? _pickedLocation!
                      : LatLng(
                          widget.location.latitude,
                          widget.location.longitude,
                        ),
                ),
              },
      ),
    );
  }
}
