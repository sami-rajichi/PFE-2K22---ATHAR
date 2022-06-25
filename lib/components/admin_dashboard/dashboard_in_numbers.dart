import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/models/users.dart';
import 'package:monumento/network/firebaseServices.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashboardInNumbers extends StatefulWidget {
  final int? nbOfIssues;
  const DashboardInNumbers({Key? key, this.nbOfIssues}) : super(key: key);

  @override
  State<DashboardInNumbers> createState() => _DashboardInNumbersState();
}

class _DashboardInNumbersState extends State<DashboardInNumbers> {
  int monuments = 0;
  FirebaseServices firebaseServices = FirebaseServices();
  Future<int> getMonuments() async {
    final doc = await FirebaseFirestore.instance
        .collection('ar_models')
        .doc('ar_models')
        .get();
    List mms = doc['ar_models'];
    return mms.length;
  }

  @override
  void initState() {
    getMonuments().then((value) {
      setState(() {
        monuments = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 10,),
            Image.asset(
              'assets/img/athar.png',
              width: 100,
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StreamBuilder<List<Users>>(
                    stream: firebaseServices.getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Users> accounts = snapshot.data!;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              animation: true,
                              animationDuration: 1500,
                              radius: 30,
                              lineWidth: 5,
                              percent: 1,
                              progressColor: AppColors.mainColor.withOpacity(.8),
                              backgroundColor:
                                  AppColors.mainColor.withOpacity(.5),
                              center: Text(
                                '${accounts.length}',
                                style: TextStyle(
                                    fontSize: 18, color: AppColors.mainColor),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:3.0),
                              child: Text(
                                'Accounts',
                                style: TextStyle(
                                    fontSize: 16, color: AppColors.mainColor),
                              ),
                            )
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      animation: true,
                      animationDuration: 1500,
                      radius: 30,
                      lineWidth: 5,
                      percent: 1,
                      progressColor: Colors.green,
                      backgroundColor: Colors.green.withOpacity(.5),
                      center: Text(
                        '$monuments',
                        style: TextStyle(
                            fontSize: 18, color: Colors.green),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        'Monuments',
                        style:
                            TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    )
                  ],
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('requests')
                        .doc('requests')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var d = snapshot.data as DocumentSnapshot;
                        List issues = [];
                        for (Map<String, dynamic> e in d['requests']) {
                          issues.add(e);
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              animation: true,
                              animationDuration: 1500,
                              radius: 30,
                              lineWidth: 5,
                              percent: 1,
                              progressColor: Colors.blue[400],
                              backgroundColor:
                                  Colors.blue.withOpacity(.5),
                              center: Text(
                                '${issues.length}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.blue[400]),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(
                                'Issues',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.blue[400]),
                              ),
                            )
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              ],
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
