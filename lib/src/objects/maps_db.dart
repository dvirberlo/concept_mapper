import 'package:concept_mapper/src/objects/concept_map.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsDB with ChangeNotifier {
  static const String prefList = 'MapsList';
  late SharedPreferences prefs;

  late List<String> _mapsList;
  List<String> get mapsList => _mapsList;

  ConceptMap _currentMap;
  ConceptMap get currentMap => _currentMap;

  MapsDB(this.prefs) : _currentMap = ConceptMap.def(prefs) {
    _mapsList = prefs.getStringList(prefList) ?? [];
    save();
  }

  void update(Function func) {
    func(_mapsList);
    save();
    notifyListeners();
  }

  void save() => prefs.setStringList(prefList, _mapsList);

  ConceptMap getMap(String mapName) => ConceptMap(prefs, mapName);

  void setMap(String mapName) => _currentMap = getMap(mapName);

  ConceptMap? newMap(String mapName) {
    if (mapsList.contains(mapName)) return null;
    ConceptMap map = ConceptMap(prefs, mapName);
    update((List<String> l) => l.add(mapName));
    return map;
  }

  void deleteMap(String mapName) {
    if (!mapsList.contains(mapName)) return null;
    update((List<String> l) => l.remove(mapName));
  }

  void renameMap(String mapName, String newName) {
    if (!mapsList.contains(mapName)) return null;
    update((List<String> l) {
      ConceptMap(prefs, mapName).rename(newName);
      l.remove(mapName);
      l.add(newName);
    });
  }
}
