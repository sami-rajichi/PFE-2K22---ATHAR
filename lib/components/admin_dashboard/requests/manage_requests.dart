import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:monumento/components/admin_dashboard/requests/consult_rquest.dart';
import 'package:monumento/components/admin_dashboard/requests/requests_homepage.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/network/firebaseServices.dart';
import 'package:monumento/shared/components/neumorphic_image.dart';

class ManageRequests extends StatefulWidget {

  final String? verified;
  const ManageRequests({Key? key, required this.verified}) : super(key: key);

  @override
  State<ManageRequests> createState() => _ManageRequestsState();
}

class _ManageRequestsState extends State<ManageRequests> {
  FirebaseServices firebaseServices = new FirebaseServices();

  @override
  Widget build(BuildContext context) {
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
              if (e['verified'] == widget.verified){
                requests.add(e);
              }
            }
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: widget.verified == 'no'
                ? Text(
                  'Unverified Requests',
                  style: TextStyle(color: AppColors.bigTextColor),
                )
                : Text(
                  'Verified Requests',
                  style: TextStyle(color: AppColors.bigTextColor),
                ),
                centerTitle: true,
                leading: BackButton(
                  color: AppColors.bigTextColor,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RequestsHome()));
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
                                image: AssetImage('assets/img/requests.png'),
                                fit: BoxFit.fitHeight,
                                height: 150,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    _request(requests)
                  ],
                ),
              ),
              backgroundColor: AppColors.backgroundColor,
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _request(List req) {
    return Container(
      height: MediaQuery.of(context).size.height - 340,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: req.length,
          itemBuilder: (context, index) {
            final item = req[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Dismissible(
                key: UniqueKey(),
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
                direction: DismissDirection.startToEnd,
                onDismissed: (DismissDirection direction) {
                  switch (direction) {
                    case DismissDirection.startToEnd:
                      showDialog(
                          context: context,
                          builder: (context) => saveAlert(
                                req[index]['issue_type'],
                                req[index]['issue_image'],
                                req[index]['issue'],
                                req[index]['email'],
                              ));
                      break;
                    default:
                      print('Invalid Option !!');
                  }
                },
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConsultRequest(
                            email: req[index]['email'],
                            issue: req[index]['issue'],
                            issueType: req[index]['issue_type'],
                            verified: widget.verified,
                            image: req[index]['issue_image'],)));
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
                      leading: Image.asset(
                        req[index]['issue_image'],
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                      title: Text(req[index]['email']),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          req[index]['issue_type'],
                          overflow: TextOverflow.ellipsis,
                        ),
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
                                            req[index]['issue_type'],
                                            req[index]['issue_image'],
                                            req[index]['issue'],
                                            req[index]['email'],
                                          ));
                                },
                                icon: Icon(
                                  Icons.delete_sweep,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ConsultRequest(
                                          email: req[index]['email'],
                                          issue: req[index]['issue'],
                                          issueType: req[index]['issue_type'],
                                          verified: widget.verified,
                                          image: req[index]['issue_image'],)));
                                },
                                icon: Icon(
                                  Icons.edit_note,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      minLeadingWidth: 46,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future delete(BuildContext context, String issueType, String img,
      String issue, String email) async {
    try {
      var data = [
        {
          'issue_type': issueType,
          'issue': issue,
          'email': email,
          'verified': 'no',
          'issue_image': img
        }
      ];
      await FirebaseFirestore.instance
          .collection('requests')
          .doc('requests')
          .update({'requests': FieldValue.arrayRemove(data)});

      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'An issue has been deleted successfully\n\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          TextSpan(
              text: 'An issue from $email has been deleted',
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
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 4),
        // shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget saveAlert(String issueType, String img, String issue, String email) {
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
                      'Would you really want to delete this issue?',
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
                                  builder: (context) => ManageRequests(verified: widget.verified,)));
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
                            delete(context, issueType, img, issue, email);
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
}
