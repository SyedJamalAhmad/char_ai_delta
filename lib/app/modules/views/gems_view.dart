import 'dart:developer';
import 'package:character_ai_delta/app/utills/app_strings.dart';
import 'package:character_ai_delta/app/utills/gems_rate.dart';
import 'package:character_ai_delta/app/utills/images.dart';
import 'package:character_ai_delta/app/utills/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import '../../utills/colors.dart';
import '../../utills/size_config.dart';
import '../controllers/gems_view_controller.dart';

class GemsView extends GetView<GemsViewController> {
  GemsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        log("backed");
        // if (RevenueCatService().currentEntitlement.value == Entitlement.free) {
        //   AppLovinProvider.instance.showInterstitial(() {});
        // }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Get GEMS',
              style: TextStyle(color: Colors.white),
            ),
            leading: GestureDetector(
              onTap: () {
                // if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
                //   MetaAdsProvider.instance.showInterstitialAd();
                // } else {
                //   AppLovinProvider.instance.showInterstitial(() {});
                // }
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            )
            // centerTitle: true,
            ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight * 0.03,
              ),
              Text(
                'Available GEMS',
                style: StyleSheet.Intro_heading,
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  controller.hackMethod();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.gems,
                      scale: 10,
                    ),
                    Obx(
                      () => Text(
                        " ${controller.homectl.gems.value}",
                        style: StyleSheet.home_text,
                      ),
                    )
                    // SizedBox(width: SizeConfig.screenWidth *0.03,)
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.03,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Watch Ads To Get GEMS:',
                          style: StyleSheet.Intro_Sub_heading,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.01,
                    ),
                    Ad_GEM_widget(),

                    verticalSpace(SizeConfig.blockSizeVertical * 5),

                    // ? Commented by jamal!
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.toNamed(Routes.NEWGEMSVIEW);
                    //   },
                    //   child: Container(
                    //     height: SizeConfig.blockSizeVertical * 7,
                    //     width: SizeConfig.blockSizeHorizontal * 60,
                    //     decoration: BoxDecoration(
                    //         color: Color(0xEEF37B38),
                    //         borderRadius: BorderRadius.circular(
                    //             SizeConfig.blockSizeHorizontal * 4)),
                    //     child: Center(
                    //       child: Text(
                    //         "Gems Testing",
                    //         style: TextStyle(
                    //             fontSize: SizeConfig.blockSizeHorizontal * 5,
                    //             color: Colors.white),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   // height: 60,
                    //   // color: Colors.amber,
                    //   child: Align(
                    //     alignment: Alignment.center,
                    //     child: Obx(() => AppLovinProvider
                    //             .instance.isAdsEnabled.value
                    //         ? MaxAdView(
                    //             adUnitId: AppStrings.MAX_MREC_ID,
                    //             adFormat: AdFormat.mrec,
                    //             listener:
                    //                 AdViewAdListener(onAdLoadedCallback: (ad) {
                    //               print('Banner widget ad loaded from ' +
                    //                   ad.networkName);
                    //             }, onAdLoadFailedCallback: (adUnitId, error) {
                    //               print(
                    //                   'Banner widget ad failed to load with error code ' +
                    //                       error.code.toString() +
                    //                       ' and message: ' +
                    //                       error.message);
                    //             }, onAdClickedCallback: (ad) {
                    //               print('Banner widget ad clicked');
                    //             }, onAdExpandedCallback: (ad) {
                    //               print('Banner widget ad expanded');
                    //             }, onAdCollapsedCallback: (ad) {
                    //               print('Banner widget ad collapsed');
                    //             }))
                    //         : Container()),
                    //   ),
                    // ),

                    // ? Commented by jamal start
                    // Platform.isAndroid
                    //     ? Row(
                    //         children: [
                    //           Text(
                    //             'Buy GEMS:',
                    //             style: StyleSheet.Intro_Sub_heading,
                    //           ),
                    //         ],
                    //       )
                    //     : Container(),
                    // SizedBox(
                    //   height: SizeConfig.screenHeight * 0.01,
                    // ),
                    // Platform.isAndroid || Platform.isIOS
                    //     ? BUY_GEM_widget(context)
                    //     : Container()
                    // ? Commented by jamal end
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget Ad_GEM_widget() {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.screenHeight * 0.03,
        ),
        // ElevatedButton(onPressed: (){}, child: Text("Watch Interstitial AD (${GEMS_RATE.INTER_INCREAES_GEMS_RATE} GEMS)")),
        GestureDetector(
          onTap: () {
            // ? Commented by jamal start

            // ? Commented by jamal end
            // //?Changed by Jamal[]
            // AppLovinProvider.instance
            //     .showInterstitial(controller.increase_inter_gems, true);
          },
          child: Container(
            width: SizeConfig.screenWidth * 0.8,
            height: SizeConfig.screenHeight * 0.06,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.indigo, // Set the border color here
                width: 2.0, // Set the border width here
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Center(
                child: Text(
              "Watch Short Video AD (${GEMS_RATE.INTER_INCREAES_GEMS_RATE} GEMS)",
              style: StyleSheet.Intro_Sub_heading2,
            )),
          ),
        ),
        SizedBox(
          height: SizeConfig.screenHeight * 0.02,
        ),
        GestureDetector(
          onTap: () {
            // ? Commented by jamal start

            // ? Commented by jamal end
            ////?Changed by Jamal[]
            // AppLovinProvider.instance
            //     .showInterstitial(controller.increase_reward_gems, true);
          },
          child: Container(
            width: SizeConfig.screenWidth * 0.8,
            height: SizeConfig.screenHeight * 0.06,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.indigo, // Set the border color here
                width: 2.0, // Set the border width here
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Center(
                child: Text(
              "Watch Long Video AD (${GEMS_RATE.REWARD_INCREAES_GEMS_RATE} GEMS)",
              style: StyleSheet.Intro_Sub_heading2,
            )),
          ),
        ),
        // ElevatedButton(onPressed: (){}, child: Text("Watch Video AD (${GEMS_RATE.REWARD_INCREAES_GEMS_RATE} GEMS)")),
        SizedBox(
          height: SizeConfig.screenHeight * 0.03,
        ),
        // Padding(
        //   padding:  EdgeInsets.all(10),
        //   child: Row(
        //     children: [
        //       Text(
        //                           'Buy GEMS',
        //                           style: StyleSheet.sub_heading12,
        //                         ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget BUY_GEM_widget(context) {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.screenHeight * 0.02,
        ),
        // ElevatedButton(onPressed: (){}, child: Text("Watch Interstitial AD (${GEMS_RATE.INTER_INCREAES_GEMS_RATE} GEMS)")),
        GestureDetector(
          onTap: () {
            // NavCTL navCTL = Get.find();
            // navCTL.subscriptionCall();
            // Get.toNamed(Routes.SUBSCRIPTION);
            _settingModalBottomSheet(context);
            // Get.to
          },
          child: Container(
            width: SizeConfig.screenWidth * 0.8,
            height: SizeConfig.screenHeight * 0.06,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.icon_color, // Set the border color here
                width: 2.0, // Set the border width here
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
            // child: Center(child: Text("Become Subscriber",style: StyleSheet.Intro_Sub_heading2,)),),
            child: Center(
                child: Text(
              "Buy GEMS",
              style: StyleSheet.Intro_Sub_heading2,
            )),
          ),
        ),
        //   SizedBox(height: SizeConfig.screenHeight *0.02,),
        // Container(
        //   width: SizeConfig.screenWidth *0.8,
        //   height: SizeConfig.screenHeight *0.06,
        //               decoration: BoxDecoration(
        //                 border: Border.all(
        //                   color: AppColors.icon_color, // Set the border color here
        //                   width: 2.0, // Set the border width here
        //                 ),
        //                 borderRadius: BorderRadius.circular(40.0),
        //               ),
        //   child: Center(child: Text("Watch Video AD (${GEMS_RATE.REWARD_INCREAES_GEMS_RATE} GEMS)",style: StyleSheet.Intro_Sub_heading2,)),),
        // // ElevatedButton(onPressed: (){}, child: Text("Watch Video AD (${GEMS_RATE.REWARD_INCREAES_GEMS_RATE} GEMS)")),
        // SizedBox(height: SizeConfig.screenHeight *0.03,),
        // Padding(
        //   padding:  EdgeInsets.all(10),
        //   child: Row(
        //     children: [
        //       Text(
        //                           'Buy GEMS',
        //                           style: StyleSheet.sub_heading12,
        //                         ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Future<void> _settingModalBottomSheet(context) async {
    // controller.packageList.value =
    //     await controller.revenueCatService.getProducts();  // ? Commented by jamal
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            // color: AppColors.ScaffoldColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              // color: AppColors.Bright_Pink_color
              color: AppColors.ScaffoldColor,
              // color: AppColors.white_color,
            ),
            // color: AppColors.white_color,
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.selected_color,
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.02,
                        ),
                        Text(
                          "Upgrade Your Plan",
                          style: StyleSheet.home_sub_text,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Upgrade to a new plan to enjoy more benefits",
                          style: StyleSheet.sub_heading,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: SizeConfig.screenHeight * 0.02,
                  ),
                  Obx(() => (controller.packageList.isNotEmpty &&
                          controller.notloading.value)
                      ? Container(
                          height: SizeConfig.screenHeight * 0.3,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: controller.packageList.length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      log("Card pressed ${controller.packageList[index]}");
                                      if (controller.packageList[index]
                                          .storeProduct.description
                                          .contains("100")) {
                                        log("contain 100 in it");
                                        // title = "100 Gems";
                                        controller.purchaseSubscription(
                                            controller.packageList[index]);
                                      }
                                      if (controller.packageList[index]
                                          .storeProduct.description
                                          .contains("500")) {
                                        log("contain 500 in it");
                                        // title = "500 Gems";
                                        controller.purchaseSubscription(
                                            controller.packageList[index]);
                                      }
                                    },
                                    child: Card_for_Gems(
                                        controller.packageList[index], index));
                              })),
                        )
                      : Center(child: CircularProgressIndicator())),
                  Container(
                    height: SizeConfig.screenHeight * 0.02,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget Card_for_Gems(Package package, int index) {
    String packageTypeString = "";
    String subtitle = "";
    subtitle = package.storeProduct.description;

    String title = package.storeProduct.title;

    if (package.storeProduct.description.contains("100")) {
      log("contain 100 in it");
      title = "100 Gems";
    }
    if (package.storeProduct.description.contains("500")) {
      log("contain 500 in it");
      title = "500 Gems";
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // color: AppColors.Bright_Pink_color,
        width: SizeConfig.screenWidth,
        // height: SizeConfig.screenHeight * 0.1,
        // height: 10,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.icon_color, // Set the border color here
            width: 2.0, // Set the border width here
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 6,
                      // child: Text("${controller.less_coins_heading}",style: StyleSheet.home_sub_text,)),
                      child: Text(
                        "${title}",
                        style: StyleSheet.home_sub_text,
                      )),
                  Flexible(
                      flex: 1,
                      // child: Text("${controller.less_coins_price}",style: StyleSheet.Intro_Sub_heading,))
                      child: Text(
                        "${package.storeProduct.priceString}",
                        style: StyleSheet.Intro_Sub_heading,
                      ))
                ],
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 1,
                      child: Text(
                        "${subtitle}",
                        style: StyleSheet.Intro_Sub_heading,
                      )),
                  // Text("price")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Card_for_less_Gems extends GetView<GemsViewController> {
  const Card_for_less_Gems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight * 0.1,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.icon_color, // Set the border color here
          width: 2.0, // Set the border width here
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 6,
                    child: Text(
                      "${controller.less_coins_heading}",
                      style: StyleSheet.home_sub_text,
                    )),
                Flexible(
                    flex: 1,
                    child: Text(
                      "${controller.less_coins_price}",
                      style: StyleSheet.Intro_Sub_heading,
                    ))
              ],
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 1,
                    child: Text(
                      "${controller.less_coins_sub_heading}",
                      style: StyleSheet.Intro_Sub_heading,
                    )),
                // Text("price")
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Card_for_high_Gems extends GetView<GemsViewController> {
  const Card_for_high_Gems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight * 0.1,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.icon_color, // Set the border color here
          width: 2.0, // Set the border width here
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 6,
                    child: Text(
                      "${controller.high_coins_heading}",
                      style: StyleSheet.home_sub_text,
                    )),
                Flexible(
                    flex: 1,
                    child: Text(
                      "${controller.high_coins_price}",
                      style: StyleSheet.Intro_Sub_heading,
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 1,
                    child: Text(
                      "${controller.high_coins_sub_heading}",
                      style: StyleSheet.Intro_Sub_heading,
                    )),
                // Text("price")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
