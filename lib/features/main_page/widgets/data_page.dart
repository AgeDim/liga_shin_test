import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/style/style_lybrary.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../info_page/info_page.dart';
import 'diamondClipper.dart';

class DataPage extends StatefulWidget {
  final List<dynamic> points;
  final void Function(dynamic) updatePlacemark;

  const DataPage(
      {super.key, required this.points, required this.updatePlacemark});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  Future<void> _launchNavigation(dynamic st) async {
    final url = 'geo:${st.coordinates.lat},${st.coordinates.long}';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch navigation';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: widget.points.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InfoPage(point: widget.points[index])));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white30,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: Text(
                        "${widget.points[index].name}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (widget.points[index].address != null)
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(
                          "${widget.points[index].address}",
                        ),
                      ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          if (widget.points[index].place != null)
                            Container(
                              padding: const EdgeInsets.all(7),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: const BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Text(
                                '${widget.points[index].place}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          if (widget.points[index].number != null)
                            ElevatedButton(
                              onPressed: () =>
                                  {_makePhoneCall(widget.points[index].number)},
                              style: StyleLibrary.button.blueButton,
                              child: const Text(
                                "Позвонить",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: StyleLibrary.gradient.button),
                            child: ElevatedButton(
                              onPressed: () {
                                _launchNavigation(widget.points[index]);
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
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: StyleLibrary.gradient.button),
                            child: ElevatedButton(
                              onPressed: () {
                                widget.updatePlacemark(widget.points[index]);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.directions_car_sharp,
                                      color: Colors.black87),
                                  Text('На карте')
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
