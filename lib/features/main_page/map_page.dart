import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liga_shin_test/features/main_page/widgets/selected_placemark_card.dart';
import 'package:liga_shin_test/features/model/search_response.dart';
import 'package:liga_shin_test/features/services/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:http/http.dart' as http;

import '../model/location/app_lat_long.dart';
import '../model/data_provider.dart';
import '../model/data.dart';
import '../services/location_service.dart';
import '../style/style_library.dart';

class MapPage extends StatefulWidget {
  static const routeName = '/mapPage';
  final DataType type;

  const MapPage({super.key, required this.type});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapControllerCompleter = Completer<YandexMapController>();
  final TextEditingController _textEditingController = TextEditingController();
  LocationService locationService = LocationService();
  List<MapObject> placemarks = [];
  StreamSubscription<Position>? locationSubscription;
  PlacemarkMapObject? userLocationMarker;
  List<Data> points = [];
  Timer? _debounce;
  List<SearchResponse> searchResults = [];
  PlacemarkMapObject? selectedPlacemark;

  @override
  void initState() {
    super.initState();
    _initPermission().ignore();
    _textEditingController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      String searchText = _textEditingController.text;
      if (searchText.isNotEmpty) {
        _makeApiRequest(searchText);
      } else {
        setState(() {
          searchResults = [];
        });
      }
    });
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    _debounce?.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _makeApiRequest(String searchText) async {
    String url =
        "https://search-maps.yandex.ru/v1/?text=$searchText&type=geo&lang=ru_RU&apikey=${Constants.searchKey}";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      List<SearchResponse> results = [];
      for (var item in responseData['features']) {
        results.add(
          SearchResponse.fromJson(item),
        );
      }
      setState(() {
        searchResults = results;
      });
    }
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
    _startLocationUpdates();
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
    MapObjectId mapObjectId = const MapObjectId("userLocationMarker");
    userLocationMarker = PlacemarkMapObject(
        point: Point(
          latitude: location.lat,
          longitude: location.long,
        ),
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('lib/assets/user.png'),
              rotationType: RotationType.rotate,
              scale: 1.5),
        ),
        mapId: mapObjectId,
        opacity: 1);
    setState(() {
      placemarks.add(userLocationMarker!);
    });
    _moveToCurrentLocation(location, 12);
  }

  Future<void> _moveToCurrentLocation(
      AppLatLong appLatLong, double zoom) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: zoom,
        ),
      ),
    );
  }

  void _updateUserLocationMarker(AppLatLong appLatLong) async {
    MapObjectId mapObjectId = const MapObjectId("userLocationMarker");
    userLocationMarker = PlacemarkMapObject(
        point: Point(
          latitude: appLatLong.lat,
          longitude: appLatLong.long,
        ),
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('lib/assets/user.png'),
              rotationType: RotationType.rotate,
              scale: 1.5),
        ),
        mapId: mapObjectId,
        opacity: 1);
    final index = placemarks.indexWhere(
        (marker) => marker.mapId.value == userLocationMarker!.mapId.value);
    if (index >= 0) {
      setState(() {
        placemarks[index] = userLocationMarker!;
      });
    } else {
      placemarks.add(userLocationMarker!);
    }
  }

  void findNearestPlacemark() async {
    Point userPoint = userLocationMarker!.point;
    double minDistance = double.infinity;
    Data? nearestPlacemark;
    for (var placemark in points) {
      Point placemarkPoint = Point(
          latitude: double.parse(placemark.tvCoords.split(',')[0]),
          longitude: double.parse(placemark.tvCoords.split(',')[1]));

      double lat1 = userPoint.latitude * math.pi / 180;
      double lon1 = userPoint.longitude * math.pi / 180;
      double lat2 = placemarkPoint.latitude * math.pi / 180;
      double lon2 = placemarkPoint.longitude * math.pi / 180;

      double distance = _calculateDistance(lat1, lon1, lat2, lon2);

      if (distance < minDistance) {
        minDistance = distance;
        nearestPlacemark = placemark;
      }
    }
    setState(() {
      selectedPlacemark = PlacemarkMapObject(
          mapId: MapObjectId(nearestPlacemark!.pageTitle),
          point: Point(
            latitude: double.parse(nearestPlacemark.tvCoords.split(',')[0]),
            longitude: double.parse(nearestPlacemark.tvCoords.split(',')[1]),
          ));
    });
    _moveToCurrentLocation(
        AppLatLong(
            lat: double.parse(nearestPlacemark!.tvCoords.split(',')[0]),
            long: double.parse(nearestPlacemark.tvCoords.split(',')[1])),
        14);
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double radius = 6371;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    double distance = radius * c;
    return distance;
  }

  Future<Uint8List> _buildClusterAppearance(Cluster cluster) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(200, 200);
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    const radius = 60.0;

    final textPainter = TextPainter(
        text: TextSpan(
            text: cluster.size.toString(),
            style: const TextStyle(color: Colors.black, fontSize: 50)),
        textDirection: TextDirection.ltr);

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final textOffset = Offset((size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2);
    final circleOffset = Offset(size.height / 2, size.width / 2);

    canvas.drawCircle(circleOffset, radius, fillPaint);
    canvas.drawCircle(circleOffset, radius, strokePaint);
    textPainter.paint(canvas, textOffset);

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
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

  Data getServiceStationByName(String pageTitle) {
    return points.where((station) => station.pageTitle == pageTitle).first;
  }

  void close() {
    setState(() {
      selectedPlacemark = null;
    });
  }

  MapObject getPlaceMarkByName(String name) {
    return placemarks.where((mapObject) => mapObject.mapId.value == name).first;
  }

  void _addAllPointToMap() {
    List<PlacemarkMapObject> pl = [];
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
            Data temp = getServiceStationByName(placemark.mapId.value);
            _moveToCurrentLocation(
                AppLatLong(
                  lat: double.parse(temp.tvCoords.split(',')[0]),
                  long: double.parse(temp.tvCoords.split(',')[1]),
                ),
                13);
          },
          icon: PlacemarkIcon.single(PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage('lib/assets/point.png'),
              rotationType: RotationType.rotate,
              scale: 1.3)),
          mapId: MapObjectId(point.pageTitle),
          opacity: 1);
      pl.add(placemark);
    }
    final largeMapObject = ClusterizedPlacemarkCollection(
      mapId: const MapObjectId('map'),
      radius: 30,
      minZoom: 15,
      onClusterAdded:
          (ClusterizedPlacemarkCollection self, Cluster cluster) async {
        return cluster.copyWith(
            appearance: cluster.appearance.copyWith(
                opacity: 0.75,
                icon: PlacemarkIcon.single(PlacemarkIconStyle(
                    image: BitmapDescriptor.fromBytes(
                        await _buildClusterAppearance(cluster)),
                    scale: 1))));
      },
      placemarks: pl,
      onClusterTap: (ClusterizedPlacemarkCollection self, Cluster cluster) {
        _moveToCurrentLocation(
            AppLatLong(
                lat: cluster.appearance.point.latitude,
                long: cluster.appearance.point.longitude),
            13);
      },
    );
    setState(() {
      placemarks.add(largeMapObject);
    });
  }

  Future<void> launchNavigation(Data st) async {
    final url =
        'geo:${double.parse(st.tvCoords.split(',')[0])},${double.parse(st.tvCoords.split(',')[1])}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch navigation';
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      points = (widget.type == DataType.shimont
          ? Provider.of<DataProvider>(context).getShimont
          : widget.type == DataType.carWashing
              ? Provider.of<DataProvider>(context).getCarWashing
              : null)!;
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.type == DataType.shimont ? 'Шиномонтажи' : 'Мойки',
          style: StyleLibrary.text.black16,
        ),
        backgroundColor: const Color(0xffDEC746),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
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
            Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 12.5, left: 10),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.4),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: TextField(
                              controller: _textEditingController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Поиск города',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.amber,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      searchResults = [];
                                      _textEditingController.clear();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (searchResults.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 10, left: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey)),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _moveToCurrentLocation(
                                          searchResults[index]
                                              .geometry
                                              .coordinates,
                                          11);
                                      setState(() {
                                        searchResults = [];
                                      });
                                      _textEditingController.clear();
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        child: Text(
                                          searchResults[index].properties.name,
                                          style: StyleLibrary.text.black16,
                                        )),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      width: 40,
                      height: 40,
                      child: RawMaterialButton(
                        onPressed: _currentLocation,
                        fillColor: Colors.white70,
                        child: const Icon(Icons.my_location_sharp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: StyleLibrary.gradient.button),
                            child: ElevatedButton(
                              onPressed: () {
                                findNearestPlacemark();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.search, color: Colors.amberAccent),
                                  Text('Найти ближайший'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                    )
                  ],
                ),
              ),
            ),
            if (selectedPlacemark != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                    margin: EdgeInsets.zero,
                    child: SelectedPlacemarkCard(
                      point: getServiceStationByName(
                          selectedPlacemark!.mapId.value),
                      close: close,
                    )),
              )
          ],
        ),
      ),
    );
  }
}
