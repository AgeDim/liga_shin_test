import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/data.dart';
import '../model/data_provider.dart';
import '../style/style_library.dart';
import 'widgets/data_page.dart';
import 'widgets/map_page.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/mapPage';
  final DataType type;

  const MainPage({super.key, required this.type});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Data> points = [];
  Data? placemark;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void updateTargetPlacemark(Data? mark) {
    _tabController.index = 0;
    setState(() {
      placemark = mark;
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.type == DataType.shimont ? 'Шиномонтажи' : 'Мойки',
          style: StyleLibrary.text.black16,
        ),
        backgroundColor: const Color(0xffDEC746),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          TabBar(
            automaticIndicatorColorAdjustment: false,
            controller: _tabController,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.red,
            tabs: const [
              Tab(
                child: Text(
                  'НА КАРТЕ',
                ),
              ),
              Tab(
                child: Text(
                  'СПИСОК',
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                Builder(builder: (BuildContext context) {
                  return MapPage(
                    updatePlacemark: updateTargetPlacemark,
                    type: widget.type,
                    selectedPlacemark: placemark,
                    points: points,
                  );
                }),
                DataPage(
                  updatePlacemark: updateTargetPlacemark,
                  type: widget.type,
                  points: points,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
