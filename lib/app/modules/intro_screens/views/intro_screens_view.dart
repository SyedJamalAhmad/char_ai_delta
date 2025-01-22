import 'package:applovin_max/applovin_max.dart';
import 'package:character_ai_delta/app/modules/intro_screens/views/intro_screen_onboarding.dart';
import 'package:character_ai_delta/app/provider/applovin_ads_provider.dart';
import 'package:character_ai_delta/app/utills/app_strings.dart';
import 'package:character_ai_delta/app/utills/images.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/intro_screens_controller.dart';

class IntroScreensView extends GetView<IntroScreensController> {
  const IntroScreensView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title:  Text('IntroScreensView'),
      //   centerTitle: true,
      // ),
      body: Container(
        padding:
            EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 3),
        child: IntroScreenOnboarding(
          introductionList: [
            MyIntroduction(
              title: 'Chat & Create with AI Characters',
              // subTitle:'Let AI craft your killer slides. Own your next on demand presentation.',
              imageUrl: AppImages.intro,
            ),
            MyIntroduction(
              title: 'Unveiling the Power of Character AI',
              // subTitle: 'Unlock the power of AI to conquer any math challenge.',
              imageUrl: AppImages.intro1,
            ),
            MyIntroduction(
              title: 'Where Your Ideas Come Alive',
              // subTitle: 'Open Any Document in the app as an add on',
              imageUrl: AppImages.intro2,
            ),
          ],
          onTapSkipButton: () {
            controller.goToHomePage();
          },
        ),
      ),
    );
  }
}

class MyIntroduction extends StatefulWidget {
  final String imageUrl;
  final String title;
  // final String subTitle;
  final double? imageWidth;
  final double? imageHeight;
  final TextStyle titleTextStyle;
  final TextStyle subTitleTextStyle;

  MyIntroduction({
    required this.imageUrl,
    required this.title,
    // required this.subTitle,
    this.titleTextStyle =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    this.subTitleTextStyle = const TextStyle(fontSize: 20),
    this.imageWidth = 360,
    this.imageHeight = 360,
  });

  @override
  State<StatefulWidget> createState() {
    return MyIntroductionState();
  }
}

class MyIntroductionState extends State<MyIntroduction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 3),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image(
              image: AssetImage(widget.imageUrl),
              height: SizeConfig.blockSizeVertical * 35,
              width: widget.imageWidth,
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical * 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: widget.titleTextStyle,
              ),
            ],
          ),
          // verticalSpace(SizeConfig.blockSizeVertical * 15),
          // Text(
          //   widget.subTitle,
          //   style: widget.subTitleTextStyle,
          //   overflow: TextOverflow.clip,
          //   textAlign: TextAlign.center,
          // ),
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
          verticalSpace(SizeConfig.blockSizeVertical * 2),
        ],
      ),
    );
  }
}
