import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/main_page/widgets/map_page.dart';
import 'package:liga_shin_test/features/model/location/app_lat_long.dart';
import 'package:liga_shin_test/features/model/service_station.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
