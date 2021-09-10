import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/knobs/knobs.dart';
import 'package:storybook_flutter/src/story_provider.dart';

class SelectKnob<T> extends Knob<T> {
  SelectKnob(String label, T value, this.options) : super(label, value);

  final List<Option<T>> options;

  @override
  Widget build({String? customLabel}) => SelectKnobWidget<T>(
        label: label,
        customLabel: customLabel,
        value: value,
        values: options,
      );
}

/// Option for select knob.
class Option<T> {
  const Option(this.text, this.value);

  final String text;
  final T value;
}

class SelectKnobWidget<T> extends StatelessWidget {
  const SelectKnobWidget({
    Key? key,
    required this.label,
    this.customLabel,
    required this.values,
    required this.value,
  }) : super(key: key);

  final String label;
  final String? customLabel;
  final List<Option<T>> values;
  final T value;

  Widget _buildOption(BuildContext context, Option<T> option) {
    final label = Text(option.text);
    Color? _color;

    if (option.value is Color) {
      _color = option.value as Color;
    } else if (option.value is Color Function(BuildContext) ||
        option.value is Color? Function(BuildContext)) {
      _color = (option.value as Color? Function(BuildContext))(context);
    }

    if (_color != null) {
      return Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: _color,
          ),
          const SizedBox(width: 12),
          label,
        ],
      );
    }

    return label;
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: DropdownButtonFormField<Option<T>>(
          decoration: InputDecoration(
            isDense: true,
            labelText: customLabel ?? label,
            border: const OutlineInputBorder(),
          ),
          isExpanded: true,
          value: values.firstWhereOrNull((e) => e.value == value),
          items: values
              .map((e) => DropdownMenuItem<Option<T>>(
                    value: e,
                    child: _buildOption(context, e),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) {
              context.read<StoryProvider>().update<T>(label, v.value);
            }
          },
        ),
      );
}
