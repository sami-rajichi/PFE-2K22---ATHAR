import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monumento/components/admin_dashboard/admin_ruins_navigator.dart';
import 'package:monumento/components/admin_dashboard/manage_accounts.dart';
import 'package:monumento/components/admin_dashboard/monuments/monuments_homepage.dart';
import 'package:monumento/components/admin_dashboard/requests/consult_rquest.dart';
import 'package:monumento/components/admin_dashboard/requests/requests_homepage.dart';
import 'package:monumento/components/ar/arUs.dart';
import 'package:monumento/components/profile/edit_profile.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/getAvatar.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';

class AdminHomepage extends StatefulWidget {
  final String? uid;
  const AdminHomepage({Key? key, required this.uid}) : super(key: key);

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var d = snapshot.data as DocumentSnapshot;
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                  leading: MenuWidget(
                    color: Colors.white,
                  ),
                  title: Text(
                    'Dashboard',
                    style: TextStyle(color: Colors.white),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  actions: [
                    showNotifications()
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 6.0),
                    //   child: Icon(
                    //     Icons.notifications_none,
                    //     color: Colors.white,
                    //     size: 30,
                    //   ),
                    // )
                  ]
              ),
              body: Stack(
                children: [
                  SizedBox(
                    height: double.infinity,
                  ),
                  Container(
                    height: 180,
                    width: size.height,
                    decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            primary: false,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => EditProfile(
                                                image: d['image'],
                                                name: d['name'],
                                                gender: d['gender'],
                                                email: d['email'],
                                                pass: d['password'])));
                                  },
                                  child: _card(d['image'], 'Profile')),
                              GestureDetector(
                                onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => MonumentsHomepage()));
                                  },
                                child: _card('assets/img/ruins.png', 'Monuments')),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ManageAccounts()));
                                  },
                                  child: _card(
                                      'assets/img/accounts.png', 'Accounts')),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RequestsHome()));
                                  },
                                  child: _card(
                                      'assets/img/requests.png', 'Requests')),
                              _card('assets/img/cubes.png', '3D Models'),
                              GestureDetector(
                                  onTap: () async {
                                    final isLoggedInWithGoogle =
                                        await GoogleSignIn().isSignedIn();
                                    final fbLoggedIn =
                                        FacebookAuth.instance.accessToken;
                                    if (isLoggedInWithGoogle) {
                                      GoogleSignIn().disconnect();
                                      FirebaseAuth.instance.signOut();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  NavigationDrawer()),
                                          (route) => false);
                                    } else if (fbLoggedIn != null) {
                                      await FacebookAuth.instance.logOut();
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  NavigationDrawer()),
                                          (route) => false);
                                    } else {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  NavigationDrawer()),
                                          (route) => false);
                                    }
                                  },
                                  child:
                                      _card('assets/img/logout.png', 'Logout')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              bottomNavigationBar: bottomBar(),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _card(String image, String text) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              image,
              height: 90,
            ),
            Text(
              text,
              style: GoogleFonts.montserrat(
                  fontSize: 14, color: AppColors.bigTextColor),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black38,
            blurRadius: 3,
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: AppColors.mainColor.withOpacity(0.5),
        iconSize: 25,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.camera_alt_rounded,
              ),
              label: 'Camera'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
              ),
              label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_rounded,
              ),
              label: 'Ruins'),
        ],
        currentIndex: 1,
        onTap: (int i) {
          if (i == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ArUs()));
          } else if (i == 2) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AdminRuinsNavigator()));
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NavigationDrawer()));
          }
        },
      ),
    );
  }

  Widget showNotifications() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .doc('requests')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var d = snapshot.data as DocumentSnapshot;
            List requests = [];
            for (Map<String, dynamic> e in d['requests']) {
              if (e['verified'] == 'no') {
                requests.add(e);
              }
            }
            return FocusedMenuHolder(
              menuWidth: 220,
              menuItems: _request(requests),
              blurBackgroundColor: AppColors.mainColor.withOpacity(0.4),
              openWithTap: true,
              onPressed: () {},
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Positioned(
                      top: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 9,
                        child: Text(
                          '${requests.length}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  List<FocusedMenuItem> _request(List req) {
    List<FocusedMenuItem> items = [];
    for (var i = 0; i < req.length; i++) {
      items.add(FocusedMenuItem(
        title: Text(req[i]['issue_type']),
        trailingIcon: Icon(Icons.report_gmailerrorred_rounded),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ConsultRequest(
                    email: req[i]['email'],
                    issue: req[i]['issue'],
                    issueType: req[i]['issue_type'],
                    verified: req[i]['verified'],
                    image: req[i]['issue_image'],
                  )));
        },
      ));
    }
    return items;
  }
}
