import 'package:emoji_keyboard/emoji_keyboard.dart';

import 'compatible_emojis.dart';
import 'base_emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:emoji_keyboard/src/compatible_emojis.dart';

// typedef void _SetCategoryKey(int index, GlobalKey key);
typedef void _CategoryButtonPressed(int index);

/// Callback function when emoji is pressed will be called.
/// by [Emoji] argument.
typedef void OnEmojiSelected(Emoji emoji);

const _categoryHeaderHight = 40.0;
const _categoryTitleHight = _categoryHeaderHight; // todo: fix scroll issue

/// The Emoji Keyaboad Widget
///
/// Contains all emojis in a vertically scrollable grid
class EmojiKeyboard extends StatelessWidget {
  final bool floatingHeader;
  final int column;
  final double hight;
  final OnEmojiSelected onEmojiSelected;
  final CategoryIcons categoryIcons;
  final CategoryTitles categoryTitles;
  final Color color;

  final contentKey = UniqueKey();
  final List<GlobalKey> categoryKeyStore = List(8);

  /// Creates a emoji keyboard widget.
  ///
  /// [column] is number of columns in keyboard grid.
  ///
  /// [height] of keyboard.
  ///
  /// [color] color of keyboard, by default is [Colors.white].
  ///
  /// [onEmojiSelected] The callback function when emoji is pressed,
  /// Must not be null.
  ///
  /// Emojis in keyboard are soreted by categories with header of [categoryTitles]
  ///
  /// Keyboard has a header that contain all [categoryIcons] is a row and take postion by pressing the icon,
  ///
  /// If [floatingHeader] is true then keyboard scrolls offscreen header as the user scrolls down the list.
  EmojiKeyboard({
    Key key,
    this.column = 8,
    this.hight = 290.0,
    @required this.onEmojiSelected,
    this.floatingHeader = false,
    this.color = Colors.white,
    this.categoryIcons = const CategoryIcons(),
    this.categoryTitles = const CategoryTitles(),
  }) : super(key: key);

  /// Calback function when user press one of categorie in keyboard header
  /// and scroll emojis grid to the postion of that category by it's [index].
  void onCategoryClick(int index) {
    Scrollable.ensureVisible(categoryKeyStore[index].currentContext);
  }

