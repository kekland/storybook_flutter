import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/knobs/knobs.dart';
import 'package:storybook_flutter/src/story_provider.dart';

class StringKnob extends Knob<String> {
  StringKnob(String label, String value) : super(label, value);

  @override
  Widget build({String? customLabel}) =>
      StringKnobWidget(label: label, customLabel: customLabel, value: value);
}

class StringKnobWidget extends StatelessWidget {
  const StringKnobWidget(
      {Key? key, required this.label, this.customLabel, required this.value})
      : super(key: key);

  final String label;
  final String? customLabel;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
        title: TextFormField(
          decoration: InputDecoration(
            isDense: true,
            labelText: customLabel ?? label,
            border: const OutlineInputBorder(),
          ),
          initialValue: value,
          onChanged: (v) => context.read<StoryProvider>().update(label, v),
        ),
      );
}
