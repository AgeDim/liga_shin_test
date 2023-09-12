import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../model/data.dart';
import '../../style/style_library.dart';

class InfoMapWidget extends StatefulWidget {
  final Data point;
  final String label;

  const InfoMapWidget({super.key, required this.point, required this.label});

  @override
  State<InfoMapWidget> createState() => _InfoMapWidgetState();
}

class _InfoMapWidgetState extends State<InfoMapWidget> {
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
      body: SafeArea(
        child: YandexMap(
          onMapCreated: (controller) {
            _addAllPointToMap();
            controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: Point(
                  latitude: double.parse(widget.point.tvCoords.split(',')[0]),
                  longitude: double.parse(widget.point.tvCoords.split(',')[1]),
                ),
                zoom: 16)));
          },
          mapObjects: placemarks,
          logoAlignment: const MapAlignment(
              horizontal: HorizontalAlignment.left,
              vertical: VerticalAlignment.bottom),
        ),
      ),
    );
  }
}
