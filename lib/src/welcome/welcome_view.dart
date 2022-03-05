import 'package:concept_mapper/src/objects/maps_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../tree_editor/tree_editor_view.dart';
import '../objects/concept_map.dart';
import './map_card_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.appTitle),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.welcomeMsg,
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                ),
                onPressed: () {
                  // TODO: edit map dialog
                  context.read<MapsDB>().newMap('mapName2');
                  // Navigator.restorablePushNamed(context, TreeEditorView.routeName);
                },
                // TODO: lang
                child: Text('Create New Map'),
              ),
              const Divider(height: 16),
              Expanded(
                child: GridView.count(
                  // childAspectRatio: 1.5,
                  crossAxisCount:
                      MediaQuery.of(context).size.width ~/ MapCardView.minWidth,
                  children: Provider.of<MapsDB>(context, listen: true)
                      .mapsList
                      .map((e) => MapCardView(e))
                      .toList(),
                ),
              ),
            ],
          ),
        ));
  }
}
