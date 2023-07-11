import 'package:liga_shin_test/features/model/location/app_lat_long.dart';

class ServiceStation {
  final String name;
  final String? address;
  final AppLatLong coordinates;
  final String? place;
  final String? number;

  ServiceStation(
      {required this.name,
      required this.coordinates,
      this.address,
      this.place,
      this.number});

  factory ServiceStation.fromJson(Map<String, dynamic> json) {
    return ServiceStation(
      name: json["name"],
      address: json["address"],
      coordinates: AppLatLong.fromJson(json["coordinates"]),
      place: json["place"],
      number: json["number"],
    );
  }
}
