import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monumento/components/categories/buildCategoryPage.dart';
import 'package:monumento/components/categories/categories_home.dart';
import 'package:monumento/components/menu/menu_page.dart';
import 'package:monumento/components/welcomePage/welcome_page.dart';
import 'package:monumento/home.dart';
import 'package:monumento/shared/components/liquid_swipe_navigator.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD4nDMMhzUyFpcc_OM94TGWIOCsCSDeB5A",
      appId: "1:846144714798:android:de1dbb38a299bfd781c7bf",
      messagingSenderId: "846144714798",
      projectId: "monumento-2k22",
      storageBucket: "monumento-2k22.appspot.com"
    ),
  );
  runApp(MyApp());
}

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse, 
          PointerDeviceKind.touch, 
          PointerDeviceKind.stylus, 
          PointerDeviceKind.unknown},
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}