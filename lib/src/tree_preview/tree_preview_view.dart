import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:file_selector/file_selector.dart';
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
  final Size canvasSize = TreeDrawer.canvasSize;
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
            onPressed: () async {
              if (imgBytes == null) return;
              final name = context.read<MapsDB>().currentMap.prefKey + '.png';
              final path = await getSavePath(acceptedTypeGroups: [
                XTypeGroup(extensions: ['.png'])
              ], suggestedName: name);
              if (path == null) return;
              final data = imgBytes!.buffer.asUint8List();
              const mimeType = "image/png";
              final file = XFile.fromData(data, name: name, mimeType: mimeType);
              await file.saveTo(path);
            },
            icon: const Icon(Icons.download),
            tooltip: AppLocalizations.of(context)!.download,
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

    TreeDrawer(canvas, tree).drawMap();

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
