import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monumento/home.dart';

class SignInButton extends StatefulWidget {

  final Size size;
  final GlobalKey<FormState> formKey;
  const SignInButton({ 
    Key? key, 
    required this.size, 
    required this.formKey }) : super(key: key);

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final isValidForm = widget.formKey.currentState!.validate();
        if(isValidForm){
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Home(),), (route) => false);
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: widget.size.height / 13,
        width: widget.size.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: const Color(0xFF21899C),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C2E84).withOpacity(0.2),
              offset: const Offset(0, 15.0),
              blurRadius: 60.0,
            ),
          ],
        ),
        child: Text(
          'Sign in',
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}