import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Storybook(
        storyWrapperBuilder: (context, story, builder) => Stack(
          children: [
            Container(
              padding: story?.padding,
              color: Theme.of(context).canvasColor,
              child: Center(child: builder(context)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  story?.name ?? '',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
        ),
        children: [
          Story(
            section: 'Buttons',
            name: 'Flat button',
            builder: (_, k) => MaterialButton(
              onPressed:
                  k.boolean(label: 'Enabled', initial: true) ? () {} : null,
              child: Text(k.text(label: 'Text', initial: 'Flat button')),
            ),
          ),
          Story(
            section: 'Buttons',
            name: 'Raised button',
            // ignore: deprecated_member_use
            builder: (_, k) => RaisedButton(
              onPressed:
                  k.boolean(label: 'Enabled', initial: true) ? () {} : null,
              color: k.options(
                label: 'Color',
                initial: Colors.deepOrange,
                options: const [
                  Option('Red', Colors.deepOrange),
                  Option('Green', Colors.teal),
                ],
              ),
              mouseCursor: k.options(
                label: 'Mouse Cursor',
                initial: null,
                options: const [
                  Option('Basic', SystemMouseCursors.basic),
                  Option('Click', SystemMouseCursors.click),
                  Option('Forbidden', SystemMouseCursors.forbidden),
                ],
              ),
              elevation: k.slider(label: 'Elevation', initial: 0, max: 20),
              textColor: Colors.white,
              child: Text(k.text(label: 'Text', initial: 'Raised button')),
            ),
          ),
          Story(
            name: 'Counter',
            builder: (_, k) => Text('${k.sliderInt(label: 'Value')}'),
          ),
          Story.simple(
            name: 'Input field',
            child: const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Input field',
              ),
            ),
          ),
          Story(
            name: 'Grouping test',
            builder: (_, k) => Container(
              width: k.number(label: 'size.width', initial: 100),
              height: k.number(label: 'size.height', initial: 64),
              alignment: k.options(
                label: 'alignment',
                initial: Alignment.center,
                options: [
                  const Option('topLeft', Alignment.topLeft),
                  const Option('center', Alignment.center),
                  const Option('bottomRight', Alignment.bottomRight),
                ],
              ),
              color: k.groupedOptions<Color? Function(BuildContext)>(
                label: 'color',
                initial: (BuildContext context) => Colors.blue,
                options: {
                  'null': [Option('null', (_) => null)],
                  'reds': [
                    Option('red', (_) => Colors.red),
                    Option('yellow', (_) => Colors.yellow),
                    Option('orange', (_) => Colors.orange),
                  ],
                  'blues': [
                    Option('blue', (_) => Colors.blue),
                    Option('purple', (_) => Colors.purple),
                    Option('indigo', (_) => Colors.indigo),
                  ],
                  'greens': [
                    Option('green', (_) => Colors.green),
                    Option('lime', (_) => Colors.lime),
                    Option('cyan', (_) => Colors.cyan),
                  ],
                  'other': [
                    Option('brown', (_) => Colors.brown),
                    Option('grey', (_) => Colors.grey),
                    Option('blueGrey', (_) => Colors.blueGrey),
                  ],
                },
              )(_),
              child: Text('${k.sliderInt(label: 'Value')}'),
            ),
          ),
        ],
      );
}
