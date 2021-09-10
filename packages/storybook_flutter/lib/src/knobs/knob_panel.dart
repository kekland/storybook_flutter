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
  Widget build(BuildContext context) {
    if (group.knobs.length == 1) {
      return group.knobs.values.single.build();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            group.label,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        ...group.knobs.values.map((v) => v.build(customLabel: v.groupedLabel)),
        const Divider(height: 8),
      ],
    );
  }
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
                      const SizedBox(height: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) => KnobGroupWidget(
                    group: items[index],
                  ),
                );
        },
      );
}
