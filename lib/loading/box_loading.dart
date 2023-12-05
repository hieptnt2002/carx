import 'package:carx/utilities/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BoxLoading {
  factory BoxLoading() => _screen;
  static final BoxLoading _screen = BoxLoading.screenInstance();
  BoxLoading.screenInstance();

  OverlayEntry? overlay;

  void show({
    required BuildContext context,
  }) {
    overlay ?? showOverlay(context: context);
  }

  void hide() {
    overlay?.remove();
    overlay = null;
  }

  void showOverlay({
    required BuildContext context,
  }) {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: size.width * 0.6,
                  maxHeight: size.height * 0.8,
                  minWidth: size.width * 0.4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      SpinKitCircle(
                        color: AppColors.primary,
                        size: 50,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Đơi trong giây lát!',
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(overlay!);
  }
}
