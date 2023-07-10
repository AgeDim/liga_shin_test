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

  Future<void> _moveToCurrentLocation(AppLatLong appLatLong) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 17,
        ),
      ),
    );
  }

  void _updateUserLocationMarker(AppLatLong appLatLong) {
    MapObjectId mapObjectId = const MapObjectId("userLocationMarker");
    if (userLocationMarker == null) {
      userLocationMarker = PlacemarkMapObject(
        point: Point(
          latitude: appLatLong.lat,
          longitude: appLatLong.long,
        ),
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('lib/assets/user.png'),
            rotationType: RotationType.rotate)),
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

  void _zoomIn() async {
    YandexMapController controller = await mapControllerCompleter.future;
    controller.moveCamera(CameraUpdate.zoomIn(),
        animation: const MapAnimation(duration: 0.5));
  }

  void _zoomOut() async {
    YandexMapController controller = await mapControllerCompleter.future;
    controller.moveCamera(CameraUpdate.zoomOut(),
        animation: const MapAnimation(duration: 0.5));
  }

  void _currentLocation() async {
    YandexMapController controller = await mapControllerCompleter.future;
    Position currentPosition = await Geolocator.getCurrentPosition();
    AppLatLong userLocation = AppLatLong(
      lat: currentPosition.latitude,
      long: currentPosition.longitude,
    );
    controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(
              latitude: userLocation.lat,
              longitude: userLocation.long,
            ),
          ),
        ),
        animation: const MapAnimation(duration: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            YandexMap(
              onMapCreated: (controller) {
                mapControllerCompleter.complete(controller);
              },
              mapObjects: placemarks,
              logoAlignment: const MapAlignment(
                  horizontal: HorizontalAlignment.left,
                  vertical: VerticalAlignment.bottom),
            ),
            /*Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        // Handle button 1 press
                      },
                      child: const Icon(Icons.search),
                    ),
                    const SizedBox(width: 100, child: TextField())
                  ],
                ),
              ),
            ),*/
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                width: 50,
                height: 50,
                child: RawMaterialButton(
                  onPressed: _currentLocation,
                  fillColor: Colors.white70,
                  child: const Icon(Icons.my_location_sharp),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2),
                      width: 50,
                      height: 50,
                      child: RawMaterialButton(
                        onPressed: _zoomIn,
                        fillColor: Colors.white70,
                        child: const Icon(
                          Icons.add,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(2),
                      width: 50,
                      height: 50,
                      child: RawMaterialButton(
                        onPressed: _zoomOut,
                        fillColor: Colors.white70,
                        child: const Icon(
                          Icons.remove,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
