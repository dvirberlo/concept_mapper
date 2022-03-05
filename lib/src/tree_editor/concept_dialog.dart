import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../objects/concept_map.dart';

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
      // TODO: edit/add
      title: Text(AppLocalizations.of(context)!.editConcept),
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
              const SizedBox(height: 16),
              BlockPicker(
                pickerColor: concept.color,
                onColorChanged: (Color c) => newConcept.color = c,
                itemBuilder: colorPitems,
              )
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

  Widget colorPitems(
      Color color, bool isCurrentColor, void Function() changeColor) {
    double _borderRadius = 10;
    double _blurRadius = 0;
    double _iconSize = 24;
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.8),
              offset: const Offset(1, 2),
              blurRadius: _blurRadius)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
