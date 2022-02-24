import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../concept_map/concept_map.dart';

class ConceptDialog extends StatelessWidget {
  final Concept concept;
  const ConceptDialog(this.concept, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Concept newConcept = concept;
    final nameController = TextEditingController(text: newConcept.name);
    final _formKey = GlobalKey<FormState>();
    void submit() {
      if (!_formKey.currentState!.validate()) return;
      newConcept.name = nameController.text;
      Navigator.of(context).pop(newConcept);
    }

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.editConcept),
      content: Form(
        key: _formKey,
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(newConcept),
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
