import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/knobs/knobs.dart';
import 'package:storybook_flutter/src/story_provider.dart';

class BoolKnob extends Knob<bool> {
  // ignore: avoid_positional_boolean_parameters
  BoolKnob(String label, bool value) : super(label, value);

  @override
  Widget build({String? customLabel}) => BooleanKnobWidget(
        label: label,
        customLabel: customLabel,
        value: value,
      );
}

class BooleanKnobWidget extends StatelessWidget {
  const BooleanKnobWidget({
    Key? key,
    required this.label,
    required this.value,
    this.customLabel,
  }) : super(key: key);

  final String label;
  final String? customLabel;
  final bool value;

  @override
  Widget build(BuildContext context) => CheckboxListTile(
        title: Text(customLabel ?? label),
        value: value,
        onChanged: (v) => context.read<StoryProvider>().update(label, v),
      );
}
