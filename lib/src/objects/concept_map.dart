import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './maps_db.dart';

class ConceptMap with ChangeNotifier {
  static const String defJSON =
      '{"concept":{"name":"Root", "color":"ff000000"},"children":[]}';
  late String prefKey;

  late SharedPreferences prefs;
  late ConceptTree _tree;
  ConceptTree get tree => _tree;

  ConceptMap(this.prefs, this.prefKey) {
    _tree =
        ConceptTree.fromJson(jsonDecode(prefs.getString(prefKey) ?? defJSON));
    save();
  }
  ConceptMap.def(this.prefs) : prefKey = '' {
    _tree =
        ConceptTree.fromJson(jsonDecode(prefs.getString(prefKey) ?? defJSON));
    save();
  }

  void update(Function func) {
    func(_tree);
    save();
  }

  void save() => prefs.setString(prefKey, jsonEncode(_tree.toJson()));
}

class ConceptTree {
  late Concept concept;
  ConceptTree? parent;
  List<ConceptTree> children = [];
  ConceptTree(this.concept, this.parent);
  ConceptTree.def()
      : concept = Concept.def(),
        parent = null;

  int getMaxDepth() {
    int depth = 0, temp = 0;
    for (final child in children) {
      temp = child.getMaxDepth();
      if (temp > depth) depth = temp;
    }
    return depth + 1;
  }

  void addChild(BuildContext context, Concept concept) {
    children.add(ConceptTree(concept, this));
    context.read<MapsDB>().currentMap.save();
  }

  void editConcept(BuildContext context, Concept concept) {
    this.concept = concept;
    context.read<MapsDB>().currentMap.save();
  }

  void delete(BuildContext context) {
    if (parent == null) return;
    parent!.children.removeWhere((element) =>
        element.concept.name == concept.name &&
        element.children.length == children.length);
    context.read<MapsDB>().currentMap.save();
  }

  Map<String, dynamic> toJson() => {
        'concept': concept.toJson(),
        'children': children.map((e) => e.toJson()).toList(),
      };

  static ConceptTree fromJson(Map<String, dynamic> map, {ConceptTree? parent}) {
    ConceptTree tree = ConceptTree(Concept.fromJson(map['concept']), parent);
    map['children'].forEach(
        (json) => tree.children.add(ConceptTree.fromJson(json, parent: tree)));
    return tree;
  }
}

class Concept {
  late Color color;
  late String name;

  Concept(this.name, this.color);
  Concept.def()
      : name = '',
        color = Colors.blue;

  Map<String, dynamic> toJson() => {
        'name': name,
        'color': color.value.toRadixString(16),
      };
  static Concept fromJson(Map<String, dynamic> map) => Concept(
        map['name'],
        Color(int.parse("0x${map['color']}")),
      );
}
