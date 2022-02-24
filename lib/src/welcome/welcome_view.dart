import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../tree_editor/tree_editor_view.dart';

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
              const Divider(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.restorablePushNamed(
                      context, TreeEditorView.routeName);
                },
                child: Text(AppLocalizations.of(context)!.editTree),
              ),
            ],
          ),
        ));
  }
}
