import 'package:applovin_max/applovin_max.dart';
import 'package:character_ai_delta/app/data/ai_model.dart';
import 'package:character_ai_delta/app/data/firbase_charecters.dart';
import 'package:character_ai_delta/app/modules/controllers/create_avatar_ctl.dart';
import 'package:character_ai_delta/app/modules/controllers/home_view_ctl.dart';
import 'package:character_ai_delta/app/provider/applovin_ads_provider.dart';
import 'package:character_ai_delta/app/provider/meta_ads_provider.dart';
import 'package:character_ai_delta/app/routes/app_pages.dart';
import 'package:character_ai_delta/app/utills/app_strings.dart';
import 'package:character_ai_delta/app/utills/colors.dart';
import 'package:character_ai_delta/app/utills/images.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAvatar extends GetView<CreateAvatarCTL> {
  const CreateAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Characters",
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 6,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Stack(
          children: [
            Obx(() => controller.userAvatars.length == 0
                ? _noCharecterView()
                : _AvatarListView()),
            _CreateCharecterBTN()
          ],
        ),
      ),
    );
  }

  Widget _AvatarListView() {
    return Obx(() => ListView.builder(
        itemCount: controller.userAvatars.length,
        itemBuilder: (context, index) {
          return _avatarItem(index);
        }));
  }

  Widget _avatarItem(int index) {
    return GestureDetector(
      onTap: () {
        HomeViewCTL homeViewCTL = Get.find();
        AIChatModel avatar = AIChatModel(
            controller.userAvatars[index].avatarName,
            [controller.userAvatars[index].avatarFirstMessage],
            controller.userAvatars[index].imageAsset,
            false,
            controller.userAvatars[index].avatarDescription,
            Routes.GfChatView,
            mainContainerType.avatar,
            null,
            "UserAvatar");
        homeViewCTL.openAvatarChat(
            avatar,
            FirebaseCharecter(
                title: "",
                description: "",
                firstMessage: "",
                intro: "",
                category: "custom",
                imageUrl: "",
                historyMessages: ""));
        if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
          MetaAdsProvider.instance.showInterstitialAd();
        } else {
          AppLovinProvider.instance.showInterstitial(() {}, false);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeVertical * 1.5,
            horizontal: SizeConfig.blockSizeHorizontal * 5),
        height: SizeConfig.blockSizeVertical * 15,
        width: SizeConfig.blockSizeHorizontal * 90,
        decoration: BoxDecoration(
            color: AppColors.cardBackground_color,
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 4)),
        child: Row(
          children: [
            Image.asset(controller.userAvatars[index].imageAsset),
            horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.userAvatars[index].avatarName,
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                verticalSpace(SizeConfig.blockSizeVertical * 1),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 40,
                  child: Text(
                    controller.userAvatars[index].avatarFirstMessage,
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
    ;
  }

  ListView _noCharecterView() {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin:
                    EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 3),
                width: SizeConfig.blockSizeHorizontal * 35,
                height: SizeConfig.blockSizeVertical * 23,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground_color,
                  borderRadius:
                      BorderRadius.circular(SizeConfig.blockSizeHorizontal * 5),
                  // Apply the border radius to the image itself
                  image: DecorationImage(
                      fit: BoxFit.cover, // Fill the entire container
                      image: Image.asset(AppImages.engteacher).image
                      // CachedNetworkImageProvider(character.imageUrl),
                      ),
                ),
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 2),
              Text(
                "You haven't created any character yet",
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.white,
                ),
              ),
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
                          print(
                              'Mrec widget ad failed to load with error code ' +
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
      ],
    );
  }

  Widget _CreateCharecterBTN() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 6),
        child: GestureDetector(
          onTap: () {
            // // // //
            Get.toNamed(Routes.AvatarHome);
            if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
              MetaAdsProvider.instance.showInterstitialAd();
            } else {
              AppLovinProvider.instance.showInterstitial(() {}, false);
            }
          },
          child: Container(
            height: SizeConfig.blockSizeVertical * 7,
            width: SizeConfig.blockSizeHorizontal * 70,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    // color: Color(0xFF00DADD), // Shadow color
                    color: Colors.indigo, // Shadow color
                    spreadRadius: 0, // Spread radius
                    blurRadius: 10, // Blur radius
                    offset: Offset(0, 2), // Offset in x and y direction
                  ),
                ],
                borderRadius:
                    BorderRadius.circular(SizeConfig.blockSizeHorizontal * 10),
                color: AppColors.ScaffoldColor,
                border: Border.all(color: Colors.indigo)

                // gradient: LinearGradient(colors: [
                //   Color(0xFF00DADD),
                //   Color(0xFF0E898A)
                // ])
                ),
            child: Center(
              child: Text(
                "Create Character",
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00DADD)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
