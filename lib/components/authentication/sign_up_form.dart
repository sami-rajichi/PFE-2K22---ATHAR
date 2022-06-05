import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monumento/components/authentication/sign_in.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/success_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignUpFormBuild extends StatefulWidget {
  const SignUpFormBuild({Key? key}) : super(key: key);

  @override
  State<SignUpFormBuild> createState() => _SignUpFormBuildState();
}

class _SignUpFormBuildState extends State<SignUpFormBuild> {
  FormGroup buildForm() => fb.group(<String, Object>{
        'name': FormControl<String>(validators: [
          Validators.required,
          Validators.pattern(r"^[a-zA-Z ,.'-]+$")
        ]),
        'email': FormControl<String>(
          validators: [Validators.required, Validators.email],
        ),
        'password': ['', Validators.required, Validators.minLength(8)],
        'passwordConfirmation': ['', Validators.required],
      }, [
        Validators.mustMatch('password', 'passwordConfirmation')
      ]);
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passConfController = TextEditingController();

  bool isVisible = true;
  bool isVisible2 = true;
  bool loading = false;

  List values = <String>['Woman', 'Man'];
  String selectedValue = '';
  final selectedColor = AppColors.mainColor;
  final unselectedColor = Color(0xFF151624).withOpacity(0.7);
  final unselectedErrorColor = Colors.red;
  bool isError = false;

