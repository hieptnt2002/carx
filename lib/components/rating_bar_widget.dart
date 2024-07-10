import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RatingBarWidget extends StatelessWidget {
  const RatingBarWidget({
    Key? key,
    required this.rating,
    required this.totalRating,
    required this.percent,
  }) : super(key: key);

  final int rating;
  final int totalRating;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 10,
          child: Text(
            rating.toString(),
            style: AppText.subtitle3,
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(4, 0, 6, 0),
          child: Icon(
            Icons.star_sharp,
            color: Colors.amber,
            size: 16,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
            child: LinearPercentIndicator(
              percent: percent,
              lineHeight: 8,
              animation: true,
              animateFromLastPercent: true,
              progressColor: Colors.green,
              barRadius: const Radius.circular(4),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        SizedBox(
          width: 32,
          child: Text(
            totalRating.toString(),
            style: AppText.subtitle3,
          ),
        ),
      ],
    );
  }
}
