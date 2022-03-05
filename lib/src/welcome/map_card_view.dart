import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tree_editor/tree_editor_view.dart';
import '../tree_preview/tree_preview_view.dart';
import '../objects/maps_db.dart';

class MapCardView extends StatelessWidget {
  static const int minWidth = 176;
  final String mapName;
  const MapCardView(this.mapName, {Key? key}) : super(key: key);

  void edit(BuildContext context) {
    context.read<MapsDB>().setMap(mapName);
    Navigator.restorablePushNamed(context, TreeEditorView.routeName);
  }

  void preview(BuildContext context) {
    context.read<MapsDB>().setMap(mapName);
    Navigator.restorablePushNamed(context, TreePreviewView.routeName);
  }

  void delete(BuildContext context) {
    context.read<MapsDB>().deleteMap(mapName);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(child: Center(child: Text(mapName))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.preview),
                onPressed: () => preview(context),
              ),
              IconButton(
                icon: const Icon(Icons.edit_note),
                onPressed: () => edit(context),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => delete(context),
              ),
            ],
          )
        ],
      ),
    );
  }
}
