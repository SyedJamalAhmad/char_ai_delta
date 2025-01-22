import 'package:applovin_max/applovin_max.dart';
import 'package:character_ai_delta/app/modules/avatar/controller/avatar_view_ctl.dart';
import 'package:character_ai_delta/app/provider/applovin_ads_provider.dart';
import 'package:character_ai_delta/app/routes/app_pages.dart';
import 'package:character_ai_delta/app/utills/app_strings.dart';
import 'package:character_ai_delta/app/utills/colors.dart';
import 'package:character_ai_delta/app/utills/images.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvatarHome extends GetView<AvatarViewCTL> {
  const AvatarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Character Type",
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 6,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            verticalSpace(SizeConfig.blockSizeVertical * 1),
            characters_type(AppImages.Makima, "Person",
                "Create your own AI characters", CreateCharType.Person),
            characters_type(
                AppImages.dog,
                "Animal",
                "Give your animal friends the ability to speak",
                CreateCharType.Animal),
            characters_type(
                AppImages.CodeDebugger,
                "Others",
                "Give life to inanimate stuff character",
                CreateCharType.Others),
            verticalSpace(SizeConfig.blockSizeVertical * 2),
            Container(
              // color: Colors.red,
              child: Obx(() => AppLovinProvider.instance.isAdsEnabled.value
                  ? MaxAdView(
                      adUnitId: AppStrings.MAX_MREC_ID,
                      adFormat: AdFormat.mrec,
                      listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                        FirebaseAnalytics.instance.logAdImpression(
                          adFormat: "Mrec",
                          adSource: ad.networkName,
                          value: ad.revenue,
                        );
                        print('Mrec widget ad loaded from ' + ad.networkName);
                      }, onAdLoadFailedCallback: (adUnitId, error) {
                        print('Mrec widget ad failed to load with error code ' +
                            error.code.toString() +
                            ' and message: ' +
                            error.message);
                      }, onAdClickedCallback: (ad) {
                        print('Mrec widget ad clicked');
                      }, onAdExpandedCallback: (ad) {
                        print('Mrec widget ad expanded');
                      }, onAdCollapsedCallback: (ad) {
                        print('Mrec widget ad collapsed');
                      }))
                  : Container()),
            ),
          ],
        ),
      ),
    );
  }

  Widget characters_type(
      String image, String text1, String text2, CreateCharType charType) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.IntroAvatar, arguments: charType);
      },
      child: Container(
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
        height: SizeConfig.blockSizeVertical * 15,
        width: SizeConfig.blockSizeHorizontal * 90,
        decoration: BoxDecoration(
            color: AppColors.cardBackground_color,
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4)),
        child: Row(
          children: [
            Image.asset(image),
            horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text1,
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                verticalSpace(SizeConfig.blockSizeVertical * 1),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 40,
                  child: Text(
                    text2,
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 3,
                        color: Colors.grey),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

enum CreateCharType { Person, Animal, Others }
