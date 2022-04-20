import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/constants/monuments_description.dart';
import 'package:monumento/shared/components/concaveCard.dart';
import 'package:monumento/shared/components/description.dart';
import 'package:monumento/shared/components/neumorphic_image.dart';
import 'package:monumento/shared/components/neumorphism.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CategoryPage extends StatefulWidget {
  final String? title;
  final String? subtitle1;
  final String? subtitle2;
  final String? subtitle3;
  final String? location;
  final String? image;
  final String? region;
  final String? country;
  final Color? color;
  final Color? backgroundColor;
  final String? url;

  CategoryPage({
    Key? key, 
    this.title, 
    this.location, 
    this.image, 
    this.region, 
    this.country, 
    this.subtitle1, this.subtitle2, this.subtitle3,
    this.color = grey300, this.backgroundColor = grey400,
    this.url
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
                Text(widget.title!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lobster(
                      fontSize: 25,
                    )),
                SizedBox(
                  height: 25,
                ),
                Flexible(
                  child: neumorphicImage(
                      color: widget.color,
                      image: Image(
                        image: AssetImage(widget.image!),
                        fit: BoxFit.fill,
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
                            text: descriptions[widget.region][widget.country][1]),
                        SizedBox(
                          height: 5,
                        ),
                        description(
                            subtitle: widget.subtitle2! + ': ',
                            text: descriptions[widget.region][widget.country][2]),
                        SizedBox(
                          height: 5,
                        ),
                        description(
                            subtitle: widget.subtitle3! + ': ',
                            text: descriptions[widget.region][widget.country][3]),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 600,
                          child: description(
                            text: descriptions[widget.region][widget.country][0],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            neumorphicButton(
                        
                                prColor: widget.color,
                                sdColor: widget.color,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(8)),
                                child: GestureDetector(
                                  onTap: (() => popUpWebView(context)),
                                  child: Text(
                                    'Read more',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )),
                            neumorphicButton(
                                prColor: widget.color,
                                sdColor: widget.color,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(8)),
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
      backgroundColor: widget.backgroundColor,
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
