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
  Set<String> selectedPlaces = <String>{};

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
    selectedPlaces = getUniquePlaces(serviceStations);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCustomModal(context);
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  List<ServiceStation> serviceStations = [
    ServiceStation(
      name: "Промзона ПАРНАС",
      coordinates: const AppLatLong(lat: 60.079505, long: 30.378480),
      address: "Санкт-Петербург, Промзона ПАРНАС, проспект культуры 61",
      place: "Санкт-Петербург",
      number: "+79000000000",
    ),
    ServiceStation(
      name: "Автосервис 2",
      coordinates: const AppLatLong(lat: 59.934570, long: 30.335099),
      address: "Санкт-Петербург, ул. Пушкина, 1",
      place: "Санкт-Петербург",
      number: "+79000000001",
    ),
    ServiceStation(
      name: "Автосервис 3",
      coordinates: const AppLatLong(lat: 59.950000, long: 30.316667),
      address: "Санкт-Петербург, пр. Невский, 100",
      place: "Санкт-Петербург",
      number: "+79000000002",
    ),
    ServiceStation(
      name: "Автосервис 4",
      coordinates: const AppLatLong(lat: 59.928829, long: 30.347773),
      address: "Санкт-Петербург, наб. реки Фонтанки, 15",
      place: "Санкт-Петербург",
      number: "+79000000003",
    ),
    ServiceStation(
      name: "Автосервис 5",
      coordinates: const AppLatLong(lat: 59.942733, long: 30.279791),
      address: "Санкт-Петербург, Малая Морская ул., 3",
      place: "Санкт-Петербург",
      number: "+79000000004",
    ),
    ServiceStation(
      name: "Автосервис 6",
      coordinates: const AppLatLong(lat: 59.957860, long: 30.314119),
      address: "Санкт-Петербург, ул. Рубинштейна, 5",
      place: "Санкт-Петербург",
      number: "+79000000005",
    ),
    ServiceStation(
      name: "Автосервис 7",
      coordinates: const AppLatLong(lat: 59.927078, long: 30.342288),
      address: "Санкт-Петербург, Малый проспект Петроградской стороны, 7",
      place: "Санкт-Петербург",
      number: "+79000000006",
    ),
    ServiceStation(
      name: "Автосервис 8",
      coordinates: const AppLatLong(lat: 59.921320, long: 30.292874),
      address: "Санкт-Петербург, Кронштадтский бульвар, 15",
      place: "Санкт-Петербург",
      number: "+79000000007",
    ),
    ServiceStation(
      name: "Автосервис 9",
      coordinates: const AppLatLong(lat: 59.960654, long: 30.298284),
      address: "Санкт-Петербург, ул. Белинского, 10",
      place: "Санкт-Петербург",
      number: "+79000000008",
    ),
    ServiceStation(
      name: "Автосервис 10",
      coordinates: const AppLatLong(lat: 59.943234, long: 30.399520),
      address: "Санкт-Петербург, пр. Солидарности, 5",
      place: "Санкт-Петербург",
      number: "+79000000009",
    ),
    ServiceStation(
      name: "Автосервис 10",
      coordinates: const AppLatLong(lat: 59.943121, long: 30.399570),
      address: "Санкт-Петербург, пр. Какой-то 1",
      place: "Санкт-Петербург",
      number: "+79000000010",
    ),
    ServiceStation(
      name: "Автосервис 10",
      coordinates: const AppLatLong(lat: 59.943365, long: 30.399630),
      address: "Санкт-Петербург, пр. Какой-то 2",
      place: "Алмата",
      number: "+79000000011",
    ),
    ServiceStation(
      name: "Автосервис 10",
      coordinates: const AppLatLong(lat: 59.943471, long: 30.399460),
      address: "Санкт-Петербург, пр. Какой-то 3",
      place: "Москва",
    ),
  ];

  dynamic placemark;

  void updateTargetPlacemark(dynamic mark) {
    _tabController.index = 1;
    setState(() {
      placemark = mark;
    });
  }

  Set<String> getUniquePlaces(List<ServiceStation> stations) {
    Set<String> uniquePlaces = <String>{};
    for (var station in stations) {
      if (station.place != null) {
        uniquePlaces.add(station.place!);
      }
    }
    return uniquePlaces;
  }

  void _showCustomModal(BuildContext context) {
    Set<String> uniquePlaces = getUniquePlaces(serviceStations);
    int? _previousSort = sort;
    List<String> _previousSelectedPlaces = selectedPlaces.toList();
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Сортировка:',
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: RadioListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text(
                            "по расстоянию от Москвы",
                            style: TextStyle(fontSize: 15),
                          ),
                          value: 0,
                          groupValue: sort,
                          onChanged: (value) {
                            setState(() {
                              sort = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: RadioListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text(
                            "от ближайшего",
                            style: TextStyle(fontSize: 15),
                          ),
                          value: 1,
                          groupValue: sort,
                          onChanged: (value) {
                            setState(() {
                              sort = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Фильтр по трассам:',
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  Wrap(spacing: 10, runSpacing: 10, children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 30,
                      width: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (selectedPlaces.length == uniquePlaces.length) {
                              selectedPlaces.clear();
                            } else {
                              selectedPlaces.addAll(uniquePlaces);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedPlaces.length == uniquePlaces.length
                                  ? Colors.lightGreen
                                  : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(
                              color: Colors.lightGreen,
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: Text(
                          'Все',
                          style: TextStyle(
                            fontSize: 13,
                            color: selectedPlaces.length == uniquePlaces.length
                                ? Colors.white
                                : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    ...uniquePlaces.map((place) {
                      bool isSelected = selectedPlaces.contains(place);
                      return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          width: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (isSelected) {
                                  selectedPlaces.remove(place);
                                } else {
                                  selectedPlaces.add(place);
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isSelected ? Colors.lightGreen : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(
                                  color: Colors.lightGreen,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            child: Text(
                              place,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ));
                    }).toList(),
                  ]),
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
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  setState(() {
                                    sort = _previousSort;
                                    selectedPlaces =
                                        _previousSelectedPlaces.toSet();
                                  });
                                  print(sort);
                                  print(selectedPlaces);
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
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  print(sort);
                                  print(selectedPlaces);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Применить'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
