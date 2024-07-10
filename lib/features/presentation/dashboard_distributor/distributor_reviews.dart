import 'package:carx/components/reviews_car.dart';
import 'package:carx/features/model/car_review.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DistributorReviews extends StatefulWidget {
  const DistributorReviews({super.key});

  @override
  State<DistributorReviews> createState() => _DistributorReviewsState();
}

class _DistributorReviewsState extends State<DistributorReviews> {
  List<CarReview> reviews = [];
  @override
  void didChangeDependencies() {
    reviews = ModalRoute.of(context)!.settings.arguments as List<CarReview>;
    super.didChangeDependencies();
  }

  double avgRating() {
    double sum = 0;
    for (var review in reviews) {
      sum += review.rating;
    }
    double avg = sum / reviews.length;
    return double.parse(avg.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 6),
                  child: Text(
                    '${avgRating()}',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 6),
                  child: RatingBarIndicator(
                    direction: Axis.horizontal,
                    rating: avgRating(),
                    itemCount: 5,
                    itemSize: 24,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star_border_rounded,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
              child: Text(
                '${reviews.length} Đánh giá | Phản hồi',
                style: AppText.bodyPrimary,
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 32, 12, 0),
              child: Text(
                'Tất cả cả đánh giá',
                style: AppText.title2,
              ),
            ),
            const Divider(
              height: 32,
              thickness: 4,
              color: AppColors.whiteSmoke,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 12),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ReviewsCardWidget(
                    carReview: reviews[index],
                  );
                },
                itemCount: reviews.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
