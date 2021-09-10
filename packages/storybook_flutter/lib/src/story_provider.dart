import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:storybook_flutter/src/knobs/bool_knob.dart';
import 'package:storybook_flutter/src/knobs/knobs.dart';
import 'package:storybook_flutter/src/knobs/number_knob.dart';
import 'package:storybook_flutter/src/knobs/select_knob.dart';
import 'package:storybook_flutter/src/knobs/slider_knob.dart';
import 'package:storybook_flutter/src/knobs/string_knob.dart';
import 'package:storybook_flutter/src/story.dart';

class KnobGroup {
  KnobGroup({
    required this.label,
    required this.knobs,
  });

  final String label;
  final Map<String, Knob> knobs;
}

class _KnobLabel {
  _KnobLabel({
    required this.groupLabel,
    required this.label,
  });

  factory _KnobLabel.fromLabel(String label) {
    final _parts = label.split('.');

    return _KnobLabel(
      groupLabel: _parts.first,
      label: _parts.sublist(1).join('.'),
    );
  }

  final String groupLabel;
  final String label;
}

class StoryProvider extends ChangeNotifier implements KnobsBuilder {
  StoryProvider({
    Story? currentStory,
    bool isFullPage = false,
  })  : _currentStory = currentStory,
        _isFullPage = isFullPage;

  factory StoryProvider.fromPath(String? path, List<Story> stories) {
    final storyPath =
        path?.replaceFirst('/stories/', '').replaceFirst('/full', '') ?? '';
    final story =
        stories.firstWhereOrNull((element) => element.path == storyPath);
    final isFullPage = path?.endsWith('/full') == true;
    return StoryProvider(currentStory: story, isFullPage: isFullPage);
  }

  Story? _currentStory;
  bool _isFullPage = false;

  Story? get currentStory => _currentStory;

  bool get isFullPage => _isFullPage;

  void updateStory(Story? story) {
    _currentStory = story;
    _knobs.clear();
    notifyListeners();
  }

  final Map<String, KnobGroup> _knobs = <String, KnobGroup>{};

  @override
  bool boolean({required String label, bool initial = false}) =>
      _addKnob(BoolKnob(label, initial));

  @override
  double number({
    required String label,
    double initial = 0.0,
    bool Function(double)? validator,
  }) =>
      _addKnob(NumberKnob(label, initial, validator: validator));

  @override
  String text({required String label, String initial = ''}) =>
      _addKnob(StringKnob(label, initial));

  @override
  T options<T>({
    required String label,
    required T initial,
    List<Option<T>> options = const [],
  }) =>
      _addKnob(SelectKnob(label, initial, options));

  T _addKnob<T>(Knob<T> value) {
    final _label = _KnobLabel.fromLabel(value.label);

    final group = _knobs.putIfAbsent(
      _label.groupLabel,
      () => KnobGroup(
        label: _label.groupLabel,
        knobs: {},
      ),
    );

    return (group.knobs.putIfAbsent(_label.label, () => value) as Knob<T>)
        .value;
  }

  void update<T>(String label, T value) {
    final _label = _KnobLabel.fromLabel(label);

    _knobs[_label.groupLabel]!.knobs[_label.label]!.value = value;
    notifyListeners();
  }

  T get<T>(String label) {
    final _label = _KnobLabel.fromLabel(label);
    return _knobs[_label.groupLabel]!.knobs[_label.label]!.value as T;
  }

  List<KnobGroup> all() => _knobs.values.toList();

  @override
  double slider({
    required String label,
    double initial = 0,
    double max = 1,
    double min = 0,
  }) =>
      _addKnob(SliderKnob(label, value: initial, max: max, min: min));

  @override
  int sliderInt({
    required String label,
    int initial = 0,
    int max = 100,
    int min = 0,
    int divisions = 100,
  }) =>
      _addKnob(SliderKnob(
        label,
        value: initial.toDouble(),
        max: max.toDouble(),
        min: min.toDouble(),
        divisions: divisions,
        formatValue: (v) => v.toInt().toString(),
      )).toInt();
}
