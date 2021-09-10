import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storybook_flutter/src/story_provider.dart';

class KnobGroupWidget extends StatelessWidget {
  const KnobGroupWidget({
    Key? key,
    required this.group,
  }) : super(key: key);

  final KnobGroup group;

  @override
  Widget build(BuildContext context) => ExpansionTile(
        title: Text(group.label),
        maintainState: true,
        childrenPadding: const EdgeInsets.only(bottom: 12),
        children: [
          ...group.knobs.values.map(
            (v) => v.build(
                customLabel: v.groupedLabel.isEmpty ? v.label : v.groupedLabel),
          )
        ],
      );
}

class KnobPanel extends StatelessWidget {
  const KnobPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<StoryProvider>(
        builder: (context, knobs, _) {
          final items = knobs.all();

          return items.isEmpty
              ? const Center(child: Text('No knobs'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 0),
                  itemCount: items.length,
                  itemBuilder: (context, index) => KnobGroupWidget(
                    group: items[index],
                  ),
                );
        },
      );
}
