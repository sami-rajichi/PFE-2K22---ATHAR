import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:monumento/components/admin_dashboard/requests/manage_requests.dart';
import 'package:monumento/components/maps/maps_utils.dart';
import 'package:monumento/constants/colors.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ConsultRequest extends StatefulWidget {
  final String? email;
  final String? issue;
  final String? issueType;
  final String? verified;
  final String? image;
  const ConsultRequest(
      {Key? key,
      required this.email,
      required this.issue,
      required this.issueType,
      required this.verified,
      required this.image})
      : super(key: key);

  @override
  State<ConsultRequest> createState() => _ConsultRequestState();
}

class _ConsultRequestState extends State<ConsultRequest> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FormGroup buildForm2() => fb.group(<String, Object>{
        'name': FormControl<String>(
          validators: [Validators.required, Validators.maxLength(5000)],
        ),
        'email': FormControl<String>(
          validators: [Validators.email],
        ),
      });
  TextEditingController feedbackController = TextEditingController();
  TextEditingController issueTypeController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      emailController.text = widget.email!;
      feedbackController.text = widget.issue!;
      issueTypeController.text = widget.issueType!;
    });
    super.initState();
  }

  @override
  void dispose() {
    feedbackController.dispose();
    emailController.dispose();
    issueTypeController.dispose();
    super.dispose();
  }

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
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ManageRequests(verified: widget.verified)));
          },
        ),
        title: Text(
          'Consulting Issue',
          style: TextStyle(color: AppColors.bigTextColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
            ),
            Container(
              width: size.width * 0.7,
              height: size.height * 0.20,
              child: Image.asset(
                'assets/img/assistant.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ReactiveFormBuilder(
              form: buildForm2,
              builder: (context, form, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ReactiveTextField<String>(
                      controller: emailController,
                      formControlName: 'email',
                      readOnly: true,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: const Color(0xFF151624),
                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    ReactiveTextField<String>(
                      controller: issueTypeController,
                      formControlName: 'name',
                      readOnly: true,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: const Color(0xFF151624),
                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    ReactiveTextField<String>(
                      readOnly: true,
                      controller: feedbackController,
                      formControlName: 'name',
                      validationMessages: (control) => {
                        ValidationMessage.required:
                            'The issue must not be empty',
                        ValidationMessage.maxLength:
                            'The issue must contain at maximum 2000 characters',
                      },
                      style: TextStyle(
                        fontSize: 18.0,
                        color: const Color(0xFF151624),
                      ),
                      maxLines: 9,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      maxLength: 5000,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      decoration: InputDecoration(
                        hintText: 'Issue details',
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: const Color(0xFF151624).withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    widget.verified == 'no'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.black45),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 13),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    primary: Colors.grey[600],
                                  ),
                                  onPressed: () {
                                    verifyRequest();
                                  },
                                  child: Text('VERIFIED',
                                      style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 2.2,
                                          color: Colors.black87)),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.grey[600],
                                    backgroundColor: AppColors.mainColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 35, vertical: 12),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  onPressed: () {
                                    String subj = issueTypeController.text;
                                    if (subj == 'Other') {
                                      subj = 'Other Support ';
                                    }
                                    MapUtils.launchEmail(
                                        emailController.text, subj);
                                  },
                                  child: Text(
                                    'REPLY',
                                    style: TextStyle(
                                        fontSize: 15,
                                        letterSpacing: 2.2,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> verifyRequest() async {
    var oldData = [
      {
        'issue_type': widget.issueType,
        'issue': widget.issue,
        'email': widget.email,
        'verified': widget.verified,
        'issue_image': widget.image
      }
    ];
    var newData = [
      {
        'issue_type': widget.issueType,
        'issue': widget.issue,
        'email': widget.email,
        'verified': 'yes',
        'issue_image': widget.image
      }
    ];
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc('requests')
          .update({'requests': FieldValue.arrayRemove(oldData)});

      await FirebaseFirestore.instance
      .collection('new_requests')
      .doc('new_requests').update({'nb_req': FieldValue.increment(-1)});

      await FirebaseFirestore.instance
          .collection('requests')
          .doc('requests')
          .update({'requests': FieldValue.arrayUnion(newData)});
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ManageRequests(verified: widget.verified)));
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'A request has been verified successfully\n\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          TextSpan(
              text: 'A request from ${widget.email} has been verified',
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
}
