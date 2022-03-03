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
    drawConcept(
      tree,
      Offset(
        canvasSize.width / 2,
        (canvasSize.height / tree.getMaxDepth()) * 0.5,
      ),
      canvasSize,
    );
  }

  void drawConcept(ConceptTree conceptTree, Offset point, Size size) {
    print([point, size]);
    // TODO: padding, smart distribution, get smaller while tree is opening (per level)
    double currentHeight = size.height / conceptTree.getMaxDepth();
    box(point, conceptTree.concept);
    Size childSize = Size(
      size.width / conceptTree.children.length,
      size.height - currentHeight,
    );
    double last_px = point.dx - size.width / 2 - childSize.width / 2;
    for (int i = 0; i < conceptTree.children.length; i++) {
      last_px += childSize.width;
      Offset childPoint = Offset(
        last_px,
        point.dy + currentHeight,
      );
      drawConcept(
        conceptTree.children[i],
        childPoint,
        childSize,
      );
    }
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

  void box(Offset point, Concept concept) {
    TextPainter conceptText = TextPainter(
      text: TextSpan(text: concept.name),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: 100);
    conceptText.paint(
      canvas,
      Offset(
        point.dx - conceptText.width / 2,
        point.dy - conceptText.height / 2,
      ),
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: point,
        width: conceptText.width + 10,
        height: conceptText.height + 10,
      ),
      boxes,
    );
  }
}
