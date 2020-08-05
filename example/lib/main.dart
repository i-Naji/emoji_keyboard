import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_keyboard/flutter_emoji_keyboard.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Emoji Keyboard'),
        ),
        body: MainPage(),
      ),
    ),
  );
}

class MainPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  void onEmojiSelected(Emoji emoji) {
    controller.text += emoji.text;
  }

  void clearText() => controller.text = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextField(
            enableInteractiveSelection: false,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            maxLines: 4,
            controller: controller,
            style: TextStyle(
              fontSize: 28,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20.0),
            ),
          ),
          FloatingActionButton(
            child: const Icon(Icons.clear),
            onPressed: clearText,
          ),
          EmojiKeyboard(
            onEmojiSelected: onEmojiSelected,
          ),
        ],
      ),
    );
  }
}
