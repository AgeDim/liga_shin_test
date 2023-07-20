import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liga_shin_test/features/main_page/widgets/selected_placemark_card.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../model/location/app_lat_long.dart';
import '../model/provider_shimont.dart';
import '../model/shimont.dart';
import '../services/location_service.dart';

class MapPage extends StatefulWidget {
  static const routeName = '/mapPage';
  final String type;

  const MapPage({super.key, required this.type});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapControllerCompleter = Completer<YandexMapController>();
  final LocationService locationService = LocationService();
  StreamSubscription<Position>? locationSubscription;
  PlacemarkMapObject? userLocationMarker;
  List<Data> points = [];
  List<MapObject> placemarks = [];
  PlacemarkMapObject? selectedPlacemark;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
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
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage('lib/assets/user.png'),
                rotationType: RotationType.rotate,
                scale: 1.3),
          ),
          mapId: mapObjectId,
          opacity: 1);
      setState(() {
        placemarks.add(userLocationMarker!);
      });
    } else {
      final index = placemarks.indexWhere(
          (marker) => marker.mapId.value == userLocationMarker!.mapId.value);
      if (index >= 0) {
        setState(() {
          placemarks[index] = userLocationMarker!;
        });
      }
    }
  }

  void close() {
    setState(() {
      selectedPlacemark = null;
    });
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
        animation: const MapAnimation(duration: 0.5));
  }

  dynamic getServiceStationByName(String pageTitle) {
    return points.where((station) => station.pageTitle == pageTitle).first;
  }

  MapObject getPlaceMarkByName(String name) {
    return placemarks.where((mapObject) => mapObject.mapId.value == name).first;
  }

  void _addAllPointToMap() {
    for (var point in points) {
      final placemark = PlacemarkMapObject(
          point: Point(
            latitude: double.parse(point.tvCoords.split(',')[0]),
            longitude: double.parse(point.tvCoords.split(',')[1]),
          ),
          onTap: (placemark, point) {
            setState(() {
              selectedPlacemark = placemark;
            });
          },
          icon: PlacemarkIcon.single(PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('lib/assets/point.png'),
              rotationType: RotationType.rotate,
              scale: 1.3)),
          mapId: MapObjectId(point.pageTitle),
          opacity: 1);
      setState(() {
        placemarks.add(placemark);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      points = (widget.type == "shimont"
          ? Provider.of<DataProvider>(context).shimont
          : widget.type == "carWashing"
              ? Provider.of<DataProvider>(context).carWashing
              : null)!;
    });
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            YandexMap(
              onMapCreated: (controller) {
                mapControllerCompleter.complete(controller);
                controller.moveCamera(CameraUpdate.newCameraPosition(
                    const CameraPosition(
                        target:
                            Point(latitude: 55.7522200, longitude: 37.6155600),
                        zoom: 5)));
                _addAllPointToMap();
              },
              scrollGesturesEnabled: true,
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
                width: 40,
                height: 40,
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
                      width: 40,
                      height: 40,
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
                      width: 40,
                      height: 40,
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
      bottomNavigationBar: selectedPlacemark != null
          ? Card(
              child: SelectedPlacemarkCard(
              point: getServiceStationByName(selectedPlacemark!.mapId.value),
              close: close,
            ))
          : null,
    );
  }
}
