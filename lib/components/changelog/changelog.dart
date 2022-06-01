import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ChangeLogScreen extends StatefulWidget {
  const ChangeLogScreen({Key? key}) : super(key: key);

  @override
  State<ChangeLogScreen> createState() => _ChangeLogScreenState();
}

class _ChangeLogScreenState extends State<ChangeLogScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference firebaseFirestore =
        FirebaseFirestore.instance.collection('changelog');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: MenuWidget(
          color: AppColors.bigTextColor,
        ),
        title: Text(
          'Changelog',
          style: TextStyle(color: AppColors.bigTextColor),
        ),
      ),
      body: StreamBuilder(
          stream: firebaseFirestore.doc('changelogs').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final d = snapshot.data as DocumentSnapshot;
              List changelogs2 = d['changelogs'];
              List changelogs = List.from(changelogs2.reversed);
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: changelogs.length,
                  itemBuilder: (context, index) {
                    bool isFirst = index == 0 ? true : false;
                    bool isLast = index == changelogs.length-1 ? true : false;
                    return _buildTimelineTile(
                      changelogs[index]['date'], 
                      changelogs[index]['commit'], 
                      const _IconIndicator(
                        iconData: Icons.update,
                        size: 20,
                      ),
                      isFirst: isFirst,
                      isLast: isLast
                    );
                  }
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  TimelineTile _buildTimelineTile(
    String date,
    String changelog,
    _IconIndicator indicator, {
    bool isLast = false,
    bool isFirst = false,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.35,
      beforeLineStyle: LineStyle(color: AppColors.mainColor),
      indicatorStyle: IndicatorStyle(
        indicatorXY: 0.5,
        drawGap: true,
        width: 30,
        height: 30,
        indicator: indicator,
      ),
      isLast: isLast,
      isFirst: isFirst,
      startChild: Center(
        child: Container(
          alignment: const Alignment(0.0, -0.10),
          child: Text(
            date,
            style: GoogleFonts.lato(
              fontSize: 15,
              color: AppColors.mainColor.withOpacity(0.8),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      endChild: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 10, top: 50, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              changelog,
              style: GoogleFonts.lato(
                fontSize: 16,
                color: AppColors.bigTextColor.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconIndicator extends StatelessWidget {
  const _IconIndicator({
    Key? key,
    this.iconData,
    this.size,
  }) : super(key: key);

  final IconData? iconData;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.mainColor,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 30,
              width: 30,
              child: Icon(
                iconData,
                size: size,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
