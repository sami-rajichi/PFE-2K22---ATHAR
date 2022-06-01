import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:monumento/components/request_help/request_help_navigator.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestHelp extends StatefulWidget {
  const RequestHelp({Key? key}) : super(key: key);

  @override
  State<RequestHelp> createState() => _RequestHelpState();
}

class _RequestHelpState extends State<RequestHelp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FormGroup buildForm() => fb.group(<String, Object>{
        'name': FormControl<String>(
          validators: [Validators.required, Validators.maxLength(5000)],
        ),
        'email': FormControl<String>(
          validators: [Validators.required, Validators.email],
        ),
      });
  FormGroup buildForm2() => fb.group(<String, Object>{
        'name': FormControl<String>(
          validators: [Validators.required, Validators.maxLength(5000)],
        ),
        'email': FormControl<String>(
          validators: [Validators.email],
        ),
      });
  TextEditingController feedbackController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool loading = false;
  bool isError = false;
  String kindOfSupport = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (auth.currentUser != null) {
        emailController.text = auth.currentUser!.email!;
      }
    });
    feedbackController.addListener(() {
      setState(() {});
    });
    emailController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    feedbackController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return notLoggedIn();
    } else {
      var uid = auth.currentUser!.uid;
      return loggedIn(uid, auth.currentUser!);
    }
  }

  Widget notLoggedIn() {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: MenuWidget(
          color: AppColors.bigTextColor,
        ),
        title: Text(
          'Request Help',
          style: TextStyle(color: AppColors.bigTextColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 20,
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
                height: 26,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Text(
                  'It looks like you are experiencing problems with our application. We are here to help, so please get in touch with us.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.bigTextColor.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ReactiveFormBuilder(
                form: buildForm,
                builder: (context, form, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ReactiveTextField<String>(
                        controller: emailController,
                        formControlName: 'email',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'The email must not be empty',
                          ValidationMessage.email:
                              'The email value must be a valid email',
                          'unique': 'This email is already in use',
                        },
                        style: TextStyle(
                          fontSize: 16.0,
                          color: const Color(0xFF151624),
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: const Color(0xFF151624).withOpacity(0.5),
                            ),
                            filled: true,
                            fillColor: emailController.text.isEmpty
                                ? Colors.grey[200]
                                : Colors.transparent,
                            helperText: '',
                            helperStyle: TextStyle(height: 0.7),
                            errorStyle: TextStyle(height: 0.7),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  emailController.clear();
                                },
                                icon: Icon(
                                  Icons.close,
                                  size: 20,
                                ))),
                      ),
                      const SizedBox(height: 8.0),
                      DropdownSearch<String>(
                        items: [
                          "Mentoring Support",
                          "Technical Support",
                          "Informational Support",
                          'Other'
                        ],
                        dropdownSearchDecoration: InputDecoration(
                          hintText: "Issue type",
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            color: const Color(0xFF151624).withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: kindOfSupport.isEmpty
                              ? Colors.grey[200]
                              : Colors.transparent,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        popupProps: const PopupProps.menu(
                          fit: FlexFit.loose,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        onChanged: (String? item) {
                          setState(() {
                            kindOfSupport = item!;
                            isError = false;
                          });
                        },
                      ),
                      Visibility(
                        visible: isError,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 4),
                            child: Text(
                              'Kind of support must not be empty',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red.withOpacity(.95),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: isError ? 8 : 23,
                      ),
                      ReactiveTextField<String>(
                        controller: feedbackController,
                        formControlName: 'name',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'The issue must not be empty',
                          ValidationMessage.maxLength:
                              'The issue must contain at maximum 2000 characters',
                        },
                        style: TextStyle(
                          fontSize: 16.0,
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
                          fillColor: feedbackController.text.isEmpty
                              ? Colors.grey[200]
                              : Colors.transparent,
                          helperText: '',
                          helperStyle: TextStyle(height: 0.7),
                          errorStyle: TextStyle(height: 0.7),
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      loading 
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(size.width * 0.42, size.height / 16),
                            // primary: Color(0xFF21899C),
                            primary: AppColors.mainColor,
                            elevation: 6),
                        onPressed: () {
                          if (form.valid && kindOfSupport != '') {
                            sendRequest(false, feedbackController,
                                kindOfSupport, emailController, context);
                          } else {
                            setState(() {
                              isError = true;
                            });
                            form.markAllAsTouched();
                          }
                        },
                        child: Text('Send Request',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            )),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loggedIn(String uid, User user) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: MenuWidget(
          color: AppColors.bigTextColor,
        ),
        title: Text(
          'Request Help',
          style: TextStyle(color: AppColors.bigTextColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 20,
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
                height: 26,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Text(
                  'It looks like you are experiencing problems with our application. We are here to help, so please get in touch with us.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.bigTextColor.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 20,
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
                          fontSize: 16.0,
                          color: const Color(0xFF151624),
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            fontSize: 15.0,
                            color: const Color(0xFF151624).withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          helperText: '',
                          helperStyle: TextStyle(height: 0.7),
                          errorStyle: TextStyle(height: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      DropdownSearch<String>(
                        items: [
                          "Mentoring Support",
                          "Technical Support",
                          "Informational Support",
                          'Other'
                        ],
                        dropdownSearchDecoration: InputDecoration(
                          hintText: "Issue type",
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            color: const Color(0xFF151624).withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: kindOfSupport.isEmpty
                              ? Colors.grey[200]
                              : Colors.transparent,
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        popupProps: const PopupProps.menu(
                          fit: FlexFit.loose,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        onChanged: (String? item) {
                          setState(() {
                            kindOfSupport = item!;
                            isError = false;
                          });
                        },
                      ),
                      Visibility(
                        visible: isError,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 4),
                            child: Text(
                              'Kind of support must not be empty',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red.withOpacity(.95),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: isError ? 6 : 23,
                      ),
                      ReactiveTextField<String>(
                        controller: feedbackController,
                        formControlName: 'name',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'The issue must not be empty',
                          ValidationMessage.maxLength:
                              'The issue must contain at maximum 2000 characters',
                        },
                        style: TextStyle(
                          fontSize: 14.0,
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
                          fillColor: feedbackController.text.isEmpty
                              ? Colors.grey[200]
                              : Colors.transparent,
                          helperText: '',
                          helperStyle: TextStyle(height: 0.7),
                          errorStyle: TextStyle(height: 0.7),
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      loading 
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(size.width * 0.42, size.height / 16),
                            // primary: Color(0xFF21899C),
                            primary: AppColors.mainColor,
                            elevation: 6),
                        onPressed: () {
                          if (form.valid && kindOfSupport != '') {
                            sendRequest(true, feedbackController, kindOfSupport,
                                emailController, context);
                          } else {
                            setState(() {
                              isError = true;
                            });
                            form.markAllAsTouched();
                          }
                        },
                        child: Text('Send Request',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            )),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future sendRequest(
      bool loggedIn,
      TextEditingController issue,
      String issueType,
      TextEditingController email,
      BuildContext context) async {
    try {
      setState(() {
        loading = true;
      });

      await FirebaseFirestore.instance.collection('requests_help').doc().set({
        'issue_type': issueType,
        'issue': issue.text,
        'email': email.text,
      });

      await sendEmail(loggedIn, email);

      setState(() {
        loading = false;
      });

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return successAlert(
              'assets/animations/email.json',
              'Request Sent Successfully',
              'We will come back to you as soon as possible',
            );
          });

    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Request Sent Failed\n\n',
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
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 100),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future sendEmail(
    bool loggedIn, TextEditingController email,) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_2v330ab';
    const templateId = 'template_7px4rnn';
    const userId = 'wboHp6njrVdV8c9en';
    final name = email.text;
    final subject = kindOfSupport == 'Other' ? ' An issue from ' + email.text : kindOfSupport + ' to ' + email.text;
    final issue = feedbackController.text;
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json'
      },
      body: json.encode(
        {
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'name': name,
            'subject': subject,
            'user_issue': issue,
            'user_email': email.text
          }
        }
      )
    );
    return response.statusCode;
  }

  Widget successAlert(String header, String title, String desc){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)
      ),
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
                    title, 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 19,
                      ),),
                  SizedBox(height: 15,),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                    
                  ),
                  SizedBox(height: 25,),
                  ElevatedButton(onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RequestHelpNavigator())
                    );
                  },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.mainColor,
                      padding: EdgeInsets.all(12),
                      elevation: 4
                    ),
                    child: Text(
                      'Okay', 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15),),
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
                header,
                fit: BoxFit.cover,
                repeat: false,
                ),
            )
          ),
        ],
      )
    );
  }
}