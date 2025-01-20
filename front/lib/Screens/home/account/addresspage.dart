import 'package:flutter/material.dart';
import 'package:sayyarti/Screens/map/widgets/list_locations.dart';
import 'package:sayyarti/model/place.dart';
import '../../service/addresspage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sayyarti/constants.dart';
import 'dart:convert';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final List<Place> _locations = [];
  bool _isLoading = false;
  void _showAllLocations() async {
    _isLoading = true;
    print("hello world:P");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('token');
    String? userId = prefs.getString('id');
    print('user id: $userId');
    print('jwt token: $jwtToken');
    final backUrl = Uri.http(backendUrl, '/user/get-address/$userId');
    final backRes = await http.get(
      backUrl,
      headers: {'Content-Type': 'application/json', 'token': '$jwtToken'},
    );
    try {
      if (backRes.statusCode == 200) {
        final response = json.decode(backRes.body);
        final List<dynamic> data = response['addresses'];
        final List<Place> loadedLocations = [];
        for (var location in data) {
          loadedLocations.add(Place(
            address: location['address'],
            latitude: location['lat'],
            longitude: location['lng'],
            isDefault: location['is_default'],
          ));
        }
        setState(() {
          _locations.addAll(loadedLocations);
          _isLoading = false;
        });
      } else {
        if (!context.mounted) {
          print('no context mounted');
          return;
        }
        final Map<String, dynamic> err = json.decode(backRes.body);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(err['message'].toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _showAllLocations();
  }

  void _savePlace(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${dotenv.env['GOOGLE_MAPS_API_KEY']}');
    final res = await http.get(url);
    final resData = json.decode(res.body);
    final address = resData['results'][0]['formatted_address'];
    //add api call to user add address
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('token');
    String? userId = prefs.getString('id');
    final backUrl = Uri.http(backendUrl, '/user/add-address/$userId');
    final backRes = await http.post(
      backUrl,
      headers: {'Content-Type': 'application/json', 'token': '$jwtToken'},
      body: json.encode({
        'lat': lat,
        'lng': lng,
        'address': address,
      }),
    );
    if (backRes.statusCode == 200) {
      setState(() {
        _locations.add(Place(
            address: address, latitude: lat, longitude: lng, isDefault: false));
      });
    } else {
      if (!context.mounted) {
        print('no context mounted');
        return;
      }
      final Map<String, dynamic> err = json.decode(res.body);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(err['message'].toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
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
        child: LocationList(locations: _locations, isLoading: _isLoading),
      ),
    );
  }
}
