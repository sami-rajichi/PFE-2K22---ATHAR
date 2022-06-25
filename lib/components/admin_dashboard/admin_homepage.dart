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
import 'package:lottie/lottie.dart';
import 'package:monumento/components/admin_dashboard/dashboard_in_numbers.dart';
import 'package:monumento/components/admin_dashboard/manage_accounts.dart';
import 'package:monumento/components/admin_dashboard/monuments/monuments_homepage.dart';
import 'package:monumento/components/admin_dashboard/requests/consult_rquest.dart';
import 'package:monumento/components/admin_dashboard/requests/manage_requests.dart';
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
                    Padding(
                      padding: const EdgeInsets.only(top: 9.0),
                      child: showNotifications(),
                    )
                  ]),
              backgroundColor: AppColors.backgroundColor,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 180,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Transform.translate(
                        offset: Offset(0, -100),
                        child: Container(
                          height: 720,
                          child: ListView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            children: [
                              DashboardInNumbers(),
                              SizedBox(
                                height: 590,
                                child: GridView.count(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  primary: true,
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
                                                  builder: (context) =>
                                                      MonumentsHomepage()));
                                        },
                                        child: _card(
                                            'assets/img/ruins.png', 'Monuments')),
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
                                            'assets/img/requests.png', 'Issues')),
                                    GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) => saveAlert());
                                        },
                                        child:
                                            _card('assets/img/logout.png', 'Logout')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
              menuWidth: 200,
              menuItems: _request(requests),
              blurBackgroundColor: AppColors.mainColor.withOpacity(0.4),
              openWithTap: true,
              onPressed: () {},
              child: requests.length == 0
                  ? Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  : Stack(
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
    int ts = 0;
    int infs = 0;
    int ms = 0;
    int os = 0;
    for (var i = 0; i < req.length; i++) {
      switch (req[i]['issue_type']) {
        case 'Technical Support':
          ts = ts + 1;
          break;
        case 'Informational Support':
          infs = infs + 1;
          break;
        case 'Mentoring Support':
          ms = ms + 1;
          break;
        case 'Other':
          os = os + 1;
          break;
        default:
          ts = 0;
          infs = 0;
          ms = 0;
          os = 0;
      }
    }
    Map s = {
      'Technical Support': ts,
      'Informational Support': infs,
      'Mentoring Support': ms,
      'Other Services': os,
    };
    for (var i in s.keys) {
      items.add(FocusedMenuItem(
        title: SizedBox(
          width: 170,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(i), Spacer(), Text(s[i].toString())],
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ManageRequests(verified: 'no')));
        },
      ));
    }
    return items;
  }

  Widget saveAlert() {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 240,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 65, 10, 10),
                child: Column(
                  children: [
                    Text(
                      'Logout',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Would you really want to logout?',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
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
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2.2,
                                  color: Colors.black87),
                            )),
                        ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.grey[600],
                            backgroundColor: AppColors.mainColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 35, vertical: 12),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () async {
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
                                      builder: (_) => NavigationDrawer()),
                                  (route) => false);
                            } else if (fbLoggedIn != null) {
                              await FacebookAuth.instance.logOut();
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => NavigationDrawer()),
                                  (route) => false);
                            } else {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => NavigationDrawer()),
                                  (route) => false);
                            }
                          },
                          child: Text(
                            "LOGOUT",
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: -35,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  child: Lottie.asset(
                    'assets/animations/warning.json',
                    fit: BoxFit.cover,
                    repeat: false,
                  ),
                )),
          ],
        ));
  }
}
