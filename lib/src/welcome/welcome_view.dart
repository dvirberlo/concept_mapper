import 'package:concept_mapper/src/objects/maps_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../tree_editor/tree_editor_view.dart';
import '../objects/concept_map.dart';
import './map_dialog.dart';
import './map_card_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    void getConceptMap(bool add, Function callback) {
      ConceptMap map = ConceptMap.def(context.read<MapsDB>().prefs);
      showDialog(
        context: context,
        // TODO: lang
        builder: (context) => MapDialog(map, add ? "Add Map" : "Edit Map"),
      ).then((value) {
        if (value != null && value is ConceptMap) callback(value);
      });
    }

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
                  getConceptMap(true, (ConceptMap map) {
                    context.read<MapsDB>().newMap(map.prefKey);
                    context.read<MapsDB>().setMap(map.prefKey);
                    Navigator.restorablePushNamed(
                        context, TreeEditorView.routeName);
                  });
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
