import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/knobs/knobs.dart';
import 'package:storybook_flutter/src/story_provider.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class GropuedSelectKnob<T> extends Knob<T> {
  GropuedSelectKnob(String label, T value, this.options) : super(label, value);

  final Map<String, List<Option<T>>> options;

  @override
  Widget build({String? customLabel}) => GroupedSelectKnobWidget<T>(
        label: label,
        customLabel: customLabel,
        value: value,
        values: options,
      );
}

class GroupedSelectKnobWidget<T> extends StatefulWidget {
  const GroupedSelectKnobWidget({
    Key? key,
    required this.label,
    this.customLabel,
    required this.values,
    required this.value,
  }) : super(key: key);

  final String label;
  final String? customLabel;
  final Map<String, List<Option<T>>> values;
  final T value;

  @override
  _GroupedSelectKnobWidgetState<T> createState() =>
      _GroupedSelectKnobWidgetState<T>();
}

class _GroupedSelectKnobWidgetState<T>
    extends State<GroupedSelectKnobWidget<T>> {
  OverlayEntry? _entry;

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

  Widget _buildListItem(
    Option<T> option,
    VoidCallback onTap, {
    bool padded = false,
  }) =>
      ListTile(
        title: _buildOption(context, option),
        dense: true,
        selected: option.value == widget.value,
        onTap: onTap,
        contentPadding: padded
            ? const EdgeInsets.only(left: 32, right: 16)
            : const EdgeInsets.symmetric(horizontal: 16),
      );

  Widget _buildExpansionTile(String group, void Function(T) onTap) {
    final options = widget.values[group]!;

    if (options.length == 1) {
      return _buildListItem(options.single, () => onTap(options.single.value));
    }

    return ListTileTheme(
      dense: true,
      child: ExpansionTile(
        title: _buildOption(context, options.first),
        initiallyExpanded: options.any((v) => v.value == widget.value),
        children: [
          ...options.map(
            (option) => _buildListItem(
              option,
              () => onTap(option.value),
              padded: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showOverlay(BuildContext parentContext) {
    if (_entry != null) return;

    final screenSize = MediaQuery.of(parentContext).size;
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _entry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _entry!.remove();
          _entry = null;
        },
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned(
              top: position.dy + 56,
              left: position.dx + 16,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: renderBox.size.width - 32,
                  maxWidth: renderBox.size.width - 32,
                  maxHeight: screenSize.height - position.dy - 72,
                ),
                child: Material(
                  elevation: 8,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ...widget.values.keys.map((v) => _buildExpansionTile(
                            v,
                            (value) {
                              parentContext.read<StoryProvider>().update<T>(
                                    widget.label,
                                    value,
                                  );
                            },
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context)?.insert(_entry!);
  }

  Option<T>? get _currentOption => widget.value != null
      ? widget.values.values
          .expand((v) => v)
          .firstWhereOrNull((v) => v.value == widget.value)
      : null;

  @override
  void didUpdateWidget(covariant GroupedSelectKnobWidget<T> oldWidget) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _entry?.markNeedsBuild();
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        clipBehavior: Clip.none,
        child: InputDecorator(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: widget.customLabel ?? widget.label,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: _currentOption != null
                ? _buildOption(context, _currentOption!)
                : const Opacity(
                    opacity: 0.5,
                    child: Text('Select'),
                  ),
            onTap: () => _showOverlay(context),
            trailing: const Icon(Icons.arrow_drop_down),
          ),
        ),
      );
}
