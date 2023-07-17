import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/main_page/widgets/map_page.dart';
import 'package:liga_shin_test/features/model/location/app_lat_long.dart';
import 'package:liga_shin_test/features/model/service_station.dart';
import 'package:liga_shin_test/features/style/style_lybrary.dart';

import 'widgets/data_page.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/mainPage';

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showFab = true;
  int? sort = 0;

  void _handleTabChange() {
    if (_tabController.index == 0) {
      setState(() {
        _showFab = true;
      });
    } else {
      setState(() {
        _showFab = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _showCustomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 200,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Сортировка:'),
                    Column(
                      children: [
                        RadioListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Text("по расстоянию от Москвы"),
                          value: 0,
                          groupValue: sort,
                          onChanged: (value) {
                            setState(() {
                              sort = value;
                            });
                          },
                        ),
                        RadioListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: Text("от ближайшего"),
                          value: 1,
                          groupValue: sort,
                          onChanged: (value) {
                            setState(() {
                              sort = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Text('Фильтр по трассам:'),
                    SizedBox(
                      height: 50,
                      child: Container(
                        margin: const EdgeInsets.all(7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Отмена',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: StyleLibrary.gradient.button),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Применить'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ServiceStation> serviceStations = [
      ServiceStation(
        name: "Промзона ПАРНАС",
        coordinates: AppLatLong(lat: 60.079505, long: 30.378480),
        address: "Санкт-Петербург, Промзона ПАРНАС, проспект культуры 61",
        place: "Санкт-Петербург",
        number: "+79000000000",
      ),
      ServiceStation(
        name: "Автосервис 2",
        coordinates: AppLatLong(lat: 59.934570, long: 30.335099),
        address: "Санкт-Петербург, ул. Пушкина, 1",
        place: "Санкт-Петербург",
        number: "+79000000001",
      ),
      ServiceStation(
        name: "Автосервис 3",
        coordinates: AppLatLong(lat: 59.950000, long: 30.316667),
        address: "Санкт-Петербург, пр. Невский, 100",
        place: "Санкт-Петербург",
        number: "+79000000002",
      ),
      ServiceStation(
        name: "Автосервис 4",
        coordinates: AppLatLong(lat: 59.928829, long: 30.347773),
        address: "Санкт-Петербург, наб. реки Фонтанки, 15",
        place: "Санкт-Петербург",
        number: "+79000000003",
      ),
      ServiceStation(
        name: "Автосервис 5",
        coordinates: AppLatLong(lat: 59.942733, long: 30.279791),
        address: "Санкт-Петербург, Малая Морская ул., 3",
        place: "Санкт-Петербург",
        number: "+79000000004",
      ),
      ServiceStation(
        name: "Автосервис 6",
        coordinates: AppLatLong(lat: 59.957860, long: 30.314119),
        address: "Санкт-Петербург, ул. Рубинштейна, 5",
        place: "Санкт-Петербург",
        number: "+79000000005",
      ),
      ServiceStation(
        name: "Автосервис 7",
        coordinates: AppLatLong(lat: 59.927078, long: 30.342288),
        address: "Санкт-Петербург, Малый проспект Петроградской стороны, 7",
        place: "Санкт-Петербург",
        number: "+79000000006",
      ),
      ServiceStation(
        name: "Автосервис 8",
        coordinates: AppLatLong(lat: 59.921320, long: 30.292874),
        address: "Санкт-Петербург, Кронштадтский бульвар, 15",
        place: "Санкт-Петербург",
        number: "+79000000007",
      ),
      ServiceStation(
        name: "Автосервис 9",
        coordinates: AppLatLong(lat: 59.960654, long: 30.298284),
        address: "Санкт-Петербург, ул. Белинского, 10",
        place: "Санкт-Петербург",
        number: "+79000000008",
      ),
      ServiceStation(
        name: "Автосервис 10",
        coordinates: AppLatLong(lat: 59.943234, long: 30.399520),
        address: "Санкт-Петербург, пр. Солидарности, 5",
        place: "Санкт-Петербург",
        number: "+79000000009",
      ),
    ];

    dynamic placemark;

    void updateTargetPlacemark(dynamic mark) {
      _tabController.index = 1;
      setState(() {
        placemark = mark;
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: TabBar(
            automaticIndicatorColorAdjustment: false,
            controller: _tabController,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.red,
            tabs: const [
              Tab(
                child: Text(
                  'СПИСОК',
                ),
              ),
              Tab(
                child: Text(
                  'НА КАРТЕ',
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                DataPage(
                  points: serviceStations,
                  updatePlacemark: updateTargetPlacemark,
                ),
                Builder(builder: (BuildContext context) {
                  return MapPage(
                    points: serviceStations,
                    targetPlacemark: placemark,
                    updatePlacemark: updateTargetPlacemark,
                  );
                })
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: () {
                _showCustomModal(context);
              },
              child: const Icon(Icons.vertical_distribute_outlined),
            )
          : null,
    );
  }
}
