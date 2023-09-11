import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../info_page/info_page.dart';
import '../../model/data.dart';
import '../../style/style_library.dart';
import 'diamond_clipper.dart';

class DataPage extends StatefulWidget {
  final void Function(Data) updatePlacemark;
  final DataType type;
  final List<Data> points;

  const DataPage(
      {super.key,
      required this.updatePlacemark,
      required this.type,
      required this.points});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage>
    with AutomaticKeepAliveClientMixin<DataPage> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                        builder: (context) => InfoPage(
                              point: widget.points[index],
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
                        widget.points[index].pageTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: Text(
                        widget.points[index].tvAddress,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          if (widget.points[index].tvTrass != null)
                            Container(
                              padding: const EdgeInsets.all(7),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: const BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Text(
                                '${widget.points[index].tvTrass}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          if (widget.points[index].tvPhonetv != '' &&
                              widget.points[index].tvPhonetv != null)
                            ElevatedButton(
                              onPressed: () => {
                                _makePhoneCall(widget.points[index].tvPhonetv!)
                              },
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
                                      double.parse(widget.points[index].tvCoords
                                          .split(',')[0]),
                                      double.parse(widget.points[index].tvCoords
                                          .split(',')[1]));
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

  @override
  bool get wantKeepAlive => true;
}
