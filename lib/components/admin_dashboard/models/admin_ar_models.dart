import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:monumento/components/admin_dashboard/models/manage_models.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/not_logged_in.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AdminARModels extends StatefulWidget {
  final String? monumentName;
  final String? models;
  const AdminARModels({Key? key, required this.monumentName, required this.models})
      : super(key: key);

  @override
  State<AdminARModels> createState() => _AdminARModelsState();
}

class _AdminARModelsState extends State<AdminARModels> {
  int activeIndex = 0;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (widget.models!.isEmpty){
      return noModelsYet();
    } else {
      return model(widget.models!);
    }
  }

  Widget model(String models) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: BackButton(
          color: AppColors.bigTextColor,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ManageModels())
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         
          Align(
            alignment: Alignment.topCenter,
            child: Text(widget.monumentName!,
                textAlign: TextAlign.center,
                style: GoogleFonts.lobster(
                    fontSize: 25, color: AppColors.bigTextColor)),
          ),
           SizedBox(
            height: 50,
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.79,
            child: modelViewer(widget.models!)),
          
        ],
      ),
    );
  }

  Widget modelViewer(String m) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ModelViewer(
        src: m,
        ar: true,
        autoRotate: true,
        cameraControls: true,
      ),
    );
  }

  Widget noModelsYet() {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: BackButton(
            color: AppColors.bigTextColor,
            onPressed: (() => Navigator.of(context).pop())),
        title: Text(
          '${widget.monumentName}\'s Models',
          style: TextStyle(color: AppColors.bigTextColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Lottie.asset('assets/animations/3dModel.json',
                  height: size.height * 0.4, repeat: true),
              SizedBox(
                height: 20,
              ),
              Text(
                'Sorry.. ${widget.monumentName} is not supported yet, we are working on it.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
