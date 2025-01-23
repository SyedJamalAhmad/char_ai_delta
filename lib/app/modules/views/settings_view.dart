import 'package:applovin_max/applovin_max.dart';
import 'package:character_ai_delta/app/modules/controllers/settings_ctl.dart';
import 'package:character_ai_delta/app/provider/applovin_ads_provider.dart';
import 'package:character_ai_delta/app/utills/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utills/size_config.dart';

class SettingsView extends GetView<SettingsCTL> {
  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              // AppLovinProvider.instance.showInterstitial(() {});
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Settings",
            style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.blockSizeHorizontal * 6,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(children: [
          verticalSpace(SizeConfig.blockSizeVertical * 2),
          Container(
            // height: 60,
            // color: Colors.amber,
            child: Align(
              alignment: Alignment.center,
              child: Obx(() => AppLovinProvider.instance.isAdsEnabled.value
                  ? MaxAdView(
                      adUnitId: AppStrings.MAX_BANNER_ID,
                      adFormat: AdFormat.banner,
                      listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                        print('Banner widget ad loaded from ' + ad.networkName);
                      }, onAdLoadFailedCallback: (adUnitId, error) {
                        print(
                            'Banner widget ad failed to load with error code ' +
                                error.code.toString() +
                                ' and message: ' +
                                error.message);
                      }, onAdClickedCallback: (ad) {
                        print('Banner widget ad clicked');
                      }, onAdExpandedCallback: (ad) {
                        print('Banner widget ad expanded');
                      }, onAdCollapsedCallback: (ad) {
                        print('Banner widget ad collapsed');
                      }))
                  : Container()),
            ),
          ),
          // Container(
          //   height: SizeConfig.screenHeight,
          //   width: SizeConfig.screenWidth,
          //   child: Image.asset(
          //     AppImages.gems,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              // LaunchReview.launch(
              //   androidAppId: "character.avatar.ai.app.novax",
              // );
            },
            child: settings_btn(
                "Rate us",
                CupertinoIcons.hand_thumbsup_fill,
                "Help us to grow with your 5 star",
                Icons.arrow_forward_ios_rounded),
          ),
          GestureDetector(
            onTap: () {
              controller.ShareApp();
            },
            child: settings_btn("Invite your friends", Icons.person_add_alt_1,
                "Spread the World", Icons.arrow_forward_ios_rounded),
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 5),
          Container(
            // height: 60,
            // color: Colors.amber,
            child: Align(
              alignment: Alignment.center,
              child: Obx(() => AppLovinProvider.instance.isAdsEnabled.value
                  ? MaxAdView(
                      adUnitId: AppStrings.MAX_MREC_ID,
                      adFormat: AdFormat.mrec,
                      listener: AdViewAdListener(onAdLoadedCallback: (ad) {
                        print('Banner widget ad loaded from ' + ad.networkName);
                      }, onAdLoadFailedCallback: (adUnitId, error) {
                        print(
                            'Banner widget ad failed to load with error code ' +
                                error.code.toString() +
                                ' and message: ' +
                                error.message);
                      }, onAdClickedCallback: (ad) {
                        print('Banner widget ad clicked');
                      }, onAdExpandedCallback: (ad) {
                        print('Banner widget ad expanded');
                      }, onAdCollapsedCallback: (ad) {
                        print('Banner widget ad collapsed');
                      }))
                  : Container()),
            ),
          ),
        ]));
  }

  Padding settings_btn(
      String text1, IconData icon1, String text2, IconData icon2) {
    return Padding(
      padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 4,
          left: SizeConfig.blockSizeHorizontal * 7,
          right: SizeConfig.blockSizeHorizontal * 5),
      child: Row(
        children: [
          Icon(
            icon1,
            color: Colors.white,
            size: SizeConfig.blockSizeHorizontal * 7,
          ),
          horizontalSpace(SizeConfig.blockSizeHorizontal * 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 4,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                text2,
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 3,
                    color: Colors.blue),
              )
            ],
          ),
          Spacer(),
          Icon(
            icon2,
            color: Colors.white,
            size: SizeConfig.blockSizeHorizontal * 6,
          )
        ],
      ),
    );
  }
}
