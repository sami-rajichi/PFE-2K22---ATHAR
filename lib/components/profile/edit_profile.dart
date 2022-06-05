import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:monumento/components/admin_dashboard/admin_navigator.dart';
import 'package:monumento/components/profile/profile_screen.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/update_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shimmer/shimmer.dart';

class EditProfile extends StatefulWidget {
  final String image;
  final String name;
  final String gender;
  final String email;
  final String pass;
  const EditProfile(
      {Key? key,
      required this.image,
      required this.name,
      required this.gender,
      required this.email,
      required this.pass})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
  static const genders = <String>['Man', 'Woman'];
  String selectedValue = genders.first;
  File? imgPicked;
  String? imgPath;
  String? emailBU;
  String? nameBU;
  String? passBU;
  String? imgBU;
  bool loading = false;
  bool fromCloud = false;
  bool saved = true;
  late NavigatorState navigatorState;

  final cloudinary =
      CloudinaryPublic('monumento', 'user-profile-images', cache: false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      emailController.text = widget.email;
      nameController.text = widget.name;
      passController.text = widget.pass;
      passConfController.text = widget.pass;
      imgPath = widget.image;
      emailBU = widget.email;
      nameBU = widget.name;
      passBU = widget.pass;
      imgBU = widget.image;
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
    navigatorState = Navigator.of(context);
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
            if (fromCloud == true) {
              final snackBar = SnackBar(
                content: RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: 'Image Still Loading\n\n',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  TextSpan(
                      text: 'Wait till the image ends loading',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white)),
                ])),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 2),
                // shape: StadiumBorder(),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              if (findUpdates() == true) {
                setState(() {
                  saved = false;
                });
              } else {
                setState(() {
                  saved = true;
                });
              }
              if (saved) {
                FirebaseAuth.instance.currentUser != null &&
                        FirebaseAuth.instance.currentUser!.email ==
                            'admin-athar@gmail.com'
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminNavigator()))
                    : Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                            image: imgPath!,
                            name: nameBU!,
                            gender: widget.gender,
                            email: emailBU!,
                            pass: passBU!)));
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return saveAlert();
                    });
              }
            }
          },
        ),
        title: Text(
          'Edit Profile',
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
                  InkWell(
                    onTap: pickImage,
                    borderRadius: BorderRadius.circular(80),
                    child: fromCloud
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[400]!,
                            highlightColor: Colors.grey[200]!,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 4, color: AppColors.backgroundColor),
                              ),
                            ),
                          )
                        : Container(
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
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 4, color: AppColors.backgroundColor),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: AppColors.backgroundColor,
                        ),
                      ))
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
                    ),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                primary: Colors.grey[500],
                                backgroundColor: AppColors.mainColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 45, vertical: 18),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                              onPressed: () {
                                if (fromCloud == true) {
                                  final snackBar = SnackBar(
                                    content: RichText(
                                        text: TextSpan(children: [
                                      const TextSpan(
                                          text: 'Image Still Loading\n\n',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      TextSpan(
                                          text:
                                              'Wait till the image ends loading',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white)),
                                    ])),
                                    backgroundColor: Colors.redAccent,
                                    duration: Duration(seconds: 2),
                                    // shape: StadiumBorder(),
                                    behavior: SnackBarBehavior.floating,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  if (form.valid) {
                                    update(nameController, emailController,
                                        passController, context);
                                  } else {
                                    form.markAllAsTouched();
                                  }
                                }
                              },
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 2.2,
                                    color: Colors.white),
                              ),
                            ),
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

  Future uploadFile(String name, String filePath) async {
    final path = 'user-profile-images/$name';
    final file = File(filePath);

    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadedTask = ref.putFile(file);

    final snapshot = await uploadedTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }

  Future uploadFile2(String name, String filePath) async {
    CloudinaryResponse? response;
    try {
      response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(filePath,
            resourceType: CloudinaryResourceType.Image,
            folder: 'user-profile-images/'),
      );
    } on CloudinaryException catch (e) {
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Update Failed\n\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          TextSpan(
              text: e.message,
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
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 90),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return response!.secureUrl;
  }

  Future pickImage() async {
    try {
      final source = await showImageSource(context);
      final image =
          await ImagePicker().pickImage(source: source!, imageQuality: 15);
      if (image == null) return widget.image;

      final tempImg = File(image.path);
      setState(() {
        fromCloud = true;
      });
      final urlDownload = await uploadFile2(image.name, image.path);

      setState(() {
        imgPicked = tempImg;
        imgPath = urlDownload;
        fromCloud = false;
      });
    } on PlatformException catch (e) {
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Failed to pick image\n\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          TextSpan(
              text: 'Try again',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
        ])),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
        // shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () =>
                        Navigator.of(context).pop(ImageSource.camera),
                    child: Text('Camera')),
                CupertinoActionSheetAction(
                    onPressed: () =>
                        Navigator.of(context).pop(ImageSource.gallery),
                    child: Text('Gallery')),
              ],
            );
          });
    } else {
      return showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                  title: Text('Camera'),
                  leading: Icon(Icons.camera_alt),
                ),
                ListTile(
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                  title: Text('Gallery'),
                  leading: Icon(Icons.image),
                ),
              ],
            );
          });
    }
  }

  ImageProvider getImage() {
    if (imgPath == null) {
      return AssetImage('assets/img/avatar.png');
    } else if (imgPath!.startsWith('assets/')) {
      return AssetImage(imgPath!);
    } else if (imgPath!.startsWith('http')) {
      return NetworkImage(imgPath!);
    } else {
      return FileImage(File(imgPath!));
    }
  }

  Future update(TextEditingController name, TextEditingController email,
      TextEditingController password, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    setState(() {
      loading = true;
    });
    try {
      String uid = auth.currentUser!.uid.toString();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name.text,
        'email': email.text,
        'password': password.text,
        'image': imgPath,
      });

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return UpdatedAlert(
              header: 'assets/animations/done.json',
              title: 'Account updated successfully',
              desc: 'Enjoy the experience',
              image: imgPath!,
              name: widget.name,
              gender: widget.gender,
              email: widget.email,
              pass: widget.pass,
            );
          });

      setState(() {
        loading = false;
        nameBU = name.text;
        emailBU = email.text;
        passBU = password.text;
        imgBU = imgPath;
        saved = true;
      });
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Update Failed\n\n',
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
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 90),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        loading = false;
      });
    }
  }

  bool findUpdates() {
    if (emailBU == emailController.text &&
        nameBU == nameController.text &&
        passBU == passController.text &&
        imgPath! == imgBU) {
      return false;
    }
    return true;
  }

  cancel() {
    emailController.text = widget.email;
    nameController.text = widget.name;
    passController.text = widget.pass;
    passConfController.text = widget.pass;
    Navigator.of(context).pop();
  }

  Widget saveAlert() {
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
                      'Unsaved Changes',
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
                      'Don\'t forget to save changes',
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
                              cancel();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'DISCARD',
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2.2,
                                  color: Colors.black87),
                            )),
                        loading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
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
                                  update(nameController, emailController,
                                      passController, context);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "SAVE",
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
