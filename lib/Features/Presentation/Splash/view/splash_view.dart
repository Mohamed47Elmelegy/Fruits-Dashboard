import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/Routes/page_routes_name.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../main.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        navigatorKey.currentState!
            .pushReplacementNamed(PageRoutesName.datshbord);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      body: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (!isArabic) // عرض الصورة لليسار إذا كانت اللغة إنجليزية
                  SvgPicture.asset(
                    Assets.imagesPlant,
                  ),
                const Spacer(), // مسافة بينية
                if (isArabic) // عرض الصورة لليمين إذا كانت اللغة عربية
                  SvgPicture.asset(
                    Assets.imagesPlant,
                  ),
              ],
            ),
            SvgPicture.asset(Assets.imagesLogo),
            SvgPicture.asset(
              Assets.imagesCirclesSplash,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }

  void navigateBasedOnUserStatus() {}
}
