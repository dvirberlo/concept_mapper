import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../concept_map/concept_map.dart';

class TreePreviewView extends StatelessWidget {
  const TreePreviewView({Key? key}) : super(key: key);

  static const routeName = '/tree_preview';
  // A4~like size
  final double width = 1024, height = 724;

  @override
  Widget build(BuildContext context) {
    ConceptTree tree = context.watch<ConceptMap>().tree;
    int maxDepth = tree.getMaxDepth();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: width,
              height: height,
              color: Colors.white,
              child: Text(AppLocalizations.of(context)!.appTitle),
            );
          },
        ),
      ),
    );
  }
}
