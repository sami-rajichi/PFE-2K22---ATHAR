import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:monumento/components/authentication/sign_in.dart';
import 'package:monumento/components/authentication/sign_up.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';

class NotLoggedInPage extends StatelessWidget {

  final String? pageTitle;
  const NotLoggedInPage({Key? key, required this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: BackButton(
          color: AppColors.bigTextColor,
          onPressed: (() => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NavigationDrawer())))),
        title: Text(
          pageTitle!,
          style: TextStyle(color: AppColors.bigTextColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Column(
          children: [
            Lottie.asset('assets/animations/notLoggedIn.json',
                height: size.height * 0.4, repeat: true),
            SizedBox(
              height: 20,
            ),
            Text(
              'Oops.. You need to login first in order to profit of this page.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 26.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black45),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          primary: Colors.grey[600],
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => SignUp()),
                              (route) => false);
                        },
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2.2,
                              color: Colors.black87),
                        )),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.grey[600],
                        backgroundColor: AppColors.mainColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => SignIn()),
                              (route) => false);
                      },
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );    
  }
}