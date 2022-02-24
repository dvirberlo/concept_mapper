import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';

class ConceptMap with ChangeNotifier {
  final String prefKey = 'ConceptMap';

  late SharedPreferences prefs;
  late ConceptTree _tree;
  ConceptTree get tree => _tree;

  ConceptMap(this.prefs) {
    _tree = ConceptTree.fromJson(jsonDecode(prefs.getString(prefKey) ??
        '{"concept":{"name":"Root"},"children":[]}'));
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

  void addChild(BuildContext context, Concept concept) {
    children.add(ConceptTree(concept, this));
    context.read<ConceptMap>().save();
  }

  void editConcept(BuildContext context, Concept concept) {
    this.concept = concept;
    context.read<ConceptMap>().save();
  }

  void delete(BuildContext context) {
    if (parent == null) return;
    parent!.children.removeWhere((element) =>
        element.concept.name == concept.name &&
        element.children.length == children.length);
    context.read<ConceptMap>().save();
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
  // late Color color;
  late String name;

  Concept(this.name);
  Concept.def() : name = '';

  Map<String, dynamic> toJson() => {'name': name};
  static Concept fromJson(Map<String, dynamic> map) => Concept(map['name']);
}
