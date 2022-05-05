import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailField extends StatefulWidget {
  final Size size;
  final TextEditingController emailController;
  final FocusNode fn;

  const EmailField(
      {Key? key, required this.size, 
      required this.emailController, required this.fn})
      : super(key: key);

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {

  @override
  void initState() {
    super.initState();
    widget.emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    widget.emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: widget.size.height / 10,
        child: TextFormField(
          controller: widget.emailController,
          autofocus: true,
          onFieldSubmitted: (value){
            FocusScope.of(context).requestFocus(widget.fn);
          },
          textInputAction: TextInputAction.next,
            validator: (value) {
              if (value!.isEmpty){
                return 'Email is required';
              }
              else if (validate(value)) {
                return null;
              } else {
                return 'Enter a valid email';
              }
            },
          style: GoogleFonts.inter(
            fontSize: 18.0,
            color: const Color(0xFF151624),
          ),
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          cursorColor: const Color(0xFF151624),
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: widget.emailController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.emailController.text.isEmpty
                        ? Colors.transparent
                        : const Color(0xFF21899C),
                  )),
            focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.emailController.text.isEmpty
                    ? const Color(0xFF151624).withOpacity(0.5)
                    : validate(widget.emailController.text)
                    ? const Color(0xFF21899C)
                    : Color.fromARGB(255, 221, 26, 0),
                  )),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 221, 26, 0),
                    )
                  ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: widget.emailController.text.isEmpty
                    ? const Color(0xFF151624).withOpacity(0.5)
                    : validate(widget.emailController.text)
                    ? const Color(0xFF21899C)
                    : Color.fromARGB(255, 221, 26, 0),
                    size: 18,
              ),
            suffix: widget.emailController.text.isEmpty 
              ? SizedBox() 
              : validate(widget.emailController.text) 
              ? IconButton(
                onPressed: (){widget.emailController.clear();}, 
                icon: Icon(Icons.close, color: Color(0xFF21899C),))
              : IconButton(
                onPressed: (){widget.emailController.clear();}, 
                icon: Icon(Icons.close, size: 18, 
                color: Color.fromARGB(255, 221, 26, 0),))
              
          ),
        ),
      ),
    );
  }

  bool validate(String email) {
    if (email != null && !EmailValidator.validate(email)) {
      return false;
    }
    return true;
  }
}
