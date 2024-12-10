import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sayyarti/Screens/map/map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  var _isGetting = false;
  LatLng? _picked;
  double? lat;
  double? lng;
  String locationImage(lat, lng) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C$lat,$lng&key=${dotenv.env['GOOGLE_MAPS_API_KEY']}';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGetting = true;
    });

    locationData = await location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null) {
      return;
    }

    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      _isGetting = false;
    });
  }

  void _selectOnMap() async {
    final pickedOnMap = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

    if (pickedOnMap == null) {
      return;
    }
    setState(() {
      lat = pickedOnMap.latitude;
      lng = pickedOnMap.longitude;
      _picked = pickedOnMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Text(
      'No Location Chosen',
      textAlign: TextAlign.center,
    );

    if (_isGetting) {
      content = const CircularProgressIndicator();
    }
    if (lat != null && lng != null) {
      content = Image.network(
        locationImage(lat, lng),
        fit: BoxFit.cover ,
        width: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 170,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              label: const Text('Select on Map'),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (_picked == null && lat != null && lng != null) {
              _picked = LatLng(lat!, lng!);
            }
            Navigator.of(context).pop(_picked);
          },
          label: const Text('Add Location'),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
