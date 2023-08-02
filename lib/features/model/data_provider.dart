import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/model/data.dart';

class DataProvider with ChangeNotifier {
  List<Data> _shimont = [];

  List<Data> _carWashing = [];

  List<Data> get getShimont => _shimont;

  List<Data> get getCarWashing => _carWashing;

  Future<void> setCarWashing(List<Data> futureData) async {
    _carWashing = futureData;
    notifyListeners();
  }

  Future<void> setShimont(List<Data> futureData) async {
    _shimont = futureData;
    notifyListeners();
  }
}
