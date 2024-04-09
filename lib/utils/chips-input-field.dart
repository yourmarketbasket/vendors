import 'package:flutter/material.dart';

class ChipInputField extends StatefulWidget {
  final List<String> initialChips;
  final ValueChanged<List<String>> onChipsChanged;
  final String labelText;

  ChipInputField({
    required this.initialChips,
    required this.onChipsChanged,
    this.labelText = 'Add Chip',
  });

  @override
  _ChipInputFieldState createState() => _ChipInputFieldState();
}

class _ChipInputFieldState extends State<ChipInputField> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _chips = [];

  @override
  void initState() {
    super.initState();
    _chips.addAll(widget.initialChips);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _chips.map((chip) {
            return InputChip(
              label: Text(chip),
              onDeleted: () {
                setState(() {
                  _chips.remove(chip);
                  widget.onChipsChanged(_chips);
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(),
          ),
          onSubmitted: _addChip,
        ),
      ],
    );
  }

  void _addChip(String chip) {
    if (chip.isNotEmpty && !_chips.contains(chip)) {
      setState(() {
        _chips.add(chip);
        widget.onChipsChanged(_chips);
        _textEditingController.clear();
      });
    }
  }

  List<String> getFeatures() {
    return List<String>.from(_chips);
  }
}
