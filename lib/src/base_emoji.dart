/// Base emoji class
class Emoji {
  final String name;
  final String text;
  final EmojiCategory category;
  final List<Emoji> diversityChildren;
  final List<MapEntry<String, String>> limitRangeAndroid;
  final List<MapEntry<String, String>> limitRangeIOS;

  /// Creates a emoji class
  ///
  /// Emoji [name]
  ///
  /// [text] is emoji charecters in [String]
  ///
  /// Emoji [category]
  ///
  /// Emoji may be not campatible in some android and ios devices which are
  ///  listed by it's OS version in [limitRangeAndroid] and [limitRangeIOS]
  ///
  /// Emoji may have some [diversityChildren] same emojis with diffrent skin color.
  const Emoji(this.name, this.text, this.category,
      {this.limitRangeAndroid,
      this.limitRangeIOS,
      this.diversityChildren = const []});

  bool get hasChildren => diversityChildren.isNotEmpty;

  /// Check if [emoji] is compatible by The android [systemVersion]
  static bool isAndroidCompatible(Emoji emoji, String systemVersion) {
    if (emoji.limitRangeAndroid == null) return false;
    return _versionCompatibility(emoji.limitRangeAndroid, systemVersion);
  }

  /// Check if [emoji] is compatible by The IOS [systemVersion]
  static bool isIOSCompatible(Emoji emoji, String systemVersion) {
    if (emoji.limitRangeIOS == null) return false;
    return _versionCompatibility(emoji.limitRangeIOS, systemVersion);
  }

  /// return Emoji text
  @override
  String toString() => text;
}

bool _versionCompatibility(
    List<MapEntry<String, String>> limitRange, String ver) {
  if (ver.split('.')[0].length < 2) {
    ver = '0' + ver;
  }

  final ends = limitRange[0];

  if (ver.compareTo(ends.key) < 0 || ver.compareTo(ends.value) > 0) {
    return false;
  }

  for (final range in limitRange.sublist(1)) {
    if (ver.compareTo(range.key) > -1 && ver.compareTo(range.value) < -1) {
      return false;
    }
  }

  return true;
}

/// All [Emoji] categories
enum EmojiCategory {
  people,
  nature,
  food,
  activity,
  travel,
  objects,
  symbols,
  flags
}
