import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/model/data.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../main_page/widgets/diamond_clipper.dart';
import '../style/style_library.dart';

class InfoPage extends StatelessWidget {
  final Data point;
  final String label;

  const InfoPage({super.key, required this.point, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          label,
          style: StyleLibrary.text.black16,
        ),
        backgroundColor: const Color(0xffDEC746),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Image.asset('lib/assets/car.png')),
            Card(
              margin: const EdgeInsets.all(15),
              elevation: 2,
              child: Column(
                children: [
                  Text(
                    point.pageTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: const Icon(Icons.home),
                      ),
                      Expanded(
                        child: Text(point.tvAddress),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                children: [
                  if (point.tvTrass != null)
                    Container(
                      padding: const EdgeInsets.all(7),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Text(
                        '${point.tvTrass}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(15),
              child: Text("GPS координаты: ${point.tvCoords}"),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () {
                  MapsLauncher.launchCoordinates(
                      double.parse(point.tvCoords.split(',')[0]),
                      double.parse(point.tvCoords.split(',')[1]));
                },
                style: ButtonStyle(
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.zero)),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: StyleLibrary.gradient.button,
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    constraints: const BoxConstraints(minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ),
          ],
        ),
      ),
    );
  }
}
