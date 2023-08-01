import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liga_shin_test/features/main_page/widgets/diamondClipper.dart';
import 'package:liga_shin_test/features/model/search_response.dart';
import 'package:liga_shin_test/features/services/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:http/http.dart' as http;

import '../info_page/info_page.dart';
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
  double searchWidth = 180;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initPermission().ignore();
    _textEditingController.addListener(_onSearchTextChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  void _onSearchFocusChanged() {
    setState(() {
      if (_searchFocusNode.hasFocus) {
        searchWidth = MediaQuery.of(context).size.width;
      } else {
        searchWidth = 180;
      }
    });
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
    _searchFocusNode.dispose();
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
              scale: 1.3),
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
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromBytes(await _buildUserIcon()),
            scale: 1)),
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
    _showCustomModal(context, nearestPlacemark!);
    _moveToCurrentLocation(
        AppLatLong(
            lat: double.parse(nearestPlacemark.tvCoords.split(',')[0]),
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

  Future<Uint8List> _buildUserIcon() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(150, 150);
    const shadowColor = Color(0x50000000);

    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 20);
    const shadowOffset = Offset(10, 9);
    final shadowCircleOffset = Offset(
      size.width / 2 + shadowOffset.dx,
      size.height / 2 + shadowOffset.dy,
    );
    const radius = 60.0;
    canvas.drawCircle(shadowCircleOffset, radius, shadowPaint);

    final fillPaint = Paint()
      ..color = StyleLibrary.color.marker
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final circleOffset = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(circleOffset, radius, fillPaint);
    canvas.drawCircle(circleOffset, radius, strokePaint);

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);

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
            _showCustomModal(
                context, getServiceStationByName(placemark.mapId.value));
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
            10);
      },
    );
    setState(() {
      placemarks.add(largeMapObject);
    });
  }

  void _showCustomModal(BuildContext context, Data point) {
    Future<void> launchNavigation(dynamic st) async {
      final url =
          'geo:${double.parse(point.tvCoords.split(',')[0])},${double.parse(point.tvCoords.split(',')[1])}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch navigation';
      }
    }

    showModalBottomSheet(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return ListTile(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: Text(
                              point.pageTitle,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: Text(
                        point.tvAddress,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          if (point.tvTrass != null)
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: const BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Text(
                                '${point.tvTrass}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          if (point.tvDistance != null)
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(right: 10),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Text(
                                  '${point.tvDistance} км от Москвы',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: StyleLibrary.gradient.button),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InfoPage(point: point)));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.info,
                                        color: StyleLibrary.color.darkBlue),
                                    const Text('Подробнее'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: StyleLibrary.gradient.button),
                              child: ElevatedButton(
                                onPressed: () {
                                  launchNavigation(point);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Поехали'),
                                    SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: ClipPath(
                                        clipper: DiamondClipper(),
                                        child: Container(
                                          color: Colors.amberAccent,
                                          child: const Icon(
                                            Icons.turn_right,
                                            color: Colors.red,
                                            size: 23,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: 30,
                        width: searchWidth,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: TextField(
                          focusNode: _searchFocusNode,
                          controller: _textEditingController,
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            hintText: 'Поиск города',
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.amber,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _searchFocusNode.unfocus();
                                setState(() {
                                  searchResults = [];
                                  searchWidth = 180;
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
                        SingleChildScrollView(
                          child: AnimatedContainer(
                            width: searchWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            duration: const Duration(milliseconds: 500),
                            child: ListView.builder(
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
                        ),
                    ],
                  ),
                ],
              ),
            ),
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
    );
  }
}
