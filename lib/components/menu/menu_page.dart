import 'package:flutter/material.dart';
import 'package:monumento/d_b_icons_icons.dart';
import 'package:monumento/models/menu_item.dart';

class MenuItems {
  static const home = MI('Home', Icons.home);
  static const ar = MI('Camera', Icons.camera);
  static const category = MI('Archeological Sites', Icons.account_balance_rounded);
  static const arModels = MI('3D Models', Icons.category);
  static const requestHelp = MI('Report Issue', Icons.assistant);
  static const rateUs = MI('Rate Us', Icons.feedback_sharp);

  static const all = <MI>[
    home,
    ar,
    category,
    arModels,
    requestHelp,
    rateUs,
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