  /// set the [key] of emoji category header by it's [index] in grid.
  void setCategoryKey(int index, GlobalKey key) {
    categoryKeyStore[index] = key;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: hight ??
          (MediaQuery.of(context).size.width / column) * 5 +
              (_categoryHeaderHight + _categoryTitleHight),
      child: NestedScrollView(
        key: new PageStorageKey<Type>(NestedScrollView),
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                context,
              ),
              sliver: SliverPersistentHeader(
                delegate: _EmojiKeyboardHeader(
                  minExtent: _categoryHeaderHight,
                  maxExtent: _categoryHeaderHight,
                  categoryIcons: categoryIcons,
                  onClick: onCategoryClick,
                  color: color,
                ),
                pinned: !floatingHeader,
              ),
            ),
          ];
        },
        body: FutureBuilder<List<List<Emoji>>>(
          future: getEmojis(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  // todo : avoid generate
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                  ),
                ]..addAll(
                    List<Widget>.generate(
                      16,
                      (index) {
                        if (index.isEven) {
                          index = (index / 2).round();
                          final key = GlobalKey();
                          setCategoryKey(index, key);
                          return SliverToBoxAdapter(
                            key: key,
                            child: Container(
                              height: _categoryTitleHight,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                categoryTitles[index],
                              ),
                            ),
                          );
                        } else {
                          return SliverGrid(
                            key: ValueKey(index),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                            ),
                            delegate: SliverChildListDelegate.fixed(
                              snapshot.data[index ~/ 2].map((Emoji emoji) {
                                return CupertinoButton(
                                  key: ValueKey('${emoji.text}'),
                                  pressedOpacity: 0.4,
                                  padding: EdgeInsets.all(0),
                                  child: Center(
                                    child: Text(
                                      '${emoji.text}',
                                      style: TextStyle(
                                        fontSize: 26,
                                      ),
                                    ),
                                  ),
                                  onPressed: () => onEmojiSelected(emoji),
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class _EmojiKeyboardHeader implements SliverPersistentHeaderDelegate {
  const _EmojiKeyboardHeader({
    this.minExtent,
    @required this.maxExtent,
    @required this.categoryIcons,
    @required this.onClick,
    this.color: Colors.white,
  });

  final _CategoryButtonPressed onClick;
  final CategoryIcons categoryIcons;
  final double minExtent;
  final double maxExtent;
  final Color color;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: categoryIcons.color,
      height: maxExtent,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            8,
            (index) => CupertinoButton(
              pressedOpacity: 0.4,
              padding: EdgeInsets.all(0),
              borderRadius: BorderRadius.all(Radius.circular(0)),
              child: Center(
                child: Icon(
                  categoryIcons[index],
                  size:
                      (minExtent < maxExtent - 10) ? minExtent : maxExtent - 10,
                ),
              ),
              onPressed: () => onClick(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
}

/// CategoryTitles class that used to define all category titles.
class CategoryTitles {
  final String people;
  final String nature;
  final String food;
  final String activity;
  final String travel;
  final String objects;
  final String symbols;
  final String flags;

  /// This class contains all category titles.
  ///
  /// [people] for [EmojiCategory.people]
  ///
  /// [nature] for [EmojiCategory.nature]
  ///
  /// [food] for [EmojiCategory.food]
  ///
  /// [activity] for [EmojiCategory.activity]
  ///
  /// [travel] for [EmojiCategory.travel]
  ///
  /// [objects] for [EmojiCategory.objects]
  ///
  /// [symbols] for [EmojiCategory.symbols]
  ///
  /// [flags] for [EmojiCategory.flags]
  const CategoryTitles({
    this.people = 'Smileys & People',
    this.nature = 'Animals & Nature',
    this.food = 'Food & Drink',
    this.activity = 'Activity',
    this.travel = 'Travel & Places',
    this.objects = 'Objects',
    this.symbols = 'Symbols',
    this.flags = 'Flags',
  });

  /// Get category title by it's [index]
  String operator [](int index) => <String>[
        people,
        nature,
        food,
        activity,
        travel,
        objects,
        symbols,
        flags,
      ][index];
}

/// CategoryIcons class that used to define all category icons.
class CategoryIcons {
  final Color color;
  final IconData people;
  final IconData nature;
  final IconData food;
  final IconData activity;
  final IconData travel;
  final IconData objects;
  final IconData symbols;
  final IconData flags;

  /// This class contains all category icons.
  ///
  /// Keyboard Header [color] is [Colors.with] by default.
  ///
  /// [people] for [EmojiCategory.people]
  ///
  /// [nature] for [EmojiCategory.nature]
  ///
  /// [food] for [EmojiCategory.food]
  ///
  /// [activity] for [EmojiCategory.activity]
  ///
  /// [travel] for [EmojiCategory.travel]
  ///
  /// [objects] for [EmojiCategory.objects]
  ///
  /// [symbols] for [EmojiCategory.symbols]
  ///
  /// [flags] for [EmojiCategory.flags]
  const CategoryIcons({
    this.people = Icons.sentiment_satisfied,
    this.nature = Icons.pets,
    this.food = Icons.fastfood,
    this.activity = Icons.directions_run,
    this.travel = Icons.location_city,
    this.objects = Icons.lightbulb_outline,
    this.symbols = Icons.euro_symbol,
    this.flags = Icons.flag,
    this.color = Colors.white,
  });

  /// Get category icon by it's [index]
  IconData operator [](int index) => <IconData>[
        people,
        nature,
        food,
        activity,
        travel,
        objects,
        symbols,
        flags,
      ][index];
}
