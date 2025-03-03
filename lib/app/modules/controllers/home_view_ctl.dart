import 'dart:developer' as dp;
import 'dart:io';
import 'dart:math';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:character_ai_delta/app/data/ai_model.dart';
import 'package:character_ai_delta/app/data/firbase_charecters.dart';
import 'package:character_ai_delta/app/data/firebase_categories.dart';
import 'package:character_ai_delta/app/notificationservice/local_notification_service.dart';
import 'package:character_ai_delta/app/provider/applovin_ads_provider.dart';
import 'package:character_ai_delta/app/provider/meta_ads_provider.dart';
import 'package:character_ai_delta/app/routes/app_pages.dart';
import 'package:character_ai_delta/app/utills/app_const.dart';
import 'package:character_ai_delta/app/utills/app_strings.dart';
import 'package:character_ai_delta/app/utills/gems_rate.dart';
import 'package:character_ai_delta/app/utills/images.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:character_ai_delta/main.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_rating_dialog/slide_rating_dialog.dart';

class HomeViewCTL extends GetxController {
  Rx<String> feedbackMessage = "".obs;
  String recipient = "codewithsherry@gmail.com";
  RxInt current_index = 0.obs;
  RxList<AIChatModel> chatBotPremium = <AIChatModel>[].obs;
  RxList<AIChatModel> chatBotfree = <AIChatModel>[].obs;
  RxList<AIChatModel> chatBotAvatar = <AIChatModel>[].obs;
  // ScrollController scrollController = ScrollController();
  // CarouselController carouselController = CarouselController();
  // NavCTL navCTL = Get.find(); // ? Commented by jamal
  RxBool gender_male = true.obs;
  int count = 0;
  int initialGems = GEMS_RATE.FREE_GEMS;
  int adCounter = 3;
  RxInt gems = 0.obs;
  bool? firstTime = false;
  String? conversationID;
  String prompt = "give me one prompt for today";
  RxBool promptRecieved = false.obs;
  RxBool isAdReady = false.obs;
  // final RxInt? counter = prefs.getInt('counter');
  // RxInt Gems = 0.obs;

  // RxInt gems = 0.obs;

  // bool firstBoot = true;
  // RxBool premiumUser = false.obs;
  late OpenAI openAi;

  late final user;
  static var name = "";
  Rx<FirebaseCatagory> FBselectedCatagory = FirebaseCatagory(id: "All").obs;
  RxString title = "Today's Prompt".obs;
  String? uniqueId;
  static List<String> text = [
    "Hi",
    // "$name",
    "How are you?",
    // "Wanna talk?",
    "Let's Create Unforgettable Moments",
    "Tap HERE",
  ];

  Rx<String> selectedCategory = "All".obs;

  int reviewCounter = 30;

  // bool? firstTime = false;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    print("object tooken: ${AppStrings.OPENAI_TOKEN}");
    print("object tooken: ${AppStrings.HOTPOT_API}");

    CheckUser().then((value) {
      getGems();
    });

