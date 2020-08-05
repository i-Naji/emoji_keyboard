# emoji_keyboard
A Fast and Light ⚡ Emoji Keyboard ✨ Widget for Flutter<br>
(implements compatible emoji support)

## Usage
First, add the `emoji_keyboard` package to your [pubspec dependencies](https://pub.dev/packages/emoji_keyboard#-installing-tab-).

To import `emoji_keyboard`:
```dart
import 'package:emoji_keyboard/emoji_keyboard.dart';
```
To use `EmojiKeyboard`:
```dart
EmojiKeyboard(
  onEmojiSelected: (Emoji emoji){},
),
```
---
**onEmojiSelected** parameter must not be null,
It's the callback function with Emoji as argument when emoji on keyboard is pressed.

---
Sample Usage [/example](/example) directory.

<img src="https://media.giphy.com/media/lqMKb4tPI6ZfVS7kqu/giphy.gif" alt="">


## Todo
* make a todo list