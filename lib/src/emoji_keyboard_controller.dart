import 'compatible_emojis.dart';

class EmojiKeyboardController {
  Future future;

  EmojiKeyboardController() {
    future = getEmojis();
  }
}
