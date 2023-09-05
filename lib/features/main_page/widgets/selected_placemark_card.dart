import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liga_shin_test/features/model/location/app_lat_long.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../info_page/info_page.dart';
import '../../model/data.dart';
import '../../style/style_library.dart';
import 'diamondClipper.dart';

class SelectedPlacemarkCard extends StatelessWidget {
  final Data point;
  final String label;
  final Function() close;
  final AppLatLong userLocation;

  const SelectedPlacemarkCard(
      {super.key,
      required this.point,
      required this.close,
      required this.label,
      required this.userLocation});

  int calculateDistance(AppLatLong userLocation, double lat, double long) {
    double distance = Geolocator.distanceBetween(
      userLocation.lat,
      userLocation.long,
      lat,
      long,
    );

    return distance.toInt();
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    point.pageTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                  onPressed: close,
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
                      borderRadius: BorderRadius.all(Radius.circular(25)),
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
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Text(
                        '${calculateDistance(userLocation, double.parse(point.tvCoords.split(',')[0]), double.parse(point.tvCoords.split(',')[1]))} м от Вас',
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoPage(
                                    point: point,
                                    label: label,
                                  )));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: StyleLibrary.gradient.button),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.info, color: StyleLibrary.color.darkBlue),
                          Text(
                            'Подробнее',
                            style: StyleLibrary.text.white16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      MapsLauncher.launchCoordinates(
                          double.parse(point.tvCoords.split(',')[0]),
                          double.parse(point.tvCoords.split(',')[1]));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: StyleLibrary.gradient.button),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Поехали',
                            style: StyleLibrary.text.white16,
                          ),
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
  }
}
