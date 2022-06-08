import 'package:flutter/material.dart';
import 'package:monumento/components/admin_dashboard/admin_navigator.dart';
import 'package:monumento/components/admin_dashboard/requests/manage_requests.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/menu_widget.dart';

class RequestsHome extends StatefulWidget {
  const RequestsHome({Key? key}) : super(key: key);

  @override
  State<RequestsHome> createState() => _RequestsHomeState();
}

class _RequestsHomeState extends State<RequestsHome> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: BackButton(
            onPressed: (() => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AdminNavigator())
            )),
            color: AppColors.bigTextColor,
          ),
          title: Text(
            'Requests',
            style: TextStyle(color: AppColors.bigTextColor),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0, vertical: 65),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/requests.png',
                height: 230,
                width: 230,
              ),
              SizedBox(height: 50,),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 38.0),
                      child: InkWell(
                        onTap: () {
                          String v = index != 0 ? 'no' : 'yes';
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => 
                              ManageRequests(verified: v,)
                            )
                          );
                        },
                        child: Material(
                          elevation: 8,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            leading: index == 0
                            ? Icon(
                              Icons.done_all_rounded,
                              color: AppColors.mainColor,
                            )
                            : Icon(
                              Icons.dangerous_outlined,
                              color: AppColors.mainColor,
                            ),
                            title:  index == 0 ? Text('Verified Requests') : Text('Unverified Requests'),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            tileColor: Colors.white,
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      );
  }
}