  @override
  void initState() {
    emailController.addListener(() {
      setState(() {});
    });
    nameController.addListener(() {
      setState(() {});
    });
    passController.addListener(() {
      setState(() {});
    });
    passConfController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passController.dispose();
    passConfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReactiveTextField<String>(
                controller: nameController,
                formControlName: 'name',
                validationMessages: (control) => {
                  ValidationMessage.required: 'The name must not be empty',
                  ValidationMessage.pattern:
                      'The name value must be a valid name',
                },
                style: GoogleFonts.inter(
                  fontSize: 18.0,
                  color: const Color(0xFF151624),
                ),
                maxLines: 1,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: const Color(0xFF151624).withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: nameController.text.isEmpty
                        ? const Color.fromRGBO(248, 247, 251, 1)
                        : Colors.transparent,
                    labelText: 'Name',
                    helperText: '',
                    helperStyle: TextStyle(height: 0.7),
                    errorStyle: TextStyle(height: 0.7),
                    prefixIcon: Icon(
                      Icons.abc_rounded,
                      size: 18,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          nameController.clear();
                        },
                        icon: Icon(
                          Icons.close,
                          size: 20,
                        ))),
              ),
              Transform.translate(
                  offset: Offset(0, -6), child: radioButtonField3()),
              Visibility(
                visible: isError,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Transform.translate(
                      offset: Offset(0, -14),
                      child: Text(
                        'The gender must not be empty',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              ReactiveTextField<String>(
                controller: emailController,
                formControlName: 'email',
                validationMessages: (control) => {
                  ValidationMessage.required: 'The email must not be empty',
                  ValidationMessage.email:
                      'The email value must be a valid email',
                  'unique': 'This email is already in use',
                },
                style: GoogleFonts.inter(
                  fontSize: 18.0,
                  color: const Color(0xFF151624),
                ),
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: const Color(0xFF151624).withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: emailController.text.isEmpty
                        ? const Color.fromRGBO(248, 247, 251, 1)
                        : Colors.transparent,
                    labelText: 'Email',
                    helperText: '',
                    helperStyle: TextStyle(height: 0.7),
                    errorStyle: TextStyle(height: 0.7),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      size: 18,
                    ),
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
              ReactiveTextField<String>(
                controller: passController,
                formControlName: 'password',
                obscureText: isVisible,
                validationMessages: (control) => {
                  ValidationMessage.required: 'The password must not be empty',
                  ValidationMessage.minLength:
                      'The password must be at least 8 characters',
                },
                keyboardType: TextInputType.visiblePassword,
                onSubmitted: () => form.focus('passwordConfirmation'),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: const Color(0xFF151624).withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: passController.text.isEmpty
                        ? const Color.fromRGBO(248, 247, 251, 1)
                        : Colors.transparent,
                    helperText: '',
                    helperStyle: TextStyle(height: 0.7),
                    errorStyle: TextStyle(height: 0.7),
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      size: 18,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: isVisible
                            ? Icon(
                                Icons.visibility,
                                size: 20,
                              )
                            : Icon(
                                Icons.visibility_off,
                                size: 18,
                              ))),
              ),
              const SizedBox(
                height: 8.0,
              ),
              ReactiveTextField<String>(
                controller: passConfController,
                formControlName: 'passwordConfirmation',
                obscureText: isVisible2,
                validationMessages: (control) => {
                  ValidationMessage.mustMatch:
                      'Password confirmation must match',
                  ValidationMessage.required:
                      'The confirmation password must not be empty'
                },
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: const Color(0xFF151624).withOpacity(0.5),
                    ),
                    filled: true,
                    fillColor: passConfController.text.isEmpty
                        ? const Color.fromRGBO(248, 247, 251, 1)
                        : Colors.transparent,
                    helperText: '',
                    helperStyle: TextStyle(height: 0.7),
                    errorStyle: TextStyle(height: 0.7),
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      size: 18,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible2 = !isVisible2;
                          });
                        },
                        icon: isVisible2
                            ? Icon(
                                Icons.visibility,
                                size: 20,
                              )
                            : Icon(
                                Icons.visibility_off,
                                size: 18,
                              ))),
              ),
              SizedBox(
                height: 18,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(size.width * 0.45, size.height / 13),
                          // primary: Color(0xFF21899C),
                          primary: AppColors.mainColor,
                          elevation: 6),
                      icon: Icon(
                        Icons.person_add_alt,
                        size: 24,
                      ),
                      onPressed: () {
                        var valid = form.valid;
                        if (valid && selectedValue.isNotEmpty) {
                          signUp(nameController, selectedValue, emailController,
                              passController, context);
                        } else {
                          print(selectedValue.isNotEmpty);
                          form.markAllAsTouched();
                          setState(() {
                            isError = true;
                          });
                        }
                      },
                      label: Text('Sign Up',
                          style: GoogleFonts.inter(
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
    );
  }

  Widget radioButtonField3() {
    return Theme(
      data: Theme.of(context).copyWith(unselectedWidgetColor: unselectedColor),
      child: Row(
        children: values.map((v) {
          final selected = selectedValue == v;
          final color = selected ? selectedColor : unselectedColor;
          return Expanded(
            child: RadioListTile<String>(
              value: v,
              groupValue: selectedValue,
              onChanged: (value) => setState(() {
                selectedValue = value!;
                isError = false;
              }),
              activeColor: selectedColor,
              title: Text(
                v,
                style: GoogleFonts.inter(
                  fontSize: 16.0,
                  color: color.withOpacity(.8),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future signUp(
      TextEditingController name,
      String gender,
      TextEditingController email,
      TextEditingController password,
      BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String img = 'assets/img/avatar.png';
    if (gender == 'Man') {
      img = 'assets/img/homme.png';
    } else {
      img = 'assets/img/femme.png';
    }
    setState(() {
      loading = true;
    });
    try {
      await auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);

      String uid = auth.currentUser!.uid.toString();

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name.text,
        'gender': gender,
        'email': email.text,
        'password': password.text,
        'image': img,
        'liked-monuments': FieldValue.arrayUnion([])
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => SignIn()));

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SuccessAlert(
              header: 'assets/animations/signup.json',
              title: 'Account created successfully',
              desc: 'You can login now',
            );
          });

      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Signup Failed\n\n',
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
      setState(() {
        loading = false;
      });
    }
  }
}
