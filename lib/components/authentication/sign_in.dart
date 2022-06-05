import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monumento/components/authentication/sign_in_form.dart';
import 'package:monumento/components/authentication/sign_up.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';
import 'package:monumento/shared/components/success_alert.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: const Color(0xFF21899C),
        backgroundColor: AppColors.mainColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: ListView(
            children: [
              SizedBox(
                height: size.height,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    //bg design, we use 3 svg img
                    Positioned(
                      left: -26,
                      top: 51.0,
                      child: SvgPicture.string(
                        '<svg viewBox="-26.0 51.0 91.92 91.92" ><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -26.0, 96.96)" d="M 48.75 0 L 65 32.5 L 48.75 65 L 16.24999809265137 65 L 0 32.5 L 16.25000381469727 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -10.83, 105.24)" d="M 0 0 L 27.625 11.05000019073486 L 55.25 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, 16.51, 93.51)" d="M 0 37.04999923706055 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                        width: 91.92,
                        height: 91.92,
                      ),
                    ),
                    Positioned(
                      right: 43.0,
                      top: -103,
                      child: SvgPicture.string(
                        '<svg viewBox="63.0 -103.0 268.27 268.27" ><path transform="matrix(0.5, -0.866025, 0.866025, 0.5, 63.0, 67.08)" d="M 147.2896423339844 0 L 196.3861999511719 98.19309997558594 L 147.2896423339844 196.3861999511719 L 49.09654235839844 196.3861999511719 L 0 98.19309234619141 L 49.09656143188477 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.5, -0.866025, 0.866025, 0.5, 113.73, 79.36)" d="M 0 0 L 83.46413421630859 33.38565444946289 L 166.9282684326172 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.5, -0.866025, 0.866025, 0.5, 184.38, 23.77)" d="M 0 111.9401321411133 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                        width: 268.27,
                        height: 268.27,
                      ),
                    ),
                    Positioned(
                      right: -19,
                      top: 31.0,
                      child: SvgPicture.string(
                        '<svg viewBox="329.0 31.0 65.0 65.0" ><path transform="translate(329.0, 31.0)" d="M 48.75 0 L 65 32.5 L 48.75 65 L 16.24999809265137 65 L 0 32.5 L 16.25000381469727 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(333.88, 47.58)" d="M 0 0 L 27.625 11.05000019073486 L 55.25 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(361.5, 58.63)" d="M 0 37.04999923706055 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                        width: 65.0,
                        height: 65.0,
                      ),
                    ),

                    //card and footer ui
                    Positioned(
                      bottom: 20.0,
                      child: Column(
                        children: <Widget>[
                          buildCard(size),
                          buildFooter(size),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.9,
      height: size.height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
      ),
      child: loading
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                richText(24),
                SizedBox(
                  height: size.height * 0.05,
                ),
                FormBuild(),
              ],
            ),
    );
  }

  Widget buildFooter(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: size.height * 0.04,
        ),
        SizedBox(
          width: size.width * 0.6,
          height: 44.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  signInWithFacebook(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white,
                  ),
                  child: SvgPicture.string(
                    '<svg viewBox="0.3 0.27 22.44 22.44" ><defs><linearGradient id="gradient" x1="0.500031" y1="0.970054" x2="0.500031" y2="0.0"><stop offset="0.0" stop-color="#ff0062e0"  /><stop offset="1.0" stop-color="#ff19afff"  /></linearGradient></defs><path transform="translate(0.3, 0.27)" d="M 9.369577407836914 22.32988739013672 C 4.039577960968018 21.3760986328125 0 16.77546882629395 0 11.22104930877686 C 0 5.049472332000732 5.049472808837891 0 11.22105026245117 0 C 17.39262962341309 0 22.44210624694824 5.049472332000732 22.44210624694824 11.22104930877686 C 22.44210624694824 16.77546882629395 18.40252304077148 21.3760986328125 13.07252502441406 22.32988739013672 L 12.45536518096924 21.8249397277832 L 9.986735343933105 21.8249397277832 L 9.369577407836914 22.32988739013672 Z" fill="url(#gradient)" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(6.93, 4.65)" d="M 8.976840972900391 9.986734390258789 L 9.481786727905273 6.844839572906494 L 6.508208274841309 6.844839572906494 L 6.508208274841309 4.656734466552734 C 6.508208274841309 3.759051322937012 6.844841003417969 3.085787773132324 8.191367149353027 3.085787773132324 L 9.650103569030762 3.085787773132324 L 9.650103569030762 0.2244201600551605 C 8.864629745483398 0.1122027561068535 7.966946125030518 0 7.181471347808838 0 C 4.600629806518555 0 2.805262804031372 1.570946097373962 2.805262804031372 4.376209735870361 L 2.805262804031372 6.844839572906494 L 0 6.844839572906494 L 0 9.986734390258789 L 2.805262804031372 9.986734390258789 L 2.805262804031372 17.8975715637207 C 3.422420024871826 18.00978851318359 4.039577484130859 18.06587600708008 4.656735897064209 18.06587600708008 C 5.273893356323242 18.06587600708008 5.89105224609375 18.009765625 6.508208274841309 17.8975715637207 L 6.508208274841309 9.986734390258789 L 8.976840972900391 9.986734390258789 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 22.44,
                    height: 22.44,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {
                  signInWithGoogle(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white,
                  ),
                  child: SvgPicture.string(
                    // Group 59
                    '<svg viewBox="11.0 11.0 22.92 22.92" ><path transform="translate(11.0, 11.0)" d="M 22.6936149597168 9.214142799377441 L 21.77065277099609 9.214142799377441 L 21.77065277099609 9.166590690612793 L 11.45823860168457 9.166590690612793 L 11.45823860168457 13.74988651275635 L 17.93386268615723 13.74988651275635 C 16.98913192749023 16.41793632507324 14.45055770874023 18.33318138122559 11.45823860168457 18.33318138122559 C 7.661551475524902 18.33318138122559 4.583295345306396 15.25492572784424 4.583295345306396 11.45823860168457 C 4.583295345306396 7.661551475524902 7.661551475524902 4.583295345306396 11.45823860168457 4.583295345306396 C 13.21077632904053 4.583295345306396 14.80519008636475 5.244435787200928 16.01918983459473 6.324374675750732 L 19.26015281677246 3.083411931991577 C 17.21371269226074 1.176188230514526 14.47633838653564 0 11.45823860168457 0 C 5.130426406860352 0 0 5.130426406860352 0 11.45823860168457 C 0 17.78605079650879 5.130426406860352 22.91647720336914 11.45823860168457 22.91647720336914 C 17.78605079650879 22.91647720336914 22.91647720336914 17.78605079650879 22.91647720336914 11.45823860168457 C 22.91647720336914 10.68996334075928 22.83741569519043 9.940022468566895 22.6936149597168 9.214142799377441 Z" fill="#ffc107" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(12.32, 11.0)" d="M 0 6.125000953674316 L 3.764603137969971 8.885863304138184 C 4.78324031829834 6.363905429840088 7.250198841094971 4.583294868469238 10.13710117340088 4.583294868469238 C 11.88963890075684 4.583294868469238 13.48405265808105 5.244434833526611 14.69805240631104 6.324373722076416 L 17.93901443481445 3.083411693572998 C 15.89257335662842 1.176188111305237 13.15520095825195 0 10.13710117340088 0 C 5.735992908477783 0 1.919254422187805 2.484718799591064 0 6.125000953674316 Z" fill="#ff3d00" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(12.26, 24.78)" d="M 10.20069408416748 9.135653495788574 C 13.16035556793213 9.135653495788574 15.8496036529541 8.003005981445312 17.88286781311035 6.161093711853027 L 14.33654403686523 3.160181760787964 C 13.14749050140381 4.064460277557373 11.69453620910645 4.553541660308838 10.20069408416748 4.55235767364502 C 7.220407009124756 4.55235767364502 4.689855575561523 2.6520094871521 3.736530303955078 0 L 0 2.878881216049194 C 1.896337866783142 6.589632034301758 5.747450828552246 9.135653495788574 10.20069408416748 9.135653495788574 Z" fill="#4caf50" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(22.46, 20.17)" d="M 11.23537635803223 0.04755179211497307 L 10.31241607666016 0.04755179211497307 L 10.31241607666016 0 L 0 0 L 0 4.583295345306396 L 6.475625038146973 4.583295345306396 C 6.023715496063232 5.853105068206787 5.209692478179932 6.962699413299561 4.134132385253906 7.774986743927002 L 4.135851383209229 7.773841857910156 L 7.682177066802979 10.77475357055664 C 7.431241512298584 11.00277233123779 11.45823955535889 8.020766258239746 11.45823955535889 2.291647672653198 C 11.45823955535889 1.523372769355774 11.37917804718018 0.773431122303009 11.23537635803223 0.04755179211497307 Z" fill="#1976d2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 22.92,
                    height: 22.92,
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NavigationDrawer()));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.home_filled,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Text.rich(
          TextSpan(
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: Colors.white,
            ),
            children: [
              const TextSpan(
                text: 'Don’t have an account? ',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                  text: 'Sign Up here',
                  style: const TextStyle(
                    color: Color(0xFFFE9879),
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => SignUp()))),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: const Color(0xFF21899C),
          letterSpacing: 2.000000061035156,
        ),
        children: [
          TextSpan(
            text: 'LOGIN',
            style: TextStyle(
                fontWeight: FontWeight.w800, color: AppColors.mainColor),
          ),
          const TextSpan(
            text: 'PAGE',
            style: TextStyle(
              color: Color(0xFFFE9879),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Future signInWithGoogle(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      setState(() {
        loading = true;
      });
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        setState(() {
          loading = false;
        });
        User user = userCredential.user!;
        if (userCredential.additionalUserInfo!.isNewUser) {
          if (user != null) {
            GoogleSignIn().disconnect();
            user.delete();
            _auth.signOut();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => SignUp()));

            final snackBar = SnackBar(
              content: RichText(
                  text: TextSpan(children: [
                const TextSpan(
                    text: 'Account Doesn\'t Exist\n\n',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                TextSpan(
                    text: 'Go ahead and sign up please',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white)),
              ])),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => NavigationDrawer()));

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SuccessAlert();
              });
        }
      }
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
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      setState(() {
        loading = true;
      });
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      UserCredential userCredential =
          await _auth.signInWithCredential(facebookAuthCredential);
      setState(() {
        loading = false;
      });
      User user = userCredential.user!;
      if (userCredential.additionalUserInfo!.isNewUser) {
        await FacebookAuth.instance.logOut();
        user.delete();
        _auth.signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => SignUp()));

        final snackBar = SnackBar(
          content: RichText(
              text: TextSpan(children: [
            const TextSpan(
                text: 'Account Doesn\'t Exist\n\n',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            TextSpan(
                text: 'Go ahead and sign up please',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)),
          ])),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => NavigationDrawer()));

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SuccessAlert();
            });
      }
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
    }
  }
}
