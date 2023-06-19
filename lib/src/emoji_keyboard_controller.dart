import 'package:flutter_emoji_keyboard/flutter_emoji_keyboard.dart';

import 'compatible_emojis.dart';

class EmojiKeyboardController {
  late Future<List<List<Emoji>>> future;

  EmojiKeyboardController() {
    future = getEmojis();
  }
}
