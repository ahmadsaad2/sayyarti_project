class Place {
  const Place({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.isDefault,
  });

  final double latitude;
  final double longitude;
  final String address;
  final bool isDefault;
}
