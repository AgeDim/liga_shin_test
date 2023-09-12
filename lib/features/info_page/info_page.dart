import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liga_shin_test/features/info_page/widgets/info_map_widget.dart';
import 'package:liga_shin_test/features/services/snack_bar.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../model/data.dart';
import '../style/style_library.dart';

class InfoPage extends StatefulWidget {
  final Data point;
  final String label;
  final int distance;

  const InfoPage(
      {super.key,
      required this.point,
      required this.label,
      required this.distance});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final mapControllerCompleter = Completer<YandexMapController>();
  List<MapObject> placemarks = [];

  void _addAllPointToMap() {
    final placemark = PlacemarkMapObject(
        point: Point(
          latitude: double.parse(widget.point.tvCoords.split(',')[0]),
          longitude: double.parse(widget.point.tvCoords.split(',')[1]),
        ),
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('lib/assets/point.png'),
            rotationType: RotationType.rotate,
            scale: 1.3)),
        mapId: MapObjectId(widget.point.pageTitle),
        opacity: 1);
    setState(() {
      placemarks.add(placemark);
    });
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.label,
          style: StyleLibrary.text.black16,
        ),
        elevation: 0,
        backgroundColor: const Color(0xffDEC746),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) {
              _addAllPointToMap();
              controller
                  .moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                      target: Point(
                        latitude:
                            double.parse(widget.point.tvCoords.split(',')[0]) -
                                0.004,
                        longitude:
                            double.parse(widget.point.tvCoords.split(',')[1]),
                      ),
                      zoom: 16)));
            },
            mapObjects: placemarks,
            scrollGesturesEnabled: false,
            zoomGesturesEnabled: false,
            rotateGesturesEnabled: false,
            logoAlignment: const MapAlignment(
                horizontal: HorizontalAlignment.left,
                vertical: VerticalAlignment.bottom),
          ),
          Column(
            children: [
              Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xffdec746).withOpacity(0.95),
                        Colors.transparent,
                      ],
                      stops: const [0, 1.0],
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        style: StyleLibrary.button.white,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => InfoMapWidget(
                                label: widget.label,
                                point: widget.point,
                              ),
                            ),
                          );
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 15),
                            child: Text(
                              'Открыть на карте',
                              style: StyleLibrary.text.black20bold,
                            )),
                      ),
                    ),
                  )),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          copyToClipboard(widget.point.tvAddress);
                          SnackBarService.showSnackBar(context,
                              'Адрес скопирован в буфер обмена', false);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                'Адрес',
                                style: StyleLibrary.text.black20bold,
                              ),
                            ),
                            const Icon(Icons.copy)
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width - 100,
                          child: Text(
                            widget.point.tvAddress,
                            style: StyleLibrary.text.black16,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          'Трасса',
                          style: StyleLibrary.text.black20bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          widget.point.tvTrass!,
                          style: StyleLibrary.text.black16,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            copyToClipboard(widget.point.tvCoords);
                            SnackBarService.showSnackBar(context,
                                'Координаты скопированы в буфер обмена', false);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  'Координаты',
                                  style: StyleLibrary.text.black20bold,
                                ),
                              ),
                              const Icon(Icons.copy)
                            ],
                          )),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(widget.point.tvCoords,
                            style: StyleLibrary.text.black16),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          'Расстояние до точки',
                          style: StyleLibrary.text.black20bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          '${widget.distance} метров',
                          style: StyleLibrary.text.black16,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  child: ElevatedButton(
                                    style: StyleLibrary.button.yellow,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        'Назад',
                                        style: StyleLibrary.text.black18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: ElevatedButton(
                                    style: StyleLibrary.button.red,
                                    onPressed: () {
                                      MapsLauncher.launchCoordinates(
                                          double.parse(widget.point.tvCoords
                                              .split(',')[0]),
                                          double.parse(widget.point.tvCoords
                                              .split(',')[1]));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        'Маршрут',
                                        style: StyleLibrary.text.white18,
                                      ),
                                    ),
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
              )
            ],
          )
        ],
      )),
    );
  }
}
