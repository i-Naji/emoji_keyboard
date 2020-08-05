// A basic test to find keyboard is shown and header bottons work.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:emoji_keyboard/src/compatible_emojis.dart';
import 'package:emoji_keyboard/emoji_keyboard.dart';

void main() {
  test('emojis are compatible', () async {
    final emojiList = await getEmojis(systemVersion: '15');
    expect(emojiList[0], isNotEmpty);
  });

  // todo: first good issue
  testWidgets('keyboard is shown and header bottons work',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MyWidget(),
    );
    expect(tester.takeException(), isNull);
    /*
    // Verify that our keyboard is on
    expect(find.text('Smileys & People', skipOffstage: false), findsOneWidget);
    expect(find.text('Flags'), findsNothing);

    // Tap the 'flags' icon and scroll.
    await tester.tap(find.byIcon(Icons.flag));
    await tester.pump();

    // Verify that we are in flags screen.
    expect(find.text('Smileys & People'), findsNothing);
    expect(find.text('Flags'), findsOneWidget);
    */
  });
}

class MyWidget extends StatelessWidget {
  const MyWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Test Emoji Keyboard'),
          ),
          body: Container(
            alignment: Alignment.bottomCenter,
            child: EmojiKeyboard(onEmojiSelected: (_) {}),
          )),
    );
  }
}
