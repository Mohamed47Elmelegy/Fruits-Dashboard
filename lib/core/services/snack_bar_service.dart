import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/colors_theme.dart';

class SnackBarService {
  static void showSuccessMessage(String msg) {
    BotToast.showCustomNotification(
      toastBuilder: (void Function() cancelFunc) {
        return Material(
          color: Colors.transparent,
          child: Container(
            width: double.maxFinite,
            height: msg.length > 80 ? 100 : 75,
            padding: const EdgeInsets.only(right: 8),
            margin: const EdgeInsets.only(
              left: 24,
              right: 24,
            ),
            decoration: BoxDecoration(
              color: AppColors.grayscale50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: msg.length > 80
                ? Row(
                    children: [
                      Container(
                        height: double.infinity,
                        width: 10,
                        decoration: const BoxDecoration(
                            color: AppColors.green600,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Lottie.asset(
                          "assets/snakebarJson/face_success_icon.json",
                          repeat: false,
                          height: 250,
                          width: 250,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "نجاح",
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              msg,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.black26,
                        thickness: 2,
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: cancelFunc,
                          icon: const Text(
                            "اغلاق",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: double.infinity,
                        width: 10,
                        decoration: const BoxDecoration(
                            color: AppColors.green1_500,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Lottie.asset(
                          "assets/snakebarJson/face_success_icon.json",
                          repeat: false,
                          height: 250,
                          width: 250,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "نجاح",
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              msg,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.black26,
                        thickness: 2,
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: cancelFunc,
                          icon: const Text(
                            "أغلاق",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
      duration: const Duration(
        seconds: 10,
      ),
      dismissDirections: [DismissDirection.endToStart],
    );
  }

  static void showErrorMessage(String msg) {
    BotToast.showCustomNotification(
      toastBuilder: (void Function() cancelFunc) {
        return Material(
          color: Colors.transparent,
          child: Container(
            width: double.maxFinite,
            height: msg.length > 80 ? 110 : 85,
            padding: const EdgeInsets.only(right: 8),
            margin: const EdgeInsets.only(
              left: 24,
              right: 24,
            ),
            decoration: BoxDecoration(
              color: AppColors.grayscale50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: msg.length > 80
                ? Row(
                    children: [
                      Container(
                        height: double.infinity,
                        width: 10,
                        decoration: const BoxDecoration(
                            color: Color(0xFFd12e2e),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Lottie.asset(
                          "assets/snakebarJson/wrong.json",
                          repeat: true,
                          height: 250,
                          width: 250,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'خطأ',
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              msg,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.black26,
                        thickness: 2,
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: cancelFunc,
                          icon: const Text(
                            'اغلاق',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: double.infinity,
                        width: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFFd12e2e),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Lottie.asset(
                          "assets/snakebarJson/face_wrong_icon.json",
                          width: 200,
                          height: 200,
                          repeat: false,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "خطأ",
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              msg,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.black26,
                        thickness: 2,
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: cancelFunc,
                          icon: const Text(
                            "اغلاق",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
      duration: const Duration(
        seconds: 10,
      ),
      dismissDirections: [DismissDirection.endToStart],
    );
  }
}
