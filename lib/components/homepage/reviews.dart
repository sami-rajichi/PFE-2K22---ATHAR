import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monumento/constants/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Reviews extends StatefulWidget {
  const Reviews({Key? key}) : super(key: key);

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  double rating = 0;
  List<Map<String, dynamic>> reviews = [
    {
      'image': 'assets/img/sam.jpg',
      'name': 'Sami RAJICHI',
      'rating': 5.0,
      'review':
          'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).'
    },
    {
      'image': 'assets/img/haithem.jpg',
      'name': 'Haithem SBOUI',
      'rating': 4.5,
      'review':
          'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).'
    }
  ];
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
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
            return buildReviewSection(index);
          },
        ),
      ],
    );
  }

  Widget buildReviewSection(int index) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
            padding: EdgeInsets.only(top: 50,),
            margin: EdgeInsets.only(top: 50, bottom: 12, right: 12, left: 12),
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
                  reviews[index]['name'],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bigTextColor),
                ),
                SizedBox(
                  height: 8,
                ),
                RatingBarIndicator(
                  rating: reviews[index]['rating'],
                  itemCount: 5,
                  itemSize: 40,
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
                    child: Center(
                      child: DefaultTextStyle(
                        maxLines: 5,
                        softWrap: true,
                        style: GoogleFonts.vollkorn(
                            fontSize: 22, color: AppColors.bigTextColor),
                        child: AnimatedTextKit(
                          animatedTexts: [
                          TypewriterAnimatedText(
                            reviews[index]['review'],
                            speed: Duration(milliseconds: 15)
                          ),
                        ])
                        ,
                      ),
                    ),
                  ),
                ),
                buildIndicator()
              ],
            )),
        ClipOval(
          child: CircleAvatar(
            radius: 50,
            child: Image.asset(
              reviews[index]['image'],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: reviews.length,
        effect: ScrollingDotsEffect(
            dotWidth: 12,
            dotHeight: 12,
            activeDotColor: AppColors.mainColor,
            dotColor: Colors.black26),
      ),
    );
  }
}
