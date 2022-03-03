import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './concept_dialog.dart';
import '../concept_map/concept_map.dart';

class TreeView extends StatefulWidget {
  final ConceptTree conceptTree;
  final State? parent;

  const TreeView(this.conceptTree, this.parent, {Key? key}) : super(key: key);

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  bool showChildren = false;

  void add() {
    getConcept(
      true,
      (Concept concept) => {
        setState(() {
          widget.conceptTree.addChild(context, concept);
          showChildren = true;
        })
      },
    );
  }

  void edit() {
    getConcept(
      false,
      (Concept concept) => {
        setState(() {
          widget.conceptTree.editConcept(context, concept);
        })
      },
    );
  }

  void delete() {
    if (widget.parent != null) {
      widget.parent!.setState(() {
        widget.conceptTree.delete(context);
      });
    }
  }

  void getConcept(bool add, Function callback) {
    Concept concept = add ? Concept.def() : widget.conceptTree.concept;
    showDialog(
      context: context,
      builder: (context) => ConceptDialog(concept),
    ).then((value) {
      if (value != null && value is Concept) callback(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: showChildren
              ? const Icon(Icons.arrow_downward)
              : const Icon(Icons.arrow_forward),
          iconColor: widget.conceptTree.concept.color,
          title: Row(
            children: [
              Expanded(child: Text(widget.conceptTree.concept.name)),
              if (widget.parent != null)
                IconButton(
                  onPressed: delete,
                  icon: const Icon(Icons.delete),
                  tooltip: AppLocalizations.of(context)!.delete,
                ),
              IconButton(
                onPressed: edit,
                icon: const Icon(Icons.edit),
                tooltip: AppLocalizations.of(context)!.edit,
              ),
              IconButton(
                onPressed: add,
                icon: const Icon(Icons.add),
                tooltip: AppLocalizations.of(context)!.add,
              ),
            ],
          ),
          onTap: () {
            setState(() => showChildren = !showChildren);
          },
        ),

        // nested children:
        if (showChildren && widget.conceptTree.children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children: widget.conceptTree.children
                  .map((ConceptTree ct) => TreeView(ct, this))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
