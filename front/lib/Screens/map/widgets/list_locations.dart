import 'package:flutter/material.dart';
import 'package:sayyarti/model/place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationList extends StatelessWidget {
  const LocationList({super.key, required this.locations});

  final List<Place> locations;

  String locationImage(lat, lng) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C$lat,$lng&key=${dotenv.env['GOOGLE_MAPS_API_KEY']}';
  }

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) {
      return const Center(
        child: Text('No addresses have been added yet!'),
      );
    }

    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (ctx, index) => ListTile(
        leading: CircleAvatar(
          radius: 70,
          backgroundImage: NetworkImage(
            locationImage(
                locations[index].latitude, locations[index].longitude),
          ),
        ),
        title: Text('location $index'),
        subtitle: Text(locations[index].address),
      ),
    );
  }
}
