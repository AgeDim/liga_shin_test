import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../location/app_lat_long.dart';
import '../services/location_service.dart';

class MapPage extends StatefulWidget {
  static const routeName = '/mapPage';

  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapControllerCompleter = Completer<YandexMapController>();
  final LocationService locationService = LocationService();
  StreamSubscription<Position>? locationSubscription;
  PlacemarkMapObject? userLocationMarker;
  List<MapObject> placemarks = [];

  @override
  void initState() {
    super.initState();
    _initPermission().ignore();
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  void _startLocationUpdates() {
    locationSubscription = Geolocator.getPositionStream().listen((position) {
      final appLatLong =
          AppLatLong(lat: position.latitude, long: position.longitude);
      _moveToCurrentLocation(appLatLong);
      _updateUserLocationMarker(appLatLong);
    });
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location);
    _startLocationUpdates();
  }

  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 15,
        ),
      ),
    );
  }

  void _updateUserLocationMarker(AppLatLong appLatLong) {
    final controller = mapControllerCompleter.future;
    MapObjectId mapObjectId = const MapObjectId("userLocationMarker");
    if (userLocationMarker == null) {
      userLocationMarker = PlacemarkMapObject(
        point: Point(
          latitude: appLatLong.lat,
          longitude: appLatLong.long,
        ),
        mapId: mapObjectId,
      );
      setState(() {
        placemarks.add(userLocationMarker!);
      });
    } else {
      final index = placemarks.indexWhere((marker) =>
          marker.mapId.toString() == userLocationMarker!.mapId.toString());
      if (index >= 0) {
        setState(() {
          placemarks[index] = userLocationMarker!;
        });
      }
    }
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: YandexMap(
          onMapCreated: (controller) {
            mapControllerCompleter.complete(controller);
          },
        ),
      ),
    );
  }
}