    openAi = OpenAI.instance.build(
      token: AppStrings.OPENAI_TOKEN,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 20),
        connectTimeout: const Duration(seconds: 20),
      ),
      enableLog: true,
    );
    bool isFirstLaunch = box.read('first_launch') == "false" ? false : true;
    dp.log("box.read value ${box.read('first_launch')}");
    if (isFirstLaunch || kDebugMode) {
      showOverlay1.value = true;
    }

    assignUniqueId();
    handlePushNotification();
  }

  List<Messages> conversation = [];
  RxBool isWaitingForResponse = false.obs;
  RxList<ChatMessage> chatList = <ChatMessage>[].obs;
  final box = GetStorage(); // GetStorage for persistent data
  Rx<bool> showOverlay1 = false.obs;
  Rx<bool> showOverlay2 = false.obs;
  final CarouselSliderController carouselController =
      CarouselSliderController();
  Rx<FirebaseCharecter> firstCharacter = FirebaseCharecter(
          title: "none",
          description: " description",
          firstMessage: "firstMessage",
          intro: "intro",
          category: "category",
          imageUrl: "imageUrl",
          historyMessages: "historyMessages")
      .obs;
  Rx<int> delayTimer = 15.obs;
  Rx<bool> isShowOverlay3 = false.obs;
  Rx<bool> isTransparent = false.obs;
  Rx<bool> hintButtonPressed = false.obs;

  void dismissOverlay1() {
    box.write('first_launch', "false"); // Save that guide has been seen
    dp.log("box.read value after set ${box.read('first_launch')}");
    showOverlay1.value = false;
    showOverlay2.value = true;
    animateSlideEffect();
  }

  void dismissOverlay2() {
    showOverlay2.value = false;
    if (!hintButtonPressed.value) {
      AIChatModel aiChatModel = AIChatModel(
          firstCharacter.value.title,
          [firstCharacter.value.firstMessage],
          firstCharacter.value.imageUrl,
          false,
          firstCharacter.value.description,
          Routes.GfChatView,
          mainContainerType.avatar,
          firstCharacter.value.historyMessages,
          firstCharacter.value.category);

      String history = firstCharacter.value.historyMessages ?? "";
      print("Firebase History: $history");
      openAvatarChat(aiChatModel, firstCharacter.value);
      if (adCounter == 3) {
        adCounter = 1;
        if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
          MetaAdsProvider.instance.showInterstitialAd();
        } else {
          AppLovinProvider.instance.showInterstitial(() {}, false);
        }
      } else {
        adCounter++;
      }
    }
  }

  void animateSlideEffect() async {
    Rx<bool> isFirstTime = true.obs;
    while (showOverlay2.value || isShowOverlay3.value) {
      print(
          "isFirstTime variable inside animateSlideEffect ${isFirstTime.value}");
      isFirstTime.value
          ? await Future.delayed(Duration(milliseconds: 200))
          : await Future.delayed(Duration(milliseconds: 1080));
      carouselController.nextPage(
          duration: Duration(milliseconds: 600), curve: Curves.easeOut);
      await Future.delayed(Duration(milliseconds: 250));
      carouselController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      isFirstTime.value = isFirstTime.value ? false : false;
    }
    if (!showOverlay2.value && !hintButtonPressed.value) {
      carouselController.jumpToPage(0);
    }
  }

  animationsInitializer(List<FirebaseCharecter> characters) {
    // -----------Temp commented untill app is published --Rizwan-------------
    characters.forEach((character) {
      if (character.animationUrl != "") {
        CachedVideoPlayerPlusController.networkUrl(
            Uri.parse(character.animationUrl!))
          ..initialize().then((_) {
            update();
          });
      }
      ;
    });
  }

  Future promptOfTheDay(String message) async {
    bool result = await InternetConnectionChecker().hasConnection;
    // print("credits:${request_limit.value}");
    if (message.isNotEmpty && result == true) {
      // if (message.isNotEmpty) {
      // wait.value = true;
      // final userMessage = {"role": "user", "content": message};
      final userMessage = Messages(role: Role.user, content: message);

      conversation.add(userMessage);

      // userMessages.add(message);

      final request = ChatCompleteText(
        messages: conversation,
        maxToken: AppStrings.MAX_CHAT_TOKKENS,
        // model: ChatModel.gptTurbo0301,
        model: GptTurbo0301ChatModel(),
      );

      try {
        final response = await openAi.onChatCompletion(request: request);

        for (var element in response!.choices) {
          print("data -> ${element.message?.content}");
          print("dataID -> ${element.id}");
          isWaitingForResponse.value = false;
        }

        print("ConversationalID: ${response.conversionId}");
        print("ConversationalID: ${response.id}");

        if (response.choices.isNotEmpty &&
            response.choices.first.message != null) {
          conversationID = response.choices.first.message!.id;
        }

        ChatMessage messageReceived = ChatMessage(
            senderType: SenderType.Bot,
            message: response.choices[0].message!.content,
            input: message);
        // EasyLoading.dismiss();
        //
        // String originalString = messageReceived.input;
        // String removeString = limit;
        // messageReceived.input = originalString.replaceFirst(removeString, '');

        //

        chatList.insert(0, messageReceived);
      } catch (err) {
        isWaitingForResponse.value = false;
        // EasyLoading.dismiss();
        // EasyLoading.showError("Something Went Wrong");
        if (err is OpenAIAuthError) {
          print('OpenAIAuthError error ${err.data?.error?.toMap()}');
        }
        if (err is OpenAIRateLimitError) {
          print('OpenAIRateLimitError error ${err.data?.error?.toMap()}');
        }
        if (err is OpenAIServerError) {
          print('OpenAIServerError error ${err.data?.error?.toMap()}');
        }
      }
    }
  }

  chatBotdata() {
    print("ChatBot Data: $chatBotfree");
  }

  increaseGEMS(int increase) async {
    print("value: $increase");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    gems.value = gems.value + increase;
    await prefs.setInt('gems', gems.value);
    print("inters");
    getGems();
  }

  decreaseGEMS(int decrease) async {
    print("value: $decrease");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    gems.value = gems.value - decrease;
    if (gems.value < 0) {
      gems.value = 0;
      await prefs.setInt('gems', gems.value);
    } else {
      await prefs.setInt('gems', gems.value);
    }

    print("inters");
    getGems();
  }

  Future<int> getGems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      gems.value = prefs.getInt('gems') ?? 100;
    } else {
      gems.value = prefs.getInt('gems') ?? GEMS_RATE.FREE_GEMS;
    }
    print("GEMS value: ${gems.value}");
    return gems.value;
  }

  Future CheckUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstTime = prefs.getBool('first_time');

    // var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime!) {
      // Not first time
      gems.value = prefs.getInt('gems') ?? initialGems;
      print("Not First time");
      print("${firstTime}");
      //     Timer(Duration(seconds: 3), () {
      //       // CheckUser();
      //       // AppLovinProvider.instance.init();
      //       Get.offNamed(Routes.NAV,arguments: false);
      // });
    } else {
      // First time
      prefs.setBool('first_time', false);
      print("First time");
      print("${firstTime}");
      await prefs.setInt('limit', 5);
      await prefs.setInt('mathLimit', 3);
      await prefs.setInt('gems', initialGems).then((value) {
        gems.value = prefs.getInt('gems')!;
      });
    }
  }

  void openAvatarChat(
      AIChatModel textSuggestion, FirebaseCharecter firebaseCharecter) {
    // GfChatViewController gfChatViewController = Get.find();
    // gfChatViewController.initData(textSuggestion);
    current_index.value = 1;
    Get.toNamed(textSuggestion.route,
        arguments: [textSuggestion, firebaseCharecter]);
  }

  //? Firebase Implementation

  Stream<QuerySnapshot> get categoriesStream {
    return FirebaseFirestore.instance
        .collection(APPConstants.CharecterCollection)
        .doc(APPConstants.CatagoriesCollection)
        .collection('categories')
        .snapshots();
  }

  Future<void> assignUniqueId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uniqueId = prefs.getString('uniqueId');

    if (uniqueId == null) {
      // Generate a random unique ID
      uniqueId =
          '${Random().nextInt(900000) + 100000}'; // 6-digit random number

      print("UniqueID: $uniqueId");
      // Persist the unique ID in SharedPreferences
      await prefs.setString('uniqueId', uniqueId!);
    }
  }

  handlePushNotification() async {
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> showReviewDialogue(BuildContext context) async {
    dp.log("showReviewDialogue");

    int finalRating = 4;
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isReviewed = pref.getBool("isReviewed") ?? false;

    if (isReviewed) {
      ShowFeedbackBottomSheet();

      return;
    }

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext cont) => SlideRatingDialog(
              onRatingChanged: (rating) {
                print(rating.toString());
                finalRating = rating;
              },
              buttonOnTap: () async {
                final _inAppReview = InAppReview.instance;
                if (finalRating >= 3) {
                  // Review on PlayStore
                  // LaunchReview.launch(
                  //   androidAppId: "chat.ai.chatbot.aichat",
                  // );
                  if (isReviewed) {
                    Get.snackbar("Thanks",
                        "The submission of your review has already been completed.",
                        snackStyle: SnackStyle.FLOATING,
                        backgroundColor: Colors.white,
                        colorText: Colors.black);
                  } else {
                    if (await _inAppReview.isAvailable()) {
                      print('request actual review from store');
                      _inAppReview.requestReview();
                    } else {
                      print('open actual store listing');
                      // TODO: use your own store ids
                      _inAppReview.openStoreListing(
                        appStoreId: 'character.avatar.ai.app.novax',
                        // microsoftStoreId: '<your microsoft store id>',
                      );
                      // reviewCount = 0;
                      pref.setBool("isReviewed", true);
                    }
                  }
                  Get.back();

                  await storeReviewCount(finalRating);
                  EasyLoading.showSuccess("Thanks for the Rating");
                } else {
                  Get.back();

                  //? Store Review on Firebase
                  await storeReviewCount(finalRating);
                  EasyLoading.showSuccess("Thanks for the Rating");
                }
                // Do your Business Logic here;
              },
            ));
  }

  Future<void> storeReviewCount(int rating) async {
    final firestore = FirebaseFirestore.instance;
    final ratingDocRef = firestore.collection('Rating').doc(rating.toString());

    // Use a transaction to ensure data consistency
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ratingDocRef);
      if (!snapshot.exists) {
        transaction
            .set(ratingDocRef, {'count': 0}); // Create with initial count
      }
      transaction.update(ratingDocRef, {'count': FieldValue.increment(1)});
    });
  }

  int feedBackCount = 10;
  Future<void> ShowFeedbackBottomSheet({bool fromSettings = false}) async {
    dp.log("ShowBottomSheetCalled..");
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isFeedback = pref.getBool("isFeedbackGiven") ?? false;

    if (isFeedback) return;
    if (feedBackCount >= 5 || fromSettings) {
      Future.delayed(Duration(seconds: 0), () {
        feedBackCount = 0;

        Get.bottomSheet(Container(
          height: SizeConfig.blockSizeVertical * 60,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
              color: Theme.of(Get.context!).colorScheme.background,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 3),
                  topRight:
                      Radius.circular(SizeConfig.blockSizeHorizontal * 3))),
          child: Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.feedback,
                        scale: 14,
                      ),
                      Text(
                        "Rate your experience",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 5,
                            color: Theme.of(Get.context!).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      Image.asset(
                        AppImages.feedback,
                        scale: 14,
                      ),
                    ],
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image.asset(
                        //   AppImages.feedback,
                        //   scale: 10,
                        // ),
                        Text(
                          "Note: ",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 5,
                              color: Theme.of(Get.context!).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 75,
                          child: Text(
                            "We consider your feedback very seriously and will try to improve the app according to your feedback ",
                            softWrap: true,
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 4,
                                color:
                                    Theme.of(Get.context!).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  // feedback_field(
                  //     context, "Recipient", controller.recipient),
                  // verticalSpace(SizeConfig.blockSizeVertical * 1),
                  // feedback_field(context, "Subject", controller.subject),
                  // verticalSpace(SizeConfig.blockSizeVertical * 1),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 95,
                    height: SizeConfig.blockSizeVertical * 25,
                    child: TextField(
                      cursorColor: Theme.of(Get.context!).colorScheme.primary,
                      onChanged: (value) => feedbackMessage.value = value,

                      textAlignVertical: TextAlignVertical.top,

                      textAlign: TextAlign.left,
                      expands: true,
                      maxLines: null,

                      // controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 2),
                        ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(),
                        //   borderRadius: BorderRadius.circular(
                        //       SizeConfig.blockSizeHorizontal * 2),
                        // ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(Get.context!).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 2),
                        ),
                        // labelText: 'Name',
                        // labelStyle: TextStyle(color: Colors.blue),
                        hintText: "Add your feedback",
                        hintStyle: TextStyle(color: Colors.grey),
                        // prefixIcon:
                        //     Icon(Icons.text_fields, color: Colors.blue),
                        // suffixIcon:
                        //     Icon(Icons.check_circle, color: Colors.green),
                        filled: true,
                        fillColor: Theme.of(Get.context!).colorScheme.secondary,
                        // contentPadding: EdgeInsets.symmetric(
                        //   vertical: SizeConfig.blockSizeVertical * 10,
                        //   horizontal: SizeConfig.blockSizeHorizontal * 2,
                        // ),
                      ),
                    ),
                  ),

                  verticalSpace(SizeConfig.blockSizeVertical * 2),
                  GestureDetector(
                    onTap: () {
                      sendFeedBackEmail(feedbackMessage.value).then((value) {
                        pref.setBool("isFeedbackGiven", true);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: SizeConfig.blockSizeVertical * 1),
                      height: SizeConfig.blockSizeVertical * 5.5,
                      width: SizeConfig.blockSizeHorizontal * 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 3,
                          ),
                          gradient: LinearGradient(
                              colors: [Colors.indigo, Colors.indigoAccent],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
      });
    } else {
      feedBackCount++;
    }
  }

  Future<void> sendFeedBackEmail(String message) async {
    final Email email = Email(
      recipients: [recipient],
      subject: "Chare AI Feedback",
      body: message,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
      // showReviewDialogue(Get.context!);
    } catch (error) {
      // showReviewDialogue(Get.context!);

      platformResponse = error.toString();

      dp.log("Feedback Email Error: ${platformResponse}");
    }

    try {
      sendFirebaseFeedback(message);
      platformResponse = 'success';
      feedBackCount = 0;
    } catch (error) {
      platformResponse = error.toString();
      dp.log("Feedback Email Error: ${platformResponse}");
    }

    // Get.snackbar('Email Sender', platformResponse);
  }

  Future<void> sendFirebaseFeedback(message) async {
    // Firestore storage
    final feedbackCollection =
        FirebaseFirestore.instance.collection('feedback');
    final docID = "${DateTime.now().millisecondsSinceEpoch}}";
    final feedbackDocRef = await feedbackCollection.doc(docID);
    feedbackDocRef.set({
      'message': message,
      'timestamp':
          FieldValue.serverTimestamp(), // Automatically generated timestamp
    });

    // Handle success or error
    if (feedbackDocRef.id != null) {
      print('Feedback submitted successfully!');
    } else {
      print('Error submitting feedback.');
    }
  }

  String formateNumberShort(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}m';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    } else {
      return number.toString();
    }
  }
}

enum SenderType {
  User,
  Bot,
}

class ChatMessage {
  SenderType senderType;
  String message;
  String input;

  ChatMessage(
      {required this.senderType, required this.message, required this.input});
}
