import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monumento/components/ar/ar_models.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/menu_widget.dart';

class ARModelsHomepage extends StatefulWidget {
  const ARModelsHomepage({Key? key}) : super(key: key);

  @override
  State<ARModelsHomepage> createState() => _ARModelsHomepageState();
}

class _ARModelsHomepageState extends State<ARModelsHomepage> {

  List m = [];

  @override
  void initState() {
    _models().then((value) {
      setState(() {
        m = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return homePage();
    
  }

  Widget homePage() {
    
    return Scaffold(
      appBar: AppBar(
        leading: MenuWidget(
          color: AppColors.bigTextColor,
        ),
        title: Text(
          '3D Models',
          style: TextStyle(color: AppColors.bigTextColor),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/3d-model.png',
                    height: 170,
                    width: 170,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      primary: false,
                      children: getModels(m),
                    ),
                  ),
                ],
              ),
            ),
      backgroundColor: Colors.white,
    );
  }

  List<Widget> getModels(List m) {
    List<Widget> models = [];
    for (int i = 0; i < m.length; i++) {
      models.add(GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ARModels(
                    monumentName: m[i]['name'], models: m[i]['models'])));
          },
          child: _card(m[i]['image'], m[i]['name'])));
    }
    return models;
  }

  Widget _card(String image, String text) {
    return Card(
      elevation: 6,
      color: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              image,
              height: 100,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontSize: 14, color: AppColors.bigTextColor),
            )
          ],
        ),
      ),
    );
  }

  Future<List> _models() async {
    final doc = await FirebaseFirestore.instance
                      .collection('ar_models')
                      .doc('ar_models').get();
    return doc['ar_models'];
  }
}
