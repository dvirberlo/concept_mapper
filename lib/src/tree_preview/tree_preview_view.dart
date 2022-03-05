import 'dart:typed_data';
import 'dart:ui';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../objects/concept_map.dart';
import '../objects/maps_db.dart';
import './tree_drawer.dart';

class TreePreviewView extends StatefulWidget {
  const TreePreviewView({Key? key}) : super(key: key);

  static const routeName = '/tree_preview';

  @override
  State<TreePreviewView> createState() => _TreePreviewViewState();
}

class _TreePreviewViewState extends State<TreePreviewView> {
  // A4~like size
  static const Size canvasSize = Size(1024, 724);
  late ConceptTree tree;

  ByteData? imgBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => generateImage());
  }

  @override
  Widget build(BuildContext context) {
    tree = context.read<MapsDB>().currentMap.tree;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.viewTree),
        actions: [
          IconButton(
            onPressed: () {
              if (imgBytes != null) {
                final content = base64.encode(imgBytes!.buffer.asUint8List());
                AnchorElement(href: "data:image/png;base64,$content")
                  ..setAttribute("download", "file.png")
                  ..click();
              }
            },
            icon: const Icon(Icons.download),
            // TODO: lang
            tooltip: "Download",
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.edit_note),
            tooltip: AppLocalizations.of(context)!.editTree,
          ),
        ],
      ),
      body: Center(
        child: imgBytes == null
            ? Text(AppLocalizations.of(context)!.loadingMsg)
            : FittedBox(
                child: Image.memory(
                  Uint8List.view(imgBytes!.buffer),
                  width: canvasSize.width,
                  height: canvasSize.height,
                ),
                fit: BoxFit.contain,
              ),
      ),
    );
  }

  void generateImage() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(
        recorder,
        Rect.fromPoints(
          const Offset(0, 0),
          Offset(canvasSize.width, canvasSize.height),
        ));

    TreeDrawer(canvas, canvasSize, tree).drawMap();

    final picture = recorder.endRecording();
    final img = await picture.toImage(
      canvasSize.width.toInt(),
      canvasSize.height.toInt(),
    );
    final pngBytes = await img.toByteData(format: ImageByteFormat.png);

    setState(() {
      imgBytes = pngBytes;
    });
  }
}
