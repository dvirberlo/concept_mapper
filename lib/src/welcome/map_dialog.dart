import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../objects/concept_map.dart';

class MapDialog extends StatelessWidget {
  final ConceptMap conceptMap;
  const MapDialog(this.conceptMap, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConceptMap newMap = conceptMap;
    final nameController = TextEditingController(text: newMap.prefKey);
    final _formKey = GlobalKey<FormState>();
    void submit() {
      if (!_formKey.currentState!.validate()) return;
      newMap.prefKey = nameController.text;
      Navigator.of(context).pop(newMap);
    }

    return AlertDialog(
      // TODO: lang, edit/add
      title: Text("Edit Map"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (val) => submit(),
                controller: nameController,
                validator: (val) => (val == null || val.isEmpty)
                    ? AppLocalizations.of(context)!.validName
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: submit,
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }
}
