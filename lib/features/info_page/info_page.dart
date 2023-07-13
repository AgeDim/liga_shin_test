import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main_page/widgets/diamondClipper.dart';
import '../style/style_lybrary.dart';

class InfoPage extends StatelessWidget {
  final dynamic point;

  const InfoPage({super.key, required this.point});

  Future<void> _launchNavigation(dynamic st) async {
    final url = 'geo:${st.coordinates.lat},${st.coordinates.long}';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch navigation';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          point.name,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lime,
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
                    point.name,
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
                        child: Text(point.address),
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
                  if (point.place != null)
                    Container(
                      padding: const EdgeInsets.all(7),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Text(
                        '${point.place}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(15),
              child: Text(point.coordinates.toString()),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: StyleLibrary.gradient.button),
              child: ElevatedButton(
                onPressed: () {
                  _launchNavigation(point);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
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
          ],
        ),
      ),
    );
  }
}
