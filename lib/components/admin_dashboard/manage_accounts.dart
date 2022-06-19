import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:monumento/components/admin_dashboard/admin_navigator.dart';
import 'package:monumento/components/admin_dashboard/consult_account.dart';
import 'package:monumento/components/admin_dashboard/create_account.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/models/users.dart';
import 'package:monumento/network/firebaseServices.dart';
import 'package:monumento/shared/components/neumorphic_image.dart';

class ManageAccounts extends StatefulWidget {

  
  const ManageAccounts({Key? key}) : super(key: key);

  @override
  State<ManageAccounts> createState() => _ManageAccountsState();
}

class _ManageAccountsState extends State<ManageAccounts> {
  FirebaseServices firebaseServices = new FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Users>>(
        stream: firebaseServices.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final accounts = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Accounts',
                  style: TextStyle(color: AppColors.bigTextColor),
                ),
                centerTitle: true,
                leading: BackButton(
                  color: AppColors.bigTextColor,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminNavigator()));
                  },
                ),
                
              ),
              body: Container(
                padding: EdgeInsets.only(left: 20, top: 30, right: 20),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          neumorphicImage(
                              color: Colors.white,
                              image: Image(
                                image: AssetImage('assets/img/accounts.png'),
                                fit: BoxFit.fitHeight,
                                height: 150,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    _accounts(accounts)
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.person_add_alt,
                  color: Colors.white,
                ),
                backgroundColor: AppColors.mainColor,
                onPressed: () {
                  var acc = adminPassword(accounts);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(
                        builder: (_) => 
                        CreateAccount(userEmail:acc[0], userpassword: acc[1],)));
                },
              ),
              backgroundColor: AppColors.backgroundColor,
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _accounts(List<Users> accounts) {
    return Container(
      height: MediaQuery.of(context).size.height - 340,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            final item = accounts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Dismissible(
                key: UniqueKey(),
                secondaryBackground: const Card(
                  color: Colors.green,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                background: const Card(
                  color: Colors.red,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.delete_sweep,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                onDismissed: (DismissDirection direction) {
                  switch (direction) {
                    case DismissDirection.endToStart:
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ConsultAccount(
                              image: accounts[index].image!,
                              name: accounts[index].name!,
                              gender: accounts[index].gender!,
                              email: accounts[index].email!,
                              pass: accounts[index].password!)));
                      break;
                    case DismissDirection.startToEnd:
                      showDialog(
                          context: context,
                          builder: (context) => saveAlert(
                              accounts[index].name!,
                              accounts[index].uid!,
                              accounts[index].email!,
                              accounts[index].password!,
                              accounts[index].providerId!,
                              accounts[index].accessToken!,
                              accounts[index].idToken!));
                      break;
                    default:
                      print('Invalid Option !!');
                  }
                },
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConsultAccount(
                            image: accounts[index].image!,
                            name: accounts[index].name!,
                            gender: accounts[index].gender!,
                            email: accounts[index].email!,
                            pass: accounts[index].password!)));
                  },
                  child: Material(
                    elevation: 8,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: ListTile(
                      key: ObjectKey(item),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: getImage(accounts[index].image!),
                      ),
                      title: Text(accounts[index].name!),
                      subtitle: Text(
                        accounts[index].email!,
                        overflow: TextOverflow.ellipsis,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      tileColor: Colors.white,
                      trailing: Transform.translate(
                        offset: Offset(8, 0),
                        child: SizedBox(
                          width: 96,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => saveAlert(
                                          accounts[index].name!,
                                          accounts[index].uid!,
                                          accounts[index].email!,
                                          accounts[index].password!,
                                          accounts[index].providerId!,
                                          accounts[index].accessToken!,
                                          accounts[index].idToken!));
                                },
                                icon: Icon(
                                  Icons.delete_sweep,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ConsultAccount(
                                          image: accounts[index].image!,
                                          name: accounts[index].name!,
                                          gender: accounts[index].gender!,
                                          email: accounts[index].email!,
                                          pass: accounts[index].password!)));
                                },
                                icon: Icon(
                                  Icons.remove_red_eye_rounded,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      minLeadingWidth: 60,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Image getImage(String image) {
    if (image == null) {
      return Image.asset(
        'assets/img/avatar.png',
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      );
    } else if (image.startsWith('assets/')) {
      return Image.asset(
        image,
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      );
    } else if (image.startsWith('http')) {
      return Image.network(
        image,
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(image),
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      );
    }
  }

  Future delete(
    BuildContext context, 
    String uid, 
    String name, 
    String email,
    String password,
    String providerId,
    String accessToken,
    String idToken) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final user = _auth.currentUser;
      switch (providerId) {
        case 'google.com':
          AuthCredential credentials =
          GoogleAuthProvider.credential(accessToken: accessToken, idToken: idToken);
          final result = await user!.reauthenticateWithCredential(credentials);
          await result.user!.delete();
          await user.reload();
          break;
        case 'facebook.com':
          OAuthCredential credentials =
          FacebookAuthProvider.credential(accessToken);
          final result = await user!.reauthenticateWithCredential(credentials);
          await result.user!.delete();
          await user.reload();
          break;
        default:
          AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
          final result = await user!.reauthenticateWithCredential(credentials);
          await result.user!.delete();
          await user.reload();
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Account Deleted Successfully\n\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          TextSpan(
              text: '${name} has been deleted from the system',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
        ])),
        backgroundColor: AppColors.mainColor,
        duration: Duration(seconds: 4),
        // shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Deletion Failed\n\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          TextSpan(
              text: '[' +
                  e.code.toString() +
                  ']:' +
                  e.toString().substring(e.toString().lastIndexOf(']') + 1),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
        ])),
        backgroundColor: AppColors.mainColor,
        duration: Duration(seconds: 4),
        // shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget saveAlert(
    String name, 
    String uid, String email, 
    String password,
    String providerId,
    String accessToken,
    String idToken) {
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
                      'Delete Account',
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
                      'Would you really want to delete ${name}',
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ManageAccounts()));
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
                          onPressed: () {
                            delete(context, uid, name, email, password, providerId, accessToken, idToken);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "DELETE",
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

  List<String> adminPassword(List<Users> accounts){
    for (var u in accounts) {
      if (u.email == 'admin-athar@gmail.com'){
        return [u.email!, u.password!];
      }
    }
    return ['admin', 'admin'];
  }
}