import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monumento/components/admin_dashboard/admin_homepage.dart';
import 'package:monumento/components/admin_dashboard/admin_navigator.dart';
import 'package:monumento/components/authentication/reset_password.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/home.dart';
import 'package:monumento/network/firebaseServices.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';
import 'package:monumento/shared/components/success_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';

class FormBuild extends StatefulWidget {
  const FormBuild({Key? key}) : super(key: key);

  @override
  State<FormBuild> createState() => _FormBuildState();
}

class _FormBuildState extends State<FormBuild> {
  FormGroup buildForm() => fb.group(<String, Object>{
        'email': FormControl<String>(
          validators: [Validators.required, Validators.email],
        ),
        'password': ['', Validators.required, Validators.minLength(8)],
        'rememberMe': false,
      });
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  FirebaseServices firebaseServices = new FirebaseServices();
  bool isVisible = true;
  bool loading = false;

  @override
  void initState() {
    emailController.addListener(() {
      setState(() {});
    });
    passController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
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
            children: [
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
                autofillHints: [AutofillHints.email],
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
              const SizedBox(height: 16.0),
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
                textInputAction: TextInputAction.done,
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
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResetPassword()));
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.inter(
                        decoration: TextDecoration.underline,
                        fontSize: 13.0,
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
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
                        Icons.login,
                        size: 24,
                      ),
                      onPressed: () {
                        if (form.valid) {
                          signIn(emailController, passController, context);
                        } else {
                          form.markAllAsTouched();
                        }
                      },
                      label: Text('Sign In',
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

  Future signIn(TextEditingController email, TextEditingController password,
      BuildContext context) async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());

      if (email.text.trim() == 'admin-athar@gmail.com'){
        Navigator.pushReplacement(
          context, MaterialPageRoute(
            builder: (_) => AdminNavigator()));
      }
      else {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => NavigationDrawer()));
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SuccessAlert();
          });
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Login Failed\n\n',
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
