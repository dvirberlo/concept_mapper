import 'package:flutter/material.dart';

import '../concept_map/concept_map.dart';

class TreeDrawer {
  ConceptTree tree;
  Size canvasSize;
  late Size distance;
  Canvas canvas;
  TreeDrawer(this.canvas, this.canvasSize, this.tree) {
    int maxDepth = tree.getMaxDepth();
    distance = Size(
      canvasSize.width / maxDepth,
      canvasSize.height / maxDepth,
    );
  }

  void drawMap() {
    eraseAll();
    drawConcept(tree, canvasSize.width / 2, canvasSize.height / 2);
  }

  void drawConcept(ConceptTree conceptTree, double x, double y) {
    box(x, y);
    // TODO: ...
  }

  // drawing modules:
  static Paint eraser = Paint()
    ..color = Colors.white70
    ..style = PaintingStyle.fill;
  static Paint boxes = Paint()
    ..color = Colors.pink
    ..style = PaintingStyle.stroke;

  void eraseAll() {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height),
      eraser,
    );
  }

  void box(double x, double y) {
    canvas.drawRect(
      Rect.fromLTWH(x, y, 20, 20),
      boxes,
    );
  }
}
