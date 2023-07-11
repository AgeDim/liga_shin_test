import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/contact_page/contact_page.dart';
import 'package:liga_shin_test/features/main_page/main_page.dart';
import 'package:liga_shin_test/features/style/style_lybrary.dart';

import '../promo_page/promo_page.dart';

class StartPage extends StatefulWidget {
  static const routeName = '/startPage';

  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime,
      body: Container(
        alignment: Alignment.center,
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 10),
                    child: ElevatedButton(
                      style: StyleLibrary.button.defaultButton,
                      onPressed: () {
                        Navigator.pushNamed(context, MainPage.routeName);
                      },
                      child: const Column(
                        children: [
                          Text(
                            'Шиномонтажи',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.directions_car_sharp,
                            color: Colors.black87,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 20),
                    child: ElevatedButton(
                      style: StyleLibrary.button.defaultButton,
                      onPressed: () {
                        Navigator.pushNamed(context, MainPage.routeName);
                      },
                      child: const Column(
                        children: [
                          Text(
                            'Мойки',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.local_car_wash_outlined,
                            color: Colors.black87,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 10, top: 10),
                    child: ElevatedButton(
                      style: StyleLibrary.button.defaultButton,
                      onPressed: () {
                        Navigator.pushNamed(context, ContactPage.routeName);
                      },
                      child: const Column(
                        children: [
                          Text(
                            'Контакты',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.contact_mail_outlined,
                            color: Colors.black87,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 20, top: 10),
                    child: ElevatedButton(
                      style: StyleLibrary.button.defaultButton,
                      onPressed: () {
                        Navigator.pushNamed(context, PromoPage.routeName);
                      },
                      child: const Column(
                        children: [
                          Text(
                            'Промо',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.percent_outlined,
                            color: Colors.black87,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
