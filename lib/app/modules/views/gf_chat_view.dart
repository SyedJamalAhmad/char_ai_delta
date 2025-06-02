import 'dart:developer';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:character_ai_delta/app/provider/admob_ads_provider.dart';
import 'package:character_ai_delta/app/provider/meta_ads_provider.dart';
import 'package:character_ai_delta/app/services/revenuecat_service.dart';
import 'package:character_ai_delta/app/utills/app_strings.dart';
import 'package:character_ai_delta/app/utills/images.dart';
import 'package:character_ai_delta/app/utills/style.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:lottie/lottie.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:video_player/video_player.dart';

import '../../routes/app_pages.dart';
import '../../utills/colors.dart';
import '../../utills/size_config.dart';
import '../controllers/gf_chat_view_controller.dart';
// import '../controllers/chat_view_ctl.dart';

class GfChatView extends GetView<GfChatViewController>
    with WidgetsBindingObserver {
  @override
  GfChatView() {
    WidgetsBinding.instance.addObserver(this);
    initBanner();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      controller.handleAppMinimized();
    }
  }

  late BannerAd myBanner;

  RxBool isBannerLoaded = false.obs;

  initBanner() {
    BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Banner Ad loaded.');
        isBannerLoaded.value = true;
        print("isBannerLoaded = $isBannerLoaded");
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Banner Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) {
        print('Banner Ad opened.');
      },
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) {
        print('Banner Ad closed.');
      },
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) {
        print('Banner Ad impression.');
      },
    );

    myBanner = BannerAd(
      adUnitId: AppStrings.ADMOB_BANNER,
      size: AdSize.banner,
      request: AdRequest(),
      listener: listener,
    );
    myBanner.load();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        log("backed");
        final FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          // If no widget has focus, close the keyboard (optional)
          FocusManager.instance.primaryFocus?.unfocus();
          controller.stopTextMessageSpeech();
          AdMobAdsProvider.instance.showInterstitialAd();

          return true; // Allow back navigation
        }

        final bool isKeyboardVisible =
            await KeyboardVisibilityController().isVisible;

        if (isKeyboardVisible) {
          // Close the keyboard
          currentFocus.unfocus();
          return false; // Prevent immediate back navigation
        } else {
          log("backed");
          controller.stopTextMessageSpeech();
          AdMobAdsProvider.instance.showInterstitialAd();
          return true; // Allow back navigation
        }
      },
      child: Scaffold(
          backgroundColor: AppColors.ScaffoldColor,
          body: Obx(
            () => Container(
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image:
              //         CachedNetworkImageProvider(controller.main_image.value),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: controller.showVideo.value
                        ? controller.isVideoControllerInitialized.value
                            ? FittedBox(
                                fit: BoxFit
                                    .cover, // Stretches beyond the screen width
                                child: SizedBox(
                                  width: controller
                                      .videoController.value.size.width,
                                  height: controller
                                      .videoController.value.size.height,
                                  child: CachedVideoPlayerPlus(
                                      controller.videoController),
                                ),
                              )
                            : Center()
                        : Obx(() => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      controller.main_image.value),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, SizeConfig.screenHeight * 0.04, 0, 0),
                    child: Column(
                      children: [
                        Expanded(
                            child: Obx(() => controller.chatList.length == 0
                                    ? Center(
                                        child: Container(
                                          child: Text(
                                            "No Chat Yet!",
                                            style: StyleSheet.Intro_heading,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(
                                          top:
                                              SizeConfig.blockSizeVertical * 15,
                                          bottom:
                                              SizeConfig.blockSizeVertical * 1,
                                        ),
                                        child: Obx(() => ListView.builder(
                                              reverse: true,
                                              itemCount: controller
                                                      .isWaitingForResponse
                                                      .value
                                                  ? controller.chatList.length +
                                                      1
                                                  : controller.chatList.length,
                                              itemBuilder: (context, index) {
                                                // Handle the extra message for bot
                                                if (controller
                                                        .isWaitingForResponse
                                                        .value &&
                                                    index == 0) {
                                                  return _MessageBubble(
                                                    false, // Bot message
                                                    "Bot is typing...", // Placeholder message
                                                    -1,
                                                    false,
                                                    false,
                                                  );
                                                }

                                                // Adjust index to access chatList correctly
                                                int adjustedIndex = controller
                                                        .isWaitingForResponse
                                                        .value
                                                    ? index - 1
                                                    : index;

                                                // Extract message details
                                                bool isSender = controller
                                                        .chatList[adjustedIndex]
                                                        .senderType ==
                                                    SenderType.User;
                                                String message = controller
                                                    .chatList[adjustedIndex]
                                                    .message;

                                                // Only update feedback for bot messages
                                                return Obx(() => _MessageBubble(
                                                      isSender,
                                                      message,
                                                      adjustedIndex,
                                                      controller
                                                          .chatList[
                                                              adjustedIndex]
                                                          .isFeedBack
                                                          .value,
                                                      controller
                                                          .chatList[
                                                              adjustedIndex]
                                                          .isGood
                                                          .value,
                                                    ));
                                              },
                                            )),
                                      )

                                // controller.
                                // Container(
                                //     margin: EdgeInsets.only(
                                //         top: SizeConfig.blockSizeVertical * 14),
                                //     child: ListView.builder(
                                //       reverse: true,
                                //       itemCount:
                                //           controller.isWaitingForResponse.value
                                //               ? controller.chatList.length + 1
                                //               : controller.chatList.length,
                                //       itemBuilder: (context, index) {
                                //         String message = "";
                                //         if (controller
                                //             .isWaitingForResponse.value) {
                                //           index -= 1;
                                //         }
                                //         bool isSender = true;
                                //         if (index == -1) {
                                //           isSender = false;
                                //         } else {
                                //           isSender = controller
                                //                   .chatList[index].senderType ==
                                //               SenderType.User;
                                //           message =
                                //               controller.chatList[index].message;
                                //         }

                                //         return Obx(() => _MessageBubble(
                                //             isSender,
                                //             message,
                                //             index,
                                //             controller
                                //                 .chatList[index].isFeedBack.value,
                                //             controller
                                //                 .chatList[index].isGood.value));
                                //       },
                                //     ),
                                //   )),

                                )),
                        _InputField(context),
                        // SizedBox(
                        //   height: SizeConfig.screenHeight * 0.01,
                        // )
                      ],
                    ),
                  ),
                  Container(
                      // color: Colors.black,
                      height: SizeConfig.screenHeight * 20,
                      child: _CustomeAppBar(context)),
                ],
              ),
            ),
          )),
    );
  }

  Widget _CustomeAppBar(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 3),
        height: SizeConfig.blockSizeVertical * 20,
        color: const Color.fromARGB(26, 0, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 5,
              ),
              // color: const Color.fromARGB(26, 0, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (RevenueCatService().currentEntitlement.value ==
                          Entitlement.free) {
                        if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
                          MetaAdsProvider.instance.showInterstitialAd();
                        } else {
                          // AppLovinProvider.instance
                          //     .showInterstitial(() {}, false);
                        }
                      }
                      controller.current_index.value = 0;
                      controller.chatList.clear();
                      controller.conversation.clear();
                      controller.gender_title.value = "AI Friend";
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus &&
                          currentFocus.focusedChild != null) {
                        FocusManager.instance.primaryFocus!.unfocus();
                      }
                      controller.stopTextMessageSpeech();
                      AdMobAdsProvider.instance.showInterstitialAd();

                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
                  Expanded(
                    child: Obx(() => Text(
                          controller.gender_title.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeHorizontal * 6,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  // Obx(() => GestureDetector(
                  //       onTap: () {
                  //         if (controller.firebaseCharecter != null) {
                  //           if (controller.isLoved.isFalse) {
                  //             controller.increaseLovedBy(
                  //                 controller.firebaseCharecter!);
                  //           }
                  //         }
                  //       },
                  //       child: Icon(
                  //         controller.isLoved.value
                  //             ? Icons.favorite
                  //             : Icons.favorite_outline,
                  //         color: Colors.pink,
                  //         size: 20,
                  //       ),
                  //     )),
                  horizontalSpace(SizeConfig.blockSizeHorizontal * 1.5),

                  //[[[[[[[[[[[[[[[[[[Commented by Jamal Temp]]]]]]]]]]]]]]]]]]
                  // Obx(() => GestureDetector(
                  //       onTap: () {
                  //         Get.toNamed(Routes.GemsView);
                  //       },
                  //       child: Row(
                  //         children: [
                  //           Image.asset(
                  //             AppImages.gems,
                  //             scale: 30,
                  //           ),
                  //           Text(
                  //             " ${controller.homectl.gems.value}",
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //           SizedBox(
                  //             width: SizeConfig.screenWidth * 0.03,
                  //           )
                  //         ],
                  //       ),
                  //     ))
                ],
              ),
            ),
            Obx(() => isBannerLoaded.value &&
                    AdMobAdsProvider.instance.isAdEnable.value
                ? Container(
                    height: AdSize.banner.height.toDouble(),
                    child: AdWidget(ad: myBanner))
                : Container()),
            // AppLovinProvider.instance.ShowBannerWidget(),
            verticalSpace(SizeConfig.blockSizeVertical * 2),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Note: This is AI Generated Content",
                style: StyleSheet.noteHeading,
              ),
            ),
            verticalSpace(SizeConfig.blockSizeVertical)
          ],
        ),
      ).asGlass(),
    );
  }

  Widget _InputField(BuildContext context) {
    controller.inputFieldContext = context;
    return Container(
      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 0.5),
      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 0.8),
      decoration: BoxDecoration(
        color: Color.fromARGB(215, 13, 13, 13),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        // color: Colors.red,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 2,
            vertical: SizeConfig.blockSizeVertical * 0.5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: controller.textFieldFocusNode,
                    maxLength: 500,
                    onChanged: (value) {
                      print("value: $value");
                      if (value == "") {
                        controller.userIsTyping.value = false;
                      } else {
                        controller.userIsTyping.value = true;
                      }
                    },
                    controller: controller.textEditingController,
                    cursorColor: Color(0xEEF37B38),
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                      color: AppColors.white_color, // WhatsApp text color
                    ),
                    decoration: InputDecoration(
                      fillColor: AppColors.white_color,
                      // hintMaxLines: 10,
                      hintText: "Write Your Message here...",
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 1,
                          horizontal: SizeConfig.blockSizeHorizontal * 2),

                      border: InputBorder.none, // Remove the border
                      counterStyle: TextStyle(color: Colors.white),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            // onLongPressCancel: () {
                            //   controller.recordButtonHandler(
                            //       Colors.red, false,
                            //       isRecordingCanceled: true);
                            //   developer.log("long press cancel ");
                            // },
                            onLongPress: () {
                              // controller.recordButtonHandler(
                              //     Colors.deepOrangeAccent, true);
                              controller.startListening();

                              developer.log("long press start ");
                            },
                            onLongPressUp: () {
                              // controller.recordButtonHandler(
                              //     Colors.lightBlueAccent, false);
                              controller.stopListening();

                              developer.log("long press end ");
                            },
                            // onLongPressEnd: (_) {
                            //   controller.recordButtonHandler(
                            //       Colors.lightBlueAccent, false);
                            //   developer.log("long press end $_");
                            // },
                            child: Obx(() => AnimatedScale(
                                  scale: controller.recordButtonColor.value ==
                                          Colors.deepOrangeAccent
                                      ? 1.15
                                      : 1,
                                  duration: Duration(seconds: 1),
                                  child: Container(
                                      padding: EdgeInsets.all(8),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: controller
                                              .recordButtonColor.value),
                                      child: Icon(Icons.mic)),
                                )),
                          ),
                          Container(
                            child: IconButton(
                              onPressed: () async {
                                await controller.sendMessageButton();
                              },
                              icon: Icon(
                                Icons.send,
                                color: Color(0xEEF37B38),
                                // Color(
                                //     0xFF25D366)
                              ), // WhatsApp send button icon
                            ),
                          ),
                        ],
                      ),
                      // :
                      // Container()
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).asGlass(
        clipBorderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)));
  }

  Container _MessageBubble(
      bool isSender, String message, int index, bool isFeedback, bool isGood) {
    double iconSize = SizeConfig.blockSizeHorizontal * 5;
    return Container(
      width: SizeConfig.screenWidth,

      // color: Colors.black,
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            //? Avatar image for Bot
            if (!isSender) ...[
              controller.main_image.value.contains("assets")
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: SizeConfig.blockSizeHorizontal * 10,
                          width: SizeConfig.blockSizeHorizontal * 10,
                          decoration: BoxDecoration(
                            // Apply border radius to the container itself
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal *
                                    5), // Make it a perfect circle
                            image: DecorationImage(
                              fit: BoxFit.cover, // Fill the entire container
                              image: AssetImage(controller.main_image.value),
                            ),
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.black38),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.play_arrow_rounded)))
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: SizeConfig.blockSizeHorizontal * 10,
                          width: SizeConfig.blockSizeHorizontal * 10,
                          decoration: BoxDecoration(
                            // Apply border radius to the container itself
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal *
                                    5), // Make it a perfect circle
                            image: DecorationImage(
                              fit: BoxFit.cover, // Fill the entire container
                              image: CachedNetworkImageProvider(
                                  controller.main_image.value),
                            ),
                          ),
                        ),
                        index == -1 && controller.isWaitingForResponse.value
                            ? Container()
                            : index == -1
                                ? controller.chatList[index + 1].isVoiceResponse
                                    ? Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black38),
                                        child: IconButton(
                                            onPressed: () {
                                              developer.log(
                                                  "message ${controller.chatList[index].message}");
                                              developer.log(
                                                  "${controller.gender_male.value}");
                                              controller.playTextMessageSpeech(
                                                  controller
                                                      .chatList[index].message,
                                                  index);
                                            },
                                            icon: controller.isSpeaking.value &&
                                                    index ==
                                                        controller
                                                            .selectedIndex.value
                                                ? Icon(Icons.pause)
                                                : Icon(
                                                    Icons.play_arrow_rounded)))
                                    : Container()
                                : controller.chatList[index].isVoiceResponse
                                    ? Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black38),
                                        child: IconButton(
                                            onPressed: () {
                                              developer.log(
                                                  "message ${controller.chatList[index].message}");
                                              developer.log(
                                                  "${controller.gender_male.value}");
                                              if (controller.isSpeaking.value) {
                                                controller
                                                    .stopTextMessageSpeech();
                                              } else {
                                                controller
                                                    .playTextMessageSpeech(
                                                        controller
                                                            .chatList[index]
                                                            .message,
                                                        index);
                                              }
                                            },
                                            icon: controller.isSpeaking.value &&
                                                    index ==
                                                        controller
                                                            .selectedIndex.value
                                                ? Icon(Icons.pause)
                                                : Icon(
                                                    Icons.play_arrow_rounded)))
                                    : Container()
                      ],
                    )
              // Icon(
              //   CupertinoIcons.rocket,
              //   size: SizeConfig.blockSizeHorizontal * 11,
              //   color: Colors.teal,
              // ),
            ],
            Column(
              crossAxisAlignment: isSender
                  ? message.length <= 30
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  width: message.length <= 50
                      ? null
                      : SizeConfig.screenWidth * 0.8,
                  margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeVertical * 0.5,
                      horizontal: SizeConfig.blockSizeHorizontal * 1),
                  decoration: BoxDecoration(
                    color: isSender
                        ? Colors.lightBlue
                        : const Color.fromARGB(255, 41, 63, 75),
                    // gradient: !isSender
                    //     ?
                    //     LinearGradient(
                    //         begin: Alignment.topLeft,
                    //         end: Alignment.bottomRight,
                    //         colors: [
                    //             Color.fromARGB(255, 43, 42, 42),
                    //             Color(0xFF0D0D0D),
                    //           ])
                    //     : LinearGradient(
                    //         begin: Alignment.topLeft,
                    //         end: Alignment.bottomRight,
                    //         colors: [
                    //             //? User Gradiant
                    //             Color.fromARGB(255, 41, 40, 40),
                    //             Color.fromARGB(255, 85, 85, 85),
                    //           ]),
                    // color: isSender
                    //     ? null
                    //     : Color
                    //         .fromARGB(
                    //             137,
                    //             34,
                    //             33,
                    //             33),
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 6),
                  ),
                  padding: EdgeInsets.only(
                    right: SizeConfig.blockSizeHorizontal * 4,
                    left: SizeConfig.blockSizeHorizontal * 4,
                    top: SizeConfig.blockSizeVertical * 2,
                    bottom: SizeConfig.blockSizeVertical * 2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   message.sender,
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      // ),
                      // SizedBox(
                      //     height: SizeConfig.blockSizeVertical * 1),
                      Align(
                        alignment: isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: index == -1 &&
                                controller.isWaitingForResponse.value
                            // true
                            ? _typingIndicator()
                            :
                            // MarkdownWidget(
                            //     data: controller.chatList[index].message,
                            //   )
                            controller.chatList[index].isVoiceResponse &&
                                    controller.chatList[index].senderType ==
                                        SenderType.Bot
                                ? HighlightedMessage(
                                    message: message,
                                    start:
                                        controller.startIndexSpokenWord.value,
                                    end: controller.endIndexSpokenWord.value,
                                    selectedIndex:
                                        controller.selectedIndex.value,
                                    index: index,
                                  )
                                : Text(
                                    controller.chatList[index].message,
                                    style: TextStyle(color: Colors.white),
                                  ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // width: SizeConfig.screenWidth,
                  // color: Colors.red,
                  margin: EdgeInsets.symmetric(
                      // vertical: SizeConfig.blockSizeVertical * 1,
                      horizontal: SizeConfig.blockSizeHorizontal * 5),
                  child: Row(
                    mainAxisAlignment: isSender
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          padding: EdgeInsets.zero,
                          color: Colors.white,
                          tooltip: "Share",
                          onPressed: () {
                            controller.ShareMessage(
                                controller.chatList[index].message);
                          },
                          icon: Icon(Icons.share)),
                      // horizontalSpace(SizeConfig.blockSizeHorizontal*2),
                      IconButton(
                          padding: EdgeInsets.zero,
                          color: Colors.white,
                          tooltip: "Copy",
                          onPressed: () {
                            controller.CopyMessage(
                                controller.chatList[index].message);
                          },
                          icon: Icon(
                            Icons.copy_rounded,
                            size: iconSize,
                          )),

                      !isSender && !(isFeedback && !isGood)
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              color: Colors.white,
                              tooltip: "Good",
                              onPressed: () {
                                if (!isFeedback) {
                                  controller.GoodResponse(
                                      controller.chatList[index].message,
                                      index);
                                }
                              },
                              icon: Icon(
                                isFeedback && isGood
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_alt_outlined,
                                size: iconSize,
                              ))
                          : Container(),
                      !isSender && !(isFeedback && isGood)
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              color: Colors.white,
                              tooltip: "Bad Response",
                              onPressed: () {
                                if (!isFeedback) {
                                  controller.reportMessage(
                                      Get.context!,
                                      controller.chatList[index].message,
                                      index);
                                }
                              },
                              icon: Icon(
                                isFeedback && !isGood
                                    ? Icons.thumb_down
                                    : Icons.thumb_down_alt_outlined,
                                size: iconSize,
                              ))
                          : Container(),
                      // horizontalSpace(SizeConfig.blockSizeHorizontal*2),
                      //   IconButton(
                      //     padding: EdgeInsets.zero,

                      //     onPressed: (){}, icon:Icon(Icons.share))
                      // ,
                      // horizontalSpace(SizeConfig.blockSizeHorizontal*2),
                    ],
                  ),
                )
              ],
            ),
            if (isSender) ...[
              Icon(
                CupertinoIcons.person_crop_circle,
                size: SizeConfig.blockSizeHorizontal * 10,
                color: Color.fromARGB(255, 137, 137, 137),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _typingIndicator() {
    print("Type Indicator..");
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _animatedDot(0),
          SizedBox(width: 8.0),
          _animatedDot(1),
          SizedBox(width: 8.0),
          _animatedDot(2),
        ],
      ),
    );
  }

  Widget _animatedDot(int index) {
    return AnimatedBuilder(
      animation: controller.typingAnimation!,
      builder: (context, child) {
        return Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 0
                ? Colors.white
                : controller.typingAnimation!.value < (index / 3)
                    ? Colors.white.withOpacity(0.3)
                    : Colors.white,
          ),
        );
      },
    );
  }
}

class HighlightedMessage extends StatelessWidget {
  final String message;
  final int start;
  final int end;
  final int selectedIndex;
  final int index;

  const HighlightedMessage({
    Key? key,
    required this.message,
    required this.start,
    required this.end,
    required this.selectedIndex,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((start < 0 || end > message.length || start >= end) ||
        selectedIndex != index) {
      // Fallback in case indices are invalid
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white,
            height: 1.5,
          ),
          text: message,
        ),
      );
    }

    final String before = message.substring(0, start);
    final String word = message.substring(start, end);
    final String after = message.substring(end);
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.white,
          height: 1.5, // Adjust this to your desired line spacing
        ),
        children: [
          TextSpan(text: before),
          TextSpan(
            text: word,
            style: const TextStyle(
              color: Colors.lightBlueAccent,
              fontWeight: FontWeight.bold,
              // color: Colors.black,
            ),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}
