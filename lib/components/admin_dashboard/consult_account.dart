import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monumento/components/admin_dashboard/manage_accounts.dart';
import 'package:monumento/constants/colors.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ConsultAccount extends StatefulWidget {
  final String image;
  final String name;
  final String gender;
  final String email;
  final String pass;
  const ConsultAccount(
      {Key? key,
      required this.image,
      required this.name,
      required this.gender,
      required this.email,
      required this.pass})
      : super(key: key);

  @override
  State<ConsultAccount> createState() => _ConsultAccountState();
}

class _ConsultAccountState extends State<ConsultAccount> {
  FormGroup buildForm() => fb.group(<String, Object>{
        'name': FormControl<String>(validators: [
          Validators.minLength(2),
          Validators.pattern(r"^[a-zA-Z ,.'-]+$")
        ]),
        'email': FormControl<String>(
          validators: [Validators.minLength(10), Validators.email],
        ),
        'password': FormControl<String>(
          validators: [Validators.minLength(8)],
        ),
        'passwordConfirmation': FormControl<String>(
          validators: [Validators.minLength(8)],
        ),
      }, [
        Validators.mustMatch('password', 'passwordConfirmation')
      ]);
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passConfController = TextEditingController();
  bool showPassword = false;
  bool showPassword2 = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      emailController.text = widget.email;
      nameController.text = widget.name;
      passController.text = widget.pass;
      passConfController.text = widget.pass;
    });
    nameController.addListener(() {
      setState(() {});
    });
    emailController.addListener(() {
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
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: AppColors.bigTextColor,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ManageAccounts()));
          },
        ),
        title: Text(
          '${widget.name} Account',
          style: TextStyle(color: AppColors.bigTextColor),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, top: 30, right: 20),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 4, color: AppColors.backgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover, image: getImage())),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 45,
            ),
            ReactiveFormBuilder(
              form: buildForm,
              builder: (context, form, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textFormField(nameController, 'name', TextInputType.name,
                        'Name', false, false),
                    textFormField(emailController, 'email',
                        TextInputType.emailAddress, 'Email', false, false),
                    textFormField(passController, 'password',
                        TextInputType.visiblePassword, 'Password', true, false),
                    textFormField(
                      passConfController,
                      'passwordConfirmation',
                      TextInputType.visiblePassword,
                      'Password Confirmation',
                      false,
                      true,
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  Widget textFormField(
    TextEditingController controller,
    String name,
    TextInputType inputType,
    String labelText,
    bool isPasswordTextField,
    bool isConfPasswordTextField,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 46.0),
      child: ReactiveTextField<String>(
        readOnly: true,
        controller: controller,
        obscureText: isPasswordTextField
            ? !showPassword
            : isConfPasswordTextField
                ? !showPassword2
                : false,
        formControlName: name,
        style: TextStyle(fontSize: 20),
        validationMessages: (control) {
          if (name == 'email') {
            return {
              ValidationMessage.minLength: 'The email must not be empty',
              ValidationMessage.email: 'The email value must be a valid email',
            };
          } else if (name == 'password') {
            return {
              ValidationMessage.minLength:
                  'The password must be at least 8 characters',
            };
          } else if (name == 'passwordConfirmation') {
            return {
              ValidationMessage.mustMatch: 'Password Confirmation must match',
            };
          } else {
            return {
              ValidationMessage.minLength: 'The name must not be empty',
              ValidationMessage.pattern: 'The name value must be a valid name',
            };
          }
        },
        keyboardType: inputType,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? !showPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    )
              : isConfPasswordTextField
                  ? !showPassword2
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword2 = !showPassword2;
                            });
                          },
                          icon: Icon(
                            Icons.visibility,
                            color: Colors.grey,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              showPassword2 = !showPassword2;
                            });
                          },
                          icon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        )
                  : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  ImageProvider getImage() {
    if (widget.image == null) {
      return AssetImage('assets/img/avatar.png');
    } else if (widget.image.startsWith('assets/')) {
      return AssetImage(widget.image);
    } else if (widget.image.startsWith('http')) {
      return NetworkImage(widget.image);
    } else {
      return FileImage(File(widget.image));
    }
  }
}
