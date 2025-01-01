import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/map/widgets/list_locations.dart';
import 'package:sayyarti/model/place.dart';
import '../../service/addresspage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final List<Place> _locations = [];

  void _savePlace(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${dotenv.env['GOOGLE_MAPS_API_KEY']}');
    final res = await http.get(url);
    final resData = json.decode(res.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      _locations.add(Place(address: address, latitude: lat, longitude: lng));
    });
  }

  void _addAddress() async {
    final location = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const AddAddressPage(),
      ),
    );
    if (location == null) {
      return;
    }
    _savePlace(location.latitude, location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
        actions: [
          IconButton(
            onPressed: _addAddress,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LocationList(locations: _locations),
      ),
    );
  }
}
