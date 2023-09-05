import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liga_shin_test/features/contact_page/contact_page.dart';
import 'package:liga_shin_test/features/model/data.dart';
import 'package:liga_shin_test/features/model/data_provider.dart';
import 'package:liga_shin_test/features/start_page/service_card/servicee_card.dart';
import 'package:liga_shin_test/features/style/style_library.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repository/repository.dart';
import '../main_page/map_page.dart';
import '../promo_page/promo_page.dart';
import '../services/snack_bar.dart';

class StartPage extends StatefulWidget {
  static const routeName = '/startPage';

  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final Repository repository = GetIt.instance<Repository>();
  String updatedTime = '';
  bool isLoading = true;
  final GlobalKey<State> _loadingDialogKey = GlobalKey<State>();

  String formatDate(String dateStr) {
    if (dateStr != "") {
      final parsedDateTime = DateTime.parse(dateStr);
      final formatter = StyleLibrary.date.formatter;
      return formatter.format(parsedDateTime);
    }
    return "";
  }

  Future<void> _showLoadingDialog() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Секундочку, загружаю данные о точках ТО",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              key: _loadingDialogKey,
            ),
          );
        });
  }

  _setUpdTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      updatedTime = prefs.getString(DataType.lastUpdate.name)!;
    });
  }

  void _initData() async {
    try {
      _showLoadingDialog();
      List<Data> carWashingData = await repository.getAll(DataType.carWashing);
      List<Data> shimontData = await repository.getAll(DataType.shimont);
      Provider.of<DataProvider>(context, listen: false)
          .setCarWashing(carWashingData);
      Provider.of<DataProvider>(context, listen: false).setShimont(shimontData);
    } catch (e) {
      SnackBarService.showSnackBar(
        context,
        e.toString(),
        false,
      );
    } finally {
      Navigator.of(_loadingDialogKey.currentContext!).pop();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  Widget getCard(index) {
    final cards = [
      ServiceCard(
        onTap: context.read<DataProvider>().getShimont.isEmpty
            ? () {
                SnackBarService.showSnackBar(
                    context,
                    "Нет данных для отображения, пожалуйста обновите данные",
                    true);
              }
            : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MapPage(type: DataType.shimont),
                  ),
                );
              },
        name: 'Шиномонтаж',
        image: SvgPicture.asset('lib/assets/tire.svg'),
      ),
      ServiceCard(
        onTap: context.read<DataProvider>().getCarWashing.isEmpty
            ? () => {
                  SnackBarService.showSnackBar(
                      context,
                      "Нет данных для отображения, пожалуйста обновите данные",
                      true)
                }
            : () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MapPage(type: DataType.carWashing)))
                },
        name: 'Мойки',
        image: SvgPicture.asset('lib/assets/car-wash.svg'),
      ),
      ServiceCard(
        onTap: () {
          Navigator.pushNamed(context, ContactPage.routeName);
        },
        name: 'Контакты',
        image: SvgPicture.asset('lib/assets/contact-mail.svg'),
      ),
      ServiceCard(
        onTap: () {
          Navigator.pushNamed(context, PromoPage.routeName);
        },
        name: 'Промо',
        image: SvgPicture.asset('lib/assets/hot-sale.svg'),
      ),
    ];

    return cards[index];
  }

  @override
  Widget build(BuildContext context) {
    _setUpdTime();
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'lib/assets/background.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0x00e0cb52),
                    Color(0xffDEC746),
                  ])),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(top: 20, right: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              _initData();
                              _setUpdTime();
                            },
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      const EdgeInsets.all(10)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              elevation: MaterialStateProperty.all<double>(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(
                                  Ionicons.sync_outline,
                                  color: Colors.black,
                                  size: 40,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Обновить данные',
                                        style: StyleLibrary.text.black14,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          'Данные от: ${formatDate(updatedTime)}',
                                          style: StyleLibrary.text.gray12,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset('lib/assets/logo.svg'),
                    if (!isLoading)
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: getCard(0)),
                                        const SizedBox(width: 10),
                                        Expanded(child: getCard(1)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(child: getCard(2)),
                                        const SizedBox(width: 10),
                                        Expanded(child: getCard(3)),
                                      ],
                                    )
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: getCard(0)),
                                        const SizedBox(width: 10),
                                        Expanded(child: getCard(1)),
                                        const SizedBox(width: 10),
                                        Expanded(child: getCard(2)),
                                        const SizedBox(width: 10),
                                        Expanded(child: getCard(3)),
                                      ],
                                    ),
                                  ],
                                )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
