import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:monumento/components/authentication/sign_in.dart';
import 'package:monumento/components/authentication/sign_up.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';

class GetAvatar extends StatefulWidget {
  String? img;
  final bool loggedIn;
  GetAvatar({Key? key, 
  required this.img, 
  required this.loggedIn})
      : super(key: key);

  @override
  State<GetAvatar> createState() => _GetAvatarState();
}

class _GetAvatarState extends State<GetAvatar> {
  @override
  Widget build(BuildContext context) {
    return !widget.loggedIn
        ? FocusedMenuHolder(
            menuWidth: 180,
            menuItems: [
              FocusedMenuItem(
                  title: Text('Sign In'),
                  trailingIcon: Icon(Icons.login),
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SignIn()),
                      (route) => false)),
              FocusedMenuItem(
                title: Text('Sign Up'),
                trailingIcon: Icon(Icons.lock_open_outlined),
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignUp()),
                    (route) => false),
              ),
            ],
            blurBackgroundColor: AppColors.mainColor.withOpacity(0.4),
            openWithTap: true,
            onPressed: () {},
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ClipOval(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    widget.img!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          )
        : FocusedMenuHolder(
            menuWidth: 180,
            menuItems: [
              FocusedMenuItem(
                  title: Text('Profile'),
                  trailingIcon: Icon(Icons.person_outline),
                  onPressed: () {}),
              FocusedMenuItem(
                  title: Text('Favorites'),
                  trailingIcon: Icon(Icons.bookmark_border),
                  onPressed: () {}),
              FocusedMenuItem(
                title: Text('Sign Out'),
                trailingIcon: Icon(Icons.logout),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => NavigationDrawer()),
                      (route) => false);
                },
              ),
            ],
            blurBackgroundColor: AppColors.mainColor.withOpacity(0.4),
            openWithTap: true,
            onPressed: () {},
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ClipOval(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    widget.img!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
  }
}
