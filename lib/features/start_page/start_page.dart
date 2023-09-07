import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:liga_shin_test/features/model/data.dart';
import 'package:liga_shin_test/features/model/data_provider.dart';
import 'package:liga_shin_test/features/start_page/services_grid/services_grid.dart';
import 'package:liga_shin_test/features/start_page/update_card/update_card.dart';
import 'package:provider/provider.dart';
import '../../data/repository/repository.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffDEC746),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('lib/assets/background.png',
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth),
            ),
            Padding(
              padding: const EdgeInsets.all(23),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          UpdateCard(
                            onTap: _initData,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                      FittedBox(
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: SvgPicture.asset('lib/assets/logo.svg'))),
                    ],),
                    FittedBox(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ServicesGrid())),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xffDEC746),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset('lib/assets/background.png').image,
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /* UpdateCard(
                onTap: _initData,
              ),*/
              // SvgPicture.asset('lib/assets/logo.svg'),
              if (!isLoading) const ServicesGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
