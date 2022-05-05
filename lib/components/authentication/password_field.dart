import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordField extends StatefulWidget {
  final Size size;
  final TextEditingController passController;
  final FocusNode fn;

  const PasswordField(
      {Key? key, required this.size, 
      required this.passController, required this.fn})
      : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.passController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0,),
      child: Container(
        height: widget.size.height / 10,
        child: TextFormField(
            controller: widget.passController,
            focusNode: widget.fn,
            validator: (value) {
              if (value!.isEmpty){
                return 'Password is required';
              }
              if (validate(value)) {
                return null;
              } else {
                return 'Enter a valid password :eEnter min. 8 characters';
              }
            },
            textInputAction: TextInputAction.done,
            style: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624),
            ),
            cursorColor: const Color(0xFF151624),
            obscureText: !isVisible,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: GoogleFonts.inter(
                fontSize: 16.0,
                color: const Color(0xFF151624).withOpacity(0.5)
              ),
              filled: true,
              fillColor: widget.passController.text.isEmpty
                  ? const Color.fromRGBO(248, 247, 251, 1)
                  : Colors.transparent,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.passController.text.isEmpty
                        ? Colors.transparent
                        : const Color(0xFF21899C),
                  )),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.passController.text.isEmpty
                    ? const Color(0xFF151624).withOpacity(0.5)
                    : validate(widget.passController.text)
                    ? const Color(0xFF21899C)
                    : Color.fromARGB(255, 221, 26, 0),
                  )),
              
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: widget.passController.text.isEmpty
                    ? const Color(0xFF151624).withOpacity(0.5)
                    : validate(widget.passController.text)
                    ? const Color(0xFF21899C)
                    : Color.fromARGB(255, 221, 26, 0),
                    size: 18,
              ),
              suffix: widget.passController.text.isEmpty 
              ? Icon(Icons.visibility_off, size: 18, color: Color(0xFF151624).withOpacity(0.5),) 
              : validate(widget.passController.text) 
              ? IconButton(
                onPressed: (){setState(() {
                  isVisible = !isVisible;
                });}, 
                icon: isVisible
                ? Icon(Icons.visibility, size: 18, color: Color(0xFF21899C),)
                : Icon(Icons.visibility_off, size: 18, color: Color(0xFF21899C),))
              : IconButton(
                onPressed: (){setState(() {
                  isVisible = !isVisible;
                });}, 
                icon: isVisible
                ? Icon(Icons.visibility, size: 18, color: Color.fromARGB(255, 221, 26, 0),)
                : Icon(Icons.visibility_off, size: 18, color: Color.fromARGB(255, 221, 26, 0),))
              
          ),
          ),
      ),
      );
  }

  bool validate(String value) {
    if (value != null && value.length < 8) {
      return false;
    }
    return true;
  }
}
