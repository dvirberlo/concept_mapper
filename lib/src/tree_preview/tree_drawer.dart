import 'package:flutter/material.dart';

import '../objects/concept_map.dart';

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
      null,
    );
  }

  void drawConcept(
      ConceptTree conceptTree, Offset point, Size size, Rect? parent) {
    // TODO: padding, smart distribution, get smaller while tree is opening (per level)
    double currentHeight = size.height / conceptTree.getMaxDepth();
    Rect frame = box(point, conceptTree.concept);
    if (parent != null) line(frame, parent);

    Size childSize = Size(
      size.width / conceptTree.children.length,
      size.height - currentHeight,
    );
    double lastPx = point.dx - size.width / 2 - childSize.width / 2;
    for (int i = 0; i < conceptTree.children.length; i++) {
      lastPx += childSize.width;
      Offset childPoint = Offset(
        lastPx,
        point.dy + currentHeight,
      );
      drawConcept(conceptTree.children[i], childPoint, childSize, frame);
    }
  }

  // drawing modules:
  static Paint eraser = Paint()
    ..color = Colors.white70
    ..style = PaintingStyle.fill;
  static Paint boxes = Paint()
    ..color = Colors.pink
    ..style = PaintingStyle.stroke;
  static Paint lines = Paint()
    ..color = Colors.brown
    ..style = PaintingStyle.stroke;

  void eraseAll() {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height),
      eraser,
    );
  }

  Rect box(Offset point, Concept concept) {
    TextPainter conceptText = TextPainter(
      text: TextSpan(
        text: concept.name,
        style: TextStyle(color: concept.color),
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: 100);
    conceptText.paint(
      canvas,
      Offset(
        point.dx - conceptText.width / 2,
        point.dy - conceptText.height / 2,
      ),
    );
    Rect frame = Rect.fromCenter(
      center: point,
      width: conceptText.width + 10,
      height: conceptText.height + 10,
    );
    canvas.drawRect(
      frame,
      boxes..color = concept.color,
    );
    return frame;
  }

  void line(Rect box, Rect parent) {
    Offset dParentP = parent.center.dx == box.center.dx
        ? parent.bottomCenter
        : (box.center.dx > parent.center.dx
            ? parent.centerRight
            : parent.centerLeft);
    Offset dChildP = box.topCenter;
    Offset middleP = Offset(dChildP.dx, dParentP.dy);

    // vertical line TODO: fix this:
    if (!((middleP.dx < parent.center.dx &&
            middleP.dx > parent.centerLeft.dx) ||
        (middleP.dx > parent.center.dx &&
            middleP.dx < parent.centerRight.dx))) {
      canvas.drawLine(dParentP, middleP, lines);
    }
    // horizontal line
    canvas.drawLine(middleP, dChildP, lines);
  }
}
