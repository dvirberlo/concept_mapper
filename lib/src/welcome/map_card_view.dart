import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tree_editor/tree_editor_view.dart';
import '../objects/maps_db.dart';

class MapCardView extends StatelessWidget {
  static const int minWidth = 176;
  final String mapName;
  const MapCardView(this.mapName, {Key? key}) : super(key: key);

  void edit(BuildContext context) {
    context.read<MapsDB>().setMap(mapName);
    Navigator.restorablePushNamed(context, TreeEditorView.routeName);
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
                icon: const Icon(Icons.edit),
                onPressed: () => edit(context),
              ),
            ],
          )
        ],
      ),
    );
  }
}