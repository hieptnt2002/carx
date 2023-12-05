import 'package:cached_network_image/cached_network_image.dart';
import 'package:carx/data/model/car.dart';
import 'package:carx/data/reponsitories/car/car_reponsitory_impl.dart';
import 'package:carx/loading/loading.dart';
import 'package:carx/utilities/app_colors.dart';
import 'package:carx/utilities/dialog/bloc/car_review_bloc.dart';
import 'package:carx/utilities/dialog/bloc/car_review_event.dart';
import 'package:carx/utilities/dialog/bloc/car_review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Future<bool> ratingVoteDialog(
    BuildContext context, Car car, String codeOrder) async {
  CarReviewBloc carReviewBloc = CarReviewBloc(CarReponsitoryImpl.response());
  final FocusNode textFocusNode = FocusNode();
  return showDialog(
    context: context,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocProvider(
          create: (context) => carReviewBloc,
          child: BlocConsumer<CarReviewBloc, CarReviewState>(
            listener: (context, state) {
              final status = state.status;
              if (status == CarReviewStatus.loading) {
                Loading().show(context: context);
              } else if (status == CarReviewStatus.success) {
                Loading().hide();

                Navigator.pop(context, true);
              } else if (status == CarReviewStatus.failure) {
                Loading().hide();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Không thể nhập ký tự đặc biệt!',
                      style: TextStyle(color: AppColors.white),
                    ),
                    backgroundColor: AppColors.fontColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),
                    ),
                    duration: Duration(milliseconds: 800),
                  ),
                );
              }else{
                Loading().hide();
              }
            },
            builder: (context, state) => Stack(
              alignment: Alignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  overlayColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  child: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 530,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 48),
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 32, 16, 16),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           
                            Text(
                              car.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID : $codeOrder',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Đánh giá của bạn rất quan trọng để chúng tôi cải thiện và cung cấp dịch vụ tốt hơn',
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Gửi sao đánh giá',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            RatingBar.builder(
                              initialRating: 5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              maxRating: 5,
                              onRatingUpdate: (rating) {
                                carReviewBloc.add(StarRatingVoteEvent(rating));
                              },
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              focusNode: textFocusNode,
                              onChanged: (value) {
                                carReviewBloc.add(CommentInputCarReviewEvent(
                                    value.toString()));
                              },
                              autocorrect: false,
                              cursorColor: Colors.black,
                              decoration: const InputDecoration(
                                hintText: 'Nội dung phản hồi ......',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: AppColors.whiteSmoke,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(fontSize: 14),
                              minLines: 5,
                              maxLines: 5,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                onPressed: () {
                                  textFocusNode.unfocus();
                                  carReviewBloc
                                      .add(SubmitCarReviewEvent(car.id));
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                                child: const Text(
                                  'Gửi đánh giá',
                                  style: TextStyle(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(1.0),
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: AppColors.whiteSmoke,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(9999)),
                          border: Border.all(
                            width: 1,
                            color: const Color(0xffe0e3e7),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(9999)),
                          child: CachedNetworkImage(
                            imageUrl: car.image,
                            width: 72,
                            height: 72,
                            fit: BoxFit.contain,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/logo-dark.png',
                              width: 72,
                              height: 72,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) => value ?? false);
}
