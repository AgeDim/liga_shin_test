import 'package:liga_shin_test/features/model/location/app_lat_long.dart';

class SearchResponse {
  final String type;
  final PlaceProperties properties;
  final PlaceGeometry geometry;

  SearchResponse({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  @override
  String toString() {
    return 'SearchResponse{type: $type, properties: $properties, geometry: $geometry}';
  }

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      type: json['type'],
      properties: PlaceProperties.fromJson(json['properties']),
      geometry: PlaceGeometry.fromJson(json['geometry']),
    );
  }
}

class PlaceProperties {
  final GeocoderMetaData geocoderMetaData;
  final String description;
  final String name;
  final List<List<double>> boundedBy;

  PlaceProperties({
    required this.geocoderMetaData,
    required this.description,
    required this.name,
    required this.boundedBy,
  });

  factory PlaceProperties.fromJson(Map<String, dynamic> json) {
    return PlaceProperties(
      geocoderMetaData: GeocoderMetaData.fromJson(json['GeocoderMetaData']),
      description: json['description'],
      name: json['name'],
      boundedBy: List<List<double>>.from(json['boundedBy']
          .map((b) => List<double>.from(b.map((e) => e.toDouble())))),
    );
  }

  @override
  String toString() {
    return 'PlaceProperties{geocoderMetaData: $geocoderMetaData, description: $description, name: $name, boundedBy: $boundedBy}';
  }
}

class GeocoderMetaData {
  final String kind;
  final String text;
  final String precision;

  GeocoderMetaData({
    required this.kind,
    required this.text,
    required this.precision,
  });

  factory GeocoderMetaData.fromJson(Map<String, dynamic> json) {
    return GeocoderMetaData(
      kind: json['kind'],
      text: json['text'],
      precision: json['precision'],
    );
  }

  @override
  String toString() {
    return 'GeocoderMetaData{kind: $kind, text: $text, precision: $precision}';
  }
}

class PlaceGeometry {
  final String type;
  final AppLatLong coordinates;

  PlaceGeometry({
    required this.type,
    required this.coordinates,
  });

  factory PlaceGeometry.fromJson(Map<String, dynamic> json) {
    return PlaceGeometry(
        type: json['type'],
        coordinates: AppLatLong(
            long: List.of(json['coordinates']).first,
            lat: List.of(json['coordinates']).last));
  }

  @override
  String toString() {
    return 'PlaceGeometry{type: $type, coordinates: $coordinates}';
  }
}
