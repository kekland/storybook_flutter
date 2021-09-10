import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/knobs/knobs.dart';
import 'package:storybook_flutter/src/story_provider.dart';

typedef FormatDouble = String Function(double value);

class SliderKnob extends Knob<double> {
  SliderKnob(
    String label, {
    required double value,
    required this.max,
    required this.min,
    this.divisions,
    this.formatValue = _defaultFormat,
  }) : super(label, value);
  final double max;
  final double min;
  final int? divisions;
  final FormatDouble formatValue;

  @override
  Widget build({String? customLabel}) => SliderKnobWidget(
        label: label,
        customLabel: customLabel,
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        formatValue: formatValue,
      );
}

class SliderKnobWidget extends StatelessWidget {
  const SliderKnobWidget({
    Key? key,
    required this.label,
    this.customLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.formatValue,
  }) : super(key: key);

  final String label;
  final String? customLabel;
  final double min;
  final double max;
  final double value;
  final int? divisions;
  final FormatDouble formatValue;

  @override
  Widget build(BuildContext context) => ListTile(
        subtitle: Slider(
          value: value,
          onChanged: (v) => context.read<StoryProvider>().update(label, v),
          max: max,
          min: min,
          divisions: divisions,
        ),
        title: Text('${customLabel ?? label} (${formatValue(value)})'),
      );
}

String _defaultFormat(double value) => value.toStringAsFixed(2);
