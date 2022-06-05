import 'package:flutter/material.dart';
import 'package:monumento/models/menu_item.dart';

class AdminPanelMenu {
  static const dashboard = MI('Dashboard', Icons.dashboard);
  static const ar = MI('Camera', Icons.camera);
  static const category = MI('Archeological Sites', Icons.account_balance_rounded);
  static const update = MI('Changelog', Icons.update_rounded);

  static const all = <MI>[
    dashboard,
    ar,
    category,
    update,
  ];
}

class AdminMenuPage extends StatelessWidget {

  final MI currentItem;
  final ValueChanged<MI> onSelectedItem;

  const AdminMenuPage({ Key? key, 
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
              ...AdminPanelMenu.all.map(buildItem).toList(),
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