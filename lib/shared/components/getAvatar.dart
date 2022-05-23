import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monumento/components/authentication/sign_in.dart';
import 'package:monumento/components/authentication/sign_up.dart';
import 'package:monumento/components/profile/favorites.dart';
import 'package:monumento/components/profile/profile_screen.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';

class GetAvatar extends StatefulWidget {
  String? img;
  String? name;
  String? gender;
  String? email;
  String? pass;
  final bool loggedIn;
  GetAvatar(
      {Key? key,
      required this.img,
      this.email,
      this.name,
      this.gender,
      this.pass,
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
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                              image: widget.img!,
                              name: widget.name!,
                              gender: widget.gender!,
                              email: widget.email!,
                              pass: widget.pass!,
                            )),
                    (route) => false),
              ),
              FocusedMenuItem(
                  title: Text('Favorites'),
                  trailingIcon: Icon(Icons.bookmark_border),
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => FavoritesScreen(
                                image: widget.img!,
                                name: widget.name!,
                                gender: widget.gender!,
                                email: widget.email!,
                                pass: widget.pass!,
                              )),
                      (route) => false)),
              FocusedMenuItem(
                title: Text('Sign Out'),
                trailingIcon: Icon(Icons.logout),
                onPressed: () async {
                  final isLoggedInWithGoogle =
                      await GoogleSignIn().isSignedIn();
                  final fbLoggedIn = FacebookAuth.instance.accessToken;
                  if (isLoggedInWithGoogle) {
                    GoogleSignIn().disconnect();
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => NavigationDrawer()),
                        (route) => false);
                  } else if (fbLoggedIn != null) {
                    await FacebookAuth.instance.logOut();
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => NavigationDrawer()),
                        (route) => false);
                  }
                  else {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => NavigationDrawer()),
                        (route) => false);
                  }
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
                  child: InkWell(
                    borderRadius: BorderRadius.circular(80),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover, image: getImage())),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  ImageProvider getImage() {
    if (widget.img == null) {
      return AssetImage('assets/img/avatar.png');
    } else if (widget.img!.startsWith('assets/')) {
      return AssetImage(widget.img!);
    } else if (widget.img!.startsWith('http')) {
      return NetworkImage(widget.img!);
    } else {
      return FileImage(File(widget.img!));
    }
  }
}
