import 'dart:developer';
// import 'dart:io';
import 'package:character_ai_delta/app/modules/controllers/new_gf_chat_ctl.dart';
import 'package:character_ai_delta/app/provider/applovin_ads_provider.dart';
import 'package:character_ai_delta/app/provider/meta_ads_provider.dart';
import 'package:character_ai_delta/app/services/revenuecat_service.dart';
import 'package:character_ai_delta/app/utills/images.dart';
import 'package:character_ai_delta/app/utills/style.dart';
// import 'package:flutter_highlight/themes/a11y-light.dart';
// import 'package:applovin_max/applovin_max.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

// import 'package:lottie/lottie.dart';
// import 'package:markdown_widget/markdown_widget.dart';
// import 'package:markdown_widget/widget/markdown.dart';

import '../../routes/app_pages.dart';
import '../../utills/colors.dart';
import '../../utills/size_config.dart';
// import '../controllers/gf_chat_view_controller.dart';
// import '../controllers/chat_view_ctl.dart';

class NewGfChatView extends GetView<NewGfChatCtl> {
    final List<dynamic> arguments;
  const NewGfChatView({super.key, required this.arguments});
  @override
void initializeView(){
    Get.put<NewGfChatCtl>(
      NewGfChatCtl(
        aiChatModel: aiChatModel,
        firebaseCharacter: firebaseCharecter,
      ),);
}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        log("backed");
        final FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          // If no widget has focus, close the keyboard (optional)
          FocusManager.instance.primaryFocus?.unfocus();
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
          return true; // Allow back navigation
        }
      },
      child: Scaffold(
          backgroundColor: AppColors.ScaffoldColor,
          body: Obx(
            () => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      CachedNetworkImageProvider(controller.main_image.value),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Obx(() => Container(
                  //       width: SizeConfig.screenWidth,
                  //       height: SizeConfig.screenHeight,
                  //       child: CachedNetworkImage(
                  //           imageUrl: controller.main_image.value),
                  //     )),
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
                                              SizeConfig.blockSizeVertical * 14,
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
        // height: Get.statusBarHeight * SizeConfig.blockSizeVertical * 20,
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
                          AppLovinProvider.instance
                              .showInterstitial(() {}, false);
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
                  Obx(() => GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.GemsView);
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.gems,
                              scale: 30,
                            ),
                            Text(
                              " ${controller.homectl.gems.value}",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.03,
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
            AppLovinProvider.instance.ShowBannerWidget(),
            Container(
              // margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 0.1),
              child: Text(
                "Note: This is AI Generated Connent",
                style: StyleSheet.noteHeading,
              ),
            ),
            verticalSpace(SizeConfig.blockSizeVertical)
          ],
        ),
      ),
    );
  }

  Widget _InputField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0D0D0D),
        border: Border.all(
          color: Color.fromARGB(255, 43, 42, 42), // Set the border color here
          width: 1.0, // Set the border width here
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),

      // ),
      child: Container(
        // color: Colors.red,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 3,
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

                        border: InputBorder.none, // Remove the border
                        counterStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          onPressed: () {
                            print(
                                "Send Message ${controller.textEditingController.text}");
                            if (!controller.wait.value) {
                              if (controller
                                  .textEditingController.text.isNotEmpty) {
                                controller.isWaitingForResponse.value = true;
                                // ? Commented by jamal start
                                controller.sendMessage(
                                    "${controller.textEditingController.text}",
                                    context);
                                //// ? Commented by jamal end
                                controller.lastMessage.value =
                                    controller.textEditingController.text;
                                controller.textEditingController.clear();
                              }
                            }
                          },
                          icon: Icon(
                            Icons.send,
                            color: Color(0xEEF37B38),
                            // Color(
                            //     0xFF25D366)
                          ), // WhatsApp send button icon
                        )
                        // :
                        // Container()

                        ,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                  ? Container(
                      height: SizeConfig.blockSizeHorizontal * 10,
                      width: SizeConfig.blockSizeHorizontal * 10,
                      // margin: EdgeInsets.only(
                      //     top: SizeConfig.blockSizeVertical * 10
                      //     ),
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
                    )
                  : Container(
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
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  width: message.length <= 30
                      ? null
                      : SizeConfig.screenWidth * 0.8,
                  margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeVertical * 0.5,
                      horizontal: SizeConfig.blockSizeHorizontal * 1),
                  decoration: BoxDecoration(
                    gradient: !isSender
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                                Color.fromARGB(255, 43, 42, 42),
                                Color(0xFF0D0D0D),
                              ])
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                                //? User Gradiant
                                Color.fromARGB(255, 41, 40, 40),
                                Color.fromARGB(255, 85, 85, 85),
                              ]),
                    // color: isSender
                    //     ? null
                    //     : Color
                    //         .fromARGB(
                    //             137,
                    //             34,
                    //             33,
                    //             33),
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 4),
                  ),
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
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
                        child:
                            index == -1 && controller.isWaitingForResponse.value
                                // true
                                ? _typingIndicator()
                                :
                                // MarkdownWidget(
                                //     data: controller.chatList[index].message,
                                //   )
                                Text(
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
                color: Color.fromARGB(255, 41, 40, 40),
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
