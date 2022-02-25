import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../concept_map/concept_map.dart';
import '../tree_preview/tree_preview_view.dart';
import './tree_view.dart';

class TreeEditorView extends StatelessWidget {
  const TreeEditorView({Key? key}) : super(key: key);

  static const routeName = '/tree_editor';

  @override
  Widget build(BuildContext context) {
    ConceptTree tree = context.watch<ConceptMap>().tree;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editTree),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.restorablePushNamed(context, TreePreviewView.routeName);
            },
            icon: const Icon(Icons.preview),
            tooltip: AppLocalizations.of(context)!.viewTree,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: TreeView(tree, null),
      ),
    );
  }
}
