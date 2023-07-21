import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/contact_page/contact_page.dart';
import 'package:liga_shin_test/features/model/provider_shimont.dart';
import 'package:liga_shin_test/features/style/style_library.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../main_page/map_page.dart';
import '../promo_page/promo_page.dart';

class StartPage extends StatefulWidget {
  static const routeName = '/startPage';

  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  String updatedTime = '';

  String formatDate(String dateStr) {
    if (dateStr != "") {
      final parsedDateTime = DateTime.parse(dateStr);
      final formatter = DateFormat("dd MMMM yyyy HH:mm", "ru");
      return formatter.format(parsedDateTime);
    }
    return "";
  }

  _setUpdTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      updatedTime = prefs.getString('lastUpdate')!;
    });
  }

  @override
  void initState() {
    super.initState();
    _setUpdTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 10),
                    child: ElevatedButton(
                      style: StyleLibrary.button.defaultButton,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MapPage(type: "shimont")));
                      },
                      child: Column(
                        children: [
                          Text(
                            'Шиномонтажи',
                            style: StyleLibrary.text.black14,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.directions_car_sharp,
                                color: Colors.black87,
                                size: 40,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 20),
                    child: ElevatedButton(
                      style: StyleLibrary.button.defaultButton,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MapPage(type: "carWashing")));
                      },
                      child: Column(
                        children: [
                          Text(
                            'Мойки',
                            style: StyleLibrary.text.black14,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.local_car_wash_outlined,
                                color: Colors.black87,
                                size: 40,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
                    child: ElevatedButton(
                      style: StyleLibrary.button.defaultButton,
                      onPressed: () {
                        Navigator.pushNamed(context, ContactPage.routeName);
                      },
                      child: Column(
                        children: [
                          Text(
                            'Контакты',
                            style: StyleLibrary.text.black14,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.contact_mail_outlined,
                                color: Colors.black87,
                                size: 40,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 20, top: 10),
                    child: ElevatedButton(
                      style: StyleLibrary.button.defaultButton,
                      onPressed: () {
                        Navigator.pushNamed(context, PromoPage.routeName);
                      },
                      child: Column(
                        children: [
                          Text(
                            'Промо',
                            style: StyleLibrary.text.black14,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.percent_outlined,
                                color: Colors.black87,
                                size: 40,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  child: Text(
                      "Последнее обновление данных: ${formatDate(updatedTime)}",
                      style: StyleLibrary.text.black14),
                ),
                IconButton(
                    onPressed: () {
                      Provider.of<DataProvider>(context, listen: false)
                          .updateLists();
                      _setUpdTime();
                    },
                    icon: const Icon(Icons.refresh_rounded))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
