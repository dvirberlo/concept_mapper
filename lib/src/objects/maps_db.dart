import 'package:concept_mapper/src/objects/concept_map.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsDB with ChangeNotifier {
  static const String prefList = 'MapsList';
  late SharedPreferences prefs;
  late List<String> _mapsList;
  List<String> get mapsList => _mapsList;

  MapsDB(this.prefs) {
    _mapsList = prefs.getStringList(prefList) ?? [];
    save();
  }

  void update(Function func) {
    func(_mapsList);
    save();
  }

  void save() => prefs.setStringList(prefList, _mapsList);

  ConceptMap getMap(String mapKey) => ConceptMap(prefs, mapKey);
}
