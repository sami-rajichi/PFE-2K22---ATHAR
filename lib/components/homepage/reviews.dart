import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/models/monuments.dart';
import 'package:monumento/models/reviews.dart';
import 'package:monumento/network/firebaseServices.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  double rating = 0;
  // List<Map<String, dynamic>> reviews = [
  //   {
  //     'image': 'assets/img/sam.jpg',
  //     'name': 'Sami RAJICHI',
  //     'rating': 5.0,
  //     'review':
  //         'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).'
  //   },
  //   {
  //     'image': 'assets/img/haithem.jpg',
  //     'name': 'Haithem SBOUI',
  //     'rating': 4.5,
  //     'review':
  //         'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).'
  //   }
  // ];
  int activeIndex = 0;
  FirebaseServices firebaseServices = FirebaseServices();
  @override
  Widget build(BuildContext context) {
      CollectionReference firebaseFirestore = FirebaseFirestore.instance.collection('users_reviews');
    return StreamBuilder(
      stream: firebaseFirestore.doc('reviews_data').snapshots(),
      builder: (context, snapshot) {
      if (snapshot.hasData) {
        final d = snapshot.data as DocumentSnapshot;
        final reviews = d['reviews'];
        return Column(
          children: [
            CarouselSlider.builder(
              options: CarouselOptions(
                height: 420,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() => activeIndex = index);
                },
              ),
              itemCount: reviews.length,
              itemBuilder: (context, index, realIndex) {
                final review = reviews[index];
                return buildReviewSection(index, review, reviews);
              },
            ),
          ],
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  Widget buildReviewSection(int index, var review, List<dynamic> reviews) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
            padding: EdgeInsets.only(
              top: 70,
            ),
            margin: EdgeInsets.only(top: 60, bottom: 8, right: 12, left: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(
                  review['name'],
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bigTextColor),
                ),
                SizedBox(
                  height: 8,
                ),
                RatingBarIndicator(
                  rating: double.parse(review['rating'].toString()),
                  itemCount: 5,
                  itemSize: 30,
                  direction: Axis.horizontal,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
                Container(
                  height: 190,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        maxLines: 5,
                        softWrap: true,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: AppColors.bigTextColor,
                        ),
                        child: AnimatedTextKit(animatedTexts: [
                          TypewriterAnimatedText(review['review'],
                              speed: Duration(milliseconds: 15)),
                        ]),
                      ),
                    ),
                  ),
                ),
                buildIndicator(reviews)
              ],
            )),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
              border: Border.all(width: 4, color: Colors.white),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 5))
              ],
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: getImage(review['image']))),
        ),
      ],
    );
  }

  Widget buildIndicator(List<dynamic> r) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: r.length,
        effect: ScrollingDotsEffect(
            dotWidth: 8,
            dotHeight: 8,
            activeDotColor: AppColors.mainColor,
            dotColor: Colors.black26),
      ),
    );
  }

  ImageProvider getImage(String img) {
    if (img == null) {
      return AssetImage('assets/img/avatar.png');
    } else if (img.startsWith('assets/')) {
      return AssetImage(img);
    } else if (img.startsWith('http')) {
      return NetworkImage(img);
    } else {
      return FileImage(File(img));
    }
  }
}
