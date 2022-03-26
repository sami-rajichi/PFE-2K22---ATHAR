import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class HomeCategories extends StatefulWidget {
  const HomeCategories({Key? key}) : super(key: key);

  @override
  State<HomeCategories> createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  late MapShapeSource _dataSource;

  @override
  void initState() {
    _dataSource = MapShapeSource.asset(
      'assets/Map/Tunisia.json',
      shapeDataField: 'name',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SfMaps(
          layers: [
            MapShapeLayer(source: _dataSource),
          ],
        ),
      ),
    );
  }
}
