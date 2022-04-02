import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:monumento/d_b_icons_icons.dart';
import 'package:monumento/shared/components/bottomBar.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:monumento/shared/components/neumorphism.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class HomeCategories extends StatefulWidget {
  const HomeCategories({Key? key}) : super(key: key);

  @override
  State<HomeCategories> createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {

  Map<String, String> classes = {
    'nord' : 'assets/map/nord.png',
    'centre' : 'assets/map/centre.png',
    'sud' : 'assets/map/sud.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MenuWidget(),
        title: Text(
          'Monumento'
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: neumorphicButton(
          child: Icon(DBIcons.search,),
          prColor: Colors.indigo.shade500,
          sdColor: Colors.indigo.shade800),
          )
        ],
        backgroundColor: Colors.indigo[500],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/map/nord.png',
            height: 700,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/map/centre.png',
            height: 700,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/map/sud.png',
            height: 700,
            fit: BoxFit.cover,
          ),
          
        ],
      ),
      bottomNavigationBar: ConvexBottomBar(
        backgroundColor: Colors.indigo[500]
      )
    );
  }

  clickable_class(String c, String clickable){
    
  }
}
