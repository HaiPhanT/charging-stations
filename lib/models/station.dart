class Station {
  Station(
      {this.id,
      required this.latitude,
      required this.longitude,
      required this.address,
      required this.name});

  String? id;
  final double latitude;
  final double longitude;
  final String address;
  final String name;
}
