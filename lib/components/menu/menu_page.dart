import 'package:flutter/material.dart';
import 'package:monumento/d_b_icons_icons.dart';
import 'package:monumento/models/menu_item.dart';

class MenuItems {
  static const home = MI('Home', Icons.home);
  static const map = MI('Map', DBIcons.map);
  static const ar = MI('Augmented Reality', DBIcons.augmented_reality);
  static const category = MI('Archeological Sites', Icons.category);
  static const help = MI('Help', Icons.help);
  static const update = MI('Update', Icons.update);
  static const aboutUs = MI('About Us', Icons.info_outlined);

  static const all = <MI>[
    home,
    map,
    ar,
    category,
    help,
    update,
    aboutUs
  ];
}

class MenuPage extends StatelessWidget {

  final MI currentItem;
  final ValueChanged<MI> onSelectedItem;

  const MenuPage({ Key? key, 
  required this.currentItem, required this.onSelectedItem }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              ...MenuItems.all.map(buildItem).toList(),
              Spacer(flex: 1,)
            ],
          )
        ),
      ),
    );
  }

  Widget buildItem(MI e) => ListTileTheme(
    selectedColor: Colors.white,
    child: ListTile(
      selected: currentItem == e,
      selectedTileColor: Colors.black26,
      minVerticalPadding: 20,
      minLeadingWidth: 20,
      leading: Icon(e.icon),
      title: Text(e.text),
      onTap: () => onSelectedItem(e),
    ),
  );
}