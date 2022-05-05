import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/concaveCard.dart';
import 'package:monumento/shared/components/description.dart';
import 'package:monumento/shared/components/neumorphic_image.dart';
import 'package:monumento/shared/components/neumorphism.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CategoryPage extends StatefulWidget {
  final String? name;
  final String? info;
  final String? subtitle1;
  final String? subtitle2;
  final String? subtitle3;
  final String? subtitle1Value;
  final String? subtitle2Value;
  final String? subtitle3Value;
  final String? location;
  final String? image;
  final String? region;
  final String? country;
  final Color? color;
  final Color? backgroundColor;
  final String? url;

  CategoryPage({
    Key? key, 
    this.name, 
    this.location, 
    this.image, 
    this.region, 
    this.country, 
    this.subtitle1, this.subtitle2, this.subtitle3,
    this.color = grey400, 
    this.backgroundColor = grey400,
    this.url, 
    this.subtitle1Value, 
    this.subtitle2Value, this.subtitle3Value, 
    this.info
    }) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.name!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lobster(
                      fontSize: 25,
                      color: AppColors.bigTextColor
                    )),
                SizedBox(
                  height: 25,
                ),
                Flexible(
                  child: neumorphicImage(
                      color: Colors.grey[400],
                      image: Image(
                        image: AssetImage(widget.image!),
                        fit: BoxFit.fill,
                        height: 250,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: neumorphicCard(
                        color: widget.color,
                        child: description(
                            subtitle: 'Location: ', 
                            text: widget.location!,
                        )
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    neumorphicButton(
                      prColor: widget.color,
                      sdColor: widget.color,
                      depth: 15,
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.pink,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                neumorphicCard(
                    color: widget.color,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        description(
                            subtitle: widget.subtitle1! + ': ',
                            text: widget.subtitle1Value!),
                        SizedBox(
                          height: 5,
                        ),
                        description(
                            subtitle: widget.subtitle2! + ': ',
                            text: widget.subtitle2Value!),
                        SizedBox(
                          height: 5,
                        ),
                        description(
                            subtitle: widget.subtitle3! + ': ',
                            text: widget.subtitle3Value!),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 600,
                          child: description(
                            text: widget.info!,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            neumorphicButton(
                        
                                prColor: Color.fromRGBO(189, 189, 189, 1).withOpacity(0.6),
                                sdColor: widget.color,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(6)),
                                child: GestureDetector(
                                  onTap: (() => popUpWebView(context)),
                                  child: Text(
                                    'Read more',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )),
                            neumorphicButton(
                                prColor: Color.fromRGBO(189, 189, 189, 1).withOpacity(0.6),
                                sdColor: widget.color,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(6)),
                                child: Text(
                                    'Show In Map',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                          ],
                        )
                      ],
                    )),
                    SizedBox(
                      height: 39,
                    )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  popUpWebView(BuildContext context) => showDialog(
    context: context, 
    builder: (_) => AlertDialog(
      content: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.url,
        // onWebViewCreated: (wvc){
        //   _controller.complete(wvc);
        // },
      ),
    ));
}
