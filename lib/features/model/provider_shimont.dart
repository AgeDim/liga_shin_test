import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/model/shimont.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DataProvider with ChangeNotifier {
  List<Data> _shimont = [];
  List<Data> _carWashing = [];

  static const String firstListKey = 'shimont';
  static const String secondListKey = 'carWashing';
  static const String lastUpdateKey = 'lastUpdate';

  DataProvider() {
    _initData();
  }

  List<Data> get shimont => _shimont;

  List<Data> get carWashing => _carWashing;

  void _initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? firstListString = prefs.getStringList(firstListKey);
    List<String>? secondListString = prefs.getStringList(secondListKey);

    if (firstListString != null && secondListString != null) {
      _shimont = firstListString
          .map((jsonString) => Data.fromJson(jsonDecode(jsonString)))
          .toList();
      _carWashing = secondListString
          .map((jsonString) => Data.fromJson(jsonDecode(jsonString)))
          .toList();
    }
    notifyListeners();
  }

  void updateLists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Data> shimontList = [];
    List<Data> carWashingList = [];
    try {
      var shimont =
          await http.get(Uri.parse('https://auto.shinliga.ru/shimont.json'));
      if (shimont.statusCode == 200) {
        var jsonData = json.decode(shimont.body);
        for (final data in jsonData) {
          shimontList.add(Data.fromJson(data));
        }
      }
      var carWashing =
          await http.get(Uri.parse('https://auto.shinliga.ru/carwashing.json'));
      if (carWashing.statusCode == 200) {
        var jsonData = json.decode(carWashing.body);
        for (final data in jsonData) {
          carWashingList.add(Data.fromJson(data));
        }
      }
    } catch (e) {
      print("Error updating data: $e");
    }
    _shimont = shimontList;
    _carWashing = carWashingList;

    List<String> firstListString =
        _shimont.map((data) => jsonEncode(data.toJson())).toList();
    List<String> secondListString =
        _carWashing.map((data) => jsonEncode(data.toJson())).toList();
    prefs.setStringList(firstListKey, firstListString);
    prefs.setStringList(secondListKey, secondListString);
    prefs.setString(lastUpdateKey, DateTime.now().toString());

    notifyListeners();
  }
}
