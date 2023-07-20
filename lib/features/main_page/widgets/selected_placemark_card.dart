import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../info_page/info_page.dart';
import '../../model/shimont.dart';
import '../../style/style_lybrary.dart';
import 'diamondClipper.dart';

class SelectedPlacemarkCard extends StatelessWidget {
  final Data point;
  final Function() close;

  const SelectedPlacemarkCard(
      {super.key, required this.point, required this.close});

  Future<void> _launchNavigation(dynamic st) async {
    final url =
        'geo:${double.parse(point.tvCoords.split(',')[0])},${double.parse(point.tvCoords.split(',')[1])}';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch navigation';
    }
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
                  margin: const EdgeInsets.all(5),
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
                if(point.tvDistance != null)
                Container(
                    padding: const EdgeInsets.all(7),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Text(
                      '${point.tvDistance} км от Москвы',
                      style: const TextStyle(color: Colors.white),
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
                                builder: (context) => InfoPage(point: point)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.info, color: StyleLibrary.color.darkBlue),
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
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
