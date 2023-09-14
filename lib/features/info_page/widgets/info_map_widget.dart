import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../model/data.dart';
import '../../style/style_library.dart';

class InfoMapWidget extends StatefulWidget {
  final Data point;

  const InfoMapWidget({super.key, required this.point});

  @override
  State<InfoMapWidget> createState() => _InfoMapWidgetState();
}

class _InfoMapWidgetState extends State<InfoMapWidget> {
  final mapControllerCompleter = Completer<YandexMapController>();
  List<MapObject> placemarks = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.point.pageTitle,
          style: StyleLibrary.text.black16,
        ),
        elevation: 0,
        backgroundColor: const Color(0xffDEC746),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
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
                              double.parse(widget.point.tvCoords.split(',')[0]),
                          longitude:
                              double.parse(widget.point.tvCoords.split(',')[1]),
                        ),
                        zoom: 16)));
                mapControllerCompleter.complete(controller);
              },
              mapObjects: placemarks,
              logoAlignment: const MapAlignment(
                  horizontal: HorizontalAlignment.left,
                  vertical: VerticalAlignment.bottom),
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
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: StyleLibrary.gradient.button),
                            child: ElevatedButton(
                              style: StyleLibrary.button.red,
                              onPressed: () {
                                MapsLauncher.launchCoordinates(
                                    double.parse(
                                        widget.point.tvCoords.split(',')[0]),
                                    double.parse(
                                        widget.point.tvCoords.split(',')[1]));
                              },
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  'Построить маршрут',
                                  style: StyleLibrary.text.white15,
                                ),
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
          ],
        ),
      ),
    );
  }
}
