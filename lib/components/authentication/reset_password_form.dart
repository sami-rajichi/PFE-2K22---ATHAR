import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monumento/components/authentication/sign_in.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/success_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  FormGroup buildForm() => fb.group(<String, Object>{
        'email': FormControl<String>(
          validators: [Validators.required, Validators.email],
        ),
      });
  TextEditingController emailController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    emailController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
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
              const SizedBox(height: 40.0),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(size.width * 0.45, size.height / 13),
                          primary: AppColors.mainColor,
                          elevation: 6),
                      icon: Icon(
                        Icons.lock_reset,
                        size: 24,
                      ),
                      onPressed: () {
                        if (form.valid) {
                          resetPass(
                            emailController, 
                            context);
                        } else {
                          form.markAllAsTouched();
                        }
                      },
                      label: Text('Reset Password',
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

  Future resetPass(TextEditingController email, BuildContext context) async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim());

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => SignIn()));

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SuccessAlert(
              header: 'assets/animations/email.json',
              title: 'Email Sent Successfully',
              desc: 'Check email to reset password',
            );
          });
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Reset Password Failed\n\n',
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
          const TextSpan(
            text: '\n\nTry Again',
            style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)
          )
        ])),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 5),
        // shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        loading = false;
      });
      Navigator.of(context).pop();
    }
  }
}
