import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:liga_shin_test/features/contact_page/contact_page.dart';
import 'package:liga_shin_test/features/model/data.dart';
import 'package:liga_shin_test/features/model/data_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    _setUpdTime();
    return Scaffold(
      backgroundColor: Colors.lime,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 20),
                      child: Text(
                        "Данные от: ${formatDate(updatedTime)}",
                        style: StyleLibrary.text.black16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _initData();
                      _setUpdTime();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        elevation: MaterialStateProperty.all<double>(0)),
                    child: Row(
                      children: [
                        Text(
                          'Обновить',
                          style: StyleLibrary.text.black16,
                        ),
                        const Icon(
                          Icons.refresh_rounded,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!isLoading)
              Expanded(
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
                              onPressed: Provider.of<DataProvider>(context)
                                      .getShimont
                                      .isEmpty
                                  ? () => {
                                        SnackBarService.showSnackBar(
                                            context,
                                            "Нет данных для отображения, пожалуйста обновите данные",
                                            true)
                                      }
                                  : () => {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => const MapPage(
                                                type: DataType.shimont),
                                          ),
                                        )
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
                              onPressed: Provider.of<DataProvider>(context)
                                      .getCarWashing
                                      .isEmpty
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
                                                    const MapPage(
                                                        type: DataType
                                                            .carWashing)))
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
                            margin: const EdgeInsets.only(
                                left: 20, right: 10, top: 10),
                            child: ElevatedButton(
                              style: StyleLibrary.button.defaultButton,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, ContactPage.routeName);
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
                            margin: const EdgeInsets.only(
                                left: 10, right: 20, top: 10),
                            child: ElevatedButton(
                              style: StyleLibrary.button.defaultButton,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, PromoPage.routeName);
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
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
