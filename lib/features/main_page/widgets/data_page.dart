import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../info_page/info_page.dart';
import '../../model/data.dart';
import '../../model/data_provider.dart';
import '../../style/style_library.dart';
import 'diamond_clipper.dart';

class DataPage extends StatefulWidget {
  final void Function(Data) updatePlacemark;
  final DataType type;

  const DataPage(
      {super.key, required this.updatePlacemark, required this.type});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<Data> points = [];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
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
      body: SingleChildScrollView(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: points.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InfoPage(
                              point: points[index],
                              label: widget.type == DataType.shimont
                                  ? 'Шиномонтаж'
                                  : 'Мойка',
                            )));
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
                        points[index].pageTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: Text(
                        points[index].tvAddress,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          if (points[index].tvTrass != null)
                            Container(
                              padding: const EdgeInsets.all(7),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: const BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Text(
                                '${points[index].tvTrass}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          if (points[index].tvPhonetv != '' && points[index].tvPhonetv != null)
                            ElevatedButton(
                              onPressed: () =>
                                  {_makePhoneCall(points[index].tvPhonetv!)},
                              style: StyleLibrary.button.blueButton,
                              child: const Text(
                                "Позвонить",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
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
                                  MapsLauncher.launchCoordinates(
                                      double.parse(points[index].tvCoords.split(',')[0]),
                                      double.parse(points[index].tvCoords.split(',')[1]));
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
                                  widget.updatePlacemark(points[index]);
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
                      ),
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
