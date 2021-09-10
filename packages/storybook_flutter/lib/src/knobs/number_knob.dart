import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/knobs/knobs.dart';
import 'package:storybook_flutter/src/story_provider.dart';

class NumberKnob extends Knob<double> {
  NumberKnob(
    String label,
    double value, {
    this.validator,
  }) : super(label, value);

  final bool Function(double)? validator;

  @override
  Widget build({String? customLabel}) => NumberKnobWidget(
        label: label,
        customLabel: customLabel,
        value: value,
        validator: validator,
      );
}

class NumberKnobWidget extends StatelessWidget {
  const NumberKnobWidget({
    Key? key,
    required this.label,
    this.customLabel,
    required this.value,
    this.validator,
  }) : super(key: key);

  final String label;
  final String? customLabel;
  final double value;
  final bool Function(double)? validator;

  @override
  Widget build(BuildContext context) => ListTile(
        title: TextFormField(
            decoration: InputDecoration(
              isDense: true,
              labelText: customLabel ?? label,
              border: const OutlineInputBorder(),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
            initialValue: value.toString(),
            onChanged: (v) {
              final value = double.tryParse(v);

              if (value != null && (validator == null || validator!(value))) {
                context.read<StoryProvider>().update(label, value);
              }
            }),
      );
}
