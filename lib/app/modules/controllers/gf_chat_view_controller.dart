import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:character_ai_delta/app/data/ai_model.dart';
import 'package:character_ai_delta/app/data/db_message.dart';
import 'package:character_ai_delta/app/data/firbase_charecters.dart';
import 'package:character_ai_delta/app/data/firebase_chat_history.dart';
import 'package:character_ai_delta/app/modules/controllers/home_view_ctl.dart';
import 'package:character_ai_delta/app/provider/chathistory_dbHelper.dart';
import 'package:character_ai_delta/app/utills/app_const.dart';
import 'package:character_ai_delta/app/utills/app_strings.dart';
import 'package:character_ai_delta/app/utills/gems_rate.dart';
import 'package:character_ai_delta/app/utills/images.dart';
import 'package:character_ai_delta/app/utills/remoteConfigVariables.dart';
import 'package:character_ai_delta/app/utills/style.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

// import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../routes/app_pages.dart';
import '../../utills/colors.dart';
import '../../utills/size_config.dart';

class GfChatViewController extends GetxController
    with GetTickerProviderStateMixin {
  RxList<ChatMessage> chatList = <ChatMessage>[].obs;
  // NavCTL navCTL = Get.find(); // ? Commented by jamal
  RxBool isOnline = false.obs;
  // String limit =
  //     " (act as if your are my girlfriend, also use emoji in the response and try to make response under 100 words)";
  String limit =
      " (act as if you are my firend and try to use emojis if needed)  never tell that you are from open ai tell your name Socratic if needed";

  List<Map<String, dynamic>> chatTrainingHistiry = <Map<String, String>>[];
  // RxList<String> userMessages = <String>[].obs;
  RxBool wait = false.obs;
  TextEditingController textEditingController = TextEditingController();
  RxBool isWaitingForResponse = false.obs;
  String? conversationID;
  // RxInt request_limit = 0.obs;
  late OpenAI openAi;
  StreamSubscription? subscription;
  RxBool gender_male = true.obs;
  RxString gender_title = "".obs;
  RxString main_image = AppImages.AlbertEinstein.obs; // ?
  RxBool islistening = false.obs;
  RxBool userIsTyping = false.obs;
  late AnimationController animationController;
  Animation<double>? typingAnimation;
  RxString lastMessage = ''.obs;
  int initialGems = 20;
  RxInt gems = 0.obs;
  RxInt current_index = 0.obs;
  bool? firstTime = false;

  HomeViewCTL homectl = Get.find();

  RxBool showAvatar = true.obs;
  RxString avatar = "".obs;
  AIChatModel myAIChatModel = AIChatModel("name", [], "image", true,
      "discription", "route", mainContainerType.normal, "history", "category");

  List<DBMessage> dbMessages = [];

  Rx<bool> isLoved = false.obs;
  FirebaseCharecter? firebaseCharecter;

  List<String> dummyAiBotChatList = [
    "Hey there! 😊 How's your day going?",
    "Hello! I've been looking forward to talking to you. How are you feeling today?",
    "Hi! Hope you're having a fantastic day! 😄 What's been keeping you busy lately?",
    "Hey, it's great to see you! How's everything in your world today?",
    "Hello! I'm excited to chat with you. What's on your mind?",
    "Greetings! How's your day unfolding so far? Anything exciting happening?",
    "Hi there! Ready to dive into a conversation. How's life treating you today?",
    // "Hi, love! I hope you're doing well. What's on your mind?",
    // "Hey sweetheart! I've missed chatting with you. What's new in your world?",
    // "Hi, my love! I've been thinking about you. How has your day been so far?",
    // "Hello, my dear! I'm here to brighten your day. What's been making you smile lately?",
    // "Hey, handsome/beautiful! I hope you're having an amazing day. What's the best part of your day so far?",
    // "Hi, sweetheart! 😘 I'm here to make your day even better. What's on your agenda today?",
  ];

  RxList<String> feedbackMessages = <String>[].obs;
  // AnimationController animationController;
  // Animation<double>? typingAnimation;
  List<String> errorMessages = [
    "I'm currently swamped, can we chat later?",
    "At this moment, I am attending to other requests. Please be patient and I'll get back to you soon.",
    "Hold on tight, I'm experiencing a high volume of inquiries right now. I'll respond as soon as possible.",
    "Looks like I'm in high demand! I'll circle back to you shortly.",
    "I'm running a bit behind schedule. Can we connect in a few moments?"
  ];

  List<String> denielMessages = [
    "Sorry, I'm unable to reply to this. Try something else.", // Original message
    "That's beyond my current capabilities. Perhaps I can help with something else?", // Added message
    "I apologize, I'm not able to assist with that right now. Is there anything else I can do?", // Added message
    "It seems I'm having some trouble understanding. Let's try a different question.", // Added message
    "My brain is a bit fuzzy right now. Can you ask me something easier?", // Added message
    "Uh oh, seems like I hit a snag. Maybe rephrasing your question will help?", // Added message
  ];

  List<String> Therapist_denielMessages = [
    "In the middle of a session right now, but I'd be happy to chat later! Can you send me a message to remind me?", // Original message
    "Currently with another client, confidentiality first! Let's talk after my session.", // Added message
    "Sipping my coffee and taking a break! Can we chat after I recharge?", // Added message
    "Fueling up for the afternoon. How about we connect later?", // Added message
    "Deep in some research for an upcoming session. Can this wait until later?", // Added message
    "Brushing up on some materials for a client. Mind following up later?", // Added message
    "My schedule is a bit hectic right now. Can we reconnect when things settle down?",
    "Caught in a whirlwind at the moment. Let's talk when I have a chance to breathe!",
    "It seems I'm unavailable to assist right now. Perhaps scheduling a dedicated time would work best?",
    "That's a fascinating topic! Let's schedule a dedicated session to delve deeper when I'm free.",
    "Ooh, spicy! That sounds like a conversation we need to have. Let's find a time on the calendar to unpack it all.",
    "Now that's a question that sparks my professional interest! How about we schedule a session to explore this further, discreetly of course ;)",
    "Interesting! That question actually ties into something else we discussed previously. Let's schedule a session to see how it all fits together"
  ];

  //? Official Package
  late final GenerativeModel _model;
  late ChatSession _chat;
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;

  RxBool isRecording = false.obs;
  Rx<Color> recordButtonColor = Colors.lightBlueAccent.obs;
  RxBool isRecordingCanceled = false.obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  void handleAppMinimized() {
    developer.log("App is minimized. Performing action...");
    // Perform your action here
    stopTextMessageSpeech();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    // animationController.dispose();
    // typingAnimation!.dispose();
    textEditingController.dispose();
    speechToText.stop();
    speechToText.cancel();
    recordedString.value = '';

    typingAnimation!.removeListener(() {});
    animationController.dispose();
    textFieldFocusNode.dispose();
    if (isVideoControllerInitialized.value) {
      videoController.dispose();
    }

    homectl.ShowFeedbackBottomSheet();
    super.onClose();
  }

  Toster() {
    Fluttertoast.showToast(
        msg: "Listening....",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  RxBool TextScanning = false.obs;
  XFile? ImageFile;
  RxString ScannedText = "".obs;

  RxBool showScannedText = false.obs;

  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  double level = 0.0;

  RxBool premiumUser = false.obs;
  FocusNode textFieldFocusNode = FocusNode();

  RxString mainImage = ''.obs;
  RxBool showVideo = false.obs;
  late CachedVideoPlayerPlusController videoController;
  RxBool isVideoControllerInitialized = false.obs;

  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String speechText = '';
  RxString recordedString = ''.obs;
  late BuildContext inputFieldContext;
  FlutterTts flutterTts = FlutterTts();
  RxBool isSpeaking = false.obs;
  RxInt selectedIndex = 0.obs;
  RxInt startIndexSpokenWord = 0.obs;
  RxInt endIndexSpokenWord = 0.obs;

  void initializeVideo(String videoUrl) {
    isVideoControllerInitialized.value = false;
    if (videoUrl.isNotEmpty) {
      showVideo.value = true;
      videoController =
          CachedVideoPlayerPlusController.networkUrl(Uri.parse(videoUrl))
            ..initialize().then((_) {
              isVideoControllerInitialized.value = true;
              videoController.play();
              update();
            });

      videoController.addListener(() {
        if (videoController.value.position >= videoController.value.duration) {
          isVideoControllerInitialized.value = false;
          showVideo.value = false;
          update();
        }
      });
    } else {
      showVideo.value = false;
    }
  }

  Future playTextMessageSpeech(String message, int selectedIndexSetter) async {
    // flutterTts.setVoice({"name": "ur-pk-x-cfn-local", "locale": "ur-PK"});

    developer.log("${await flutterTts.getVoices}");
    selectedIndex.value = selectedIndexSetter;

    flutterTts.progressHandler =
        (String? message, int? start, int? end, String? word) {
      developer.log("Message: $message, Start: $start, End: $end, Word: $word");
      startIndexSpokenWord.value = start ?? -1;
      endIndexSpokenWord.value = end ?? -1;
    };
    flutterTts.completionHandler = () {
      developer.log("Speech completed");
      startIndexSpokenWord.value = -1;
      endIndexSpokenWord.value = -1;
      isSpeaking.value = false;
    };

    // flutterTts.setVoice({"name": "es-us-x-sfb-local", "locale": "es-US"});
    var result = await flutterTts.speak(message);

    if (result == 1) {
      isSpeaking.value = true;
      developer.log("Playing message: $message");
    } else {
      developer.log("Error playing message: $message");
    }
  }

  Future stopTextMessageSpeech() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      isSpeaking.value = false;
      developer.log("Stopped speaking");
    } else {
      developer.log("Error stopping speech");
    }
    startIndexSpokenWord.value = -1;
    endIndexSpokenWord.value = -1;
  }

  /// Request permissions and initialize SpeechToText
  Future<void> _checkPermissionsAndInitialize() async {
    PermissionStatus micPermission = await Permission.microphone.request();

    if (micPermission.isGranted) {
      try {
        speechEnabled = await speechToText.initialize(
          finalTimeout: Duration(hours: 1),
          onStatus: _onStatus,
          onError: _onError,
        );

        print('Speech initialized: ${speechEnabled}');
      } catch (e) {
        print('Error initializing SpeechToText: $e');
        speechEnabled = false;
      }
    } else {
      print('Microphone permission not granted');
      speechEnabled = false;
    }
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    if (speechToText.isAvailable) {
      recordButtonColor.value = Colors.deepOrangeAccent;

      await speechToText.listen(
          onResult: _onSpeechResult,
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 10));
      developer.log("Listening...");
    }
    if (await Permission.microphone.isPermanentlyDenied) {
      Get.dialog(
        Center(
          child: Container(
            width: SizeConfig.screenWidth * 0.8,
            height: SizeConfig.screenHeight * 0.25,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(146, 96, 125, 139),
            ),
            child: Column(
              children: [
                Center(
                  child: Icon(
                    Icons.mic_off,
                    size: SizeConfig.blockSizeHorizontal * 10,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 1,
                ),
                Text(
                    "Grant microphone permission to gain access to this feature",
                    textAlign: TextAlign.center,
                    style: StyleSheet.sub_heading2),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                Text("Go to Settings > App > Permissions",
                    textAlign: TextAlign.center,
                    style: StyleSheet.sub_heading2),
              ],
            ),
          ).asGlass(
              clipBorderRadius: BorderRadius.circular(15),
              blurX: 15,
              blurY: 15),
        ),
      );
    }
    if (await Permission.microphone.isDenied) {
      developer.log("Speech recognition not available");
      recordButtonColor.value = Colors.lightBlueAccent;
      Get.dialog(
        Center(
          child: Container(
            width: SizeConfig.screenWidth * 0.8,
            height: SizeConfig.screenHeight * 0.25,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(52, 96, 125, 139),
            ),
            child: Column(
              children: [
                Center(
                  child: Icon(
                    Icons.mic_rounded,
                    size: SizeConfig.blockSizeHorizontal * 10,
                  ),
                ),
                Text(
                    "Grant microphone permission to gain access to this feature",
                    textAlign: TextAlign.center,
                    style: StyleSheet.sub_heading2),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.lightBlueAccent,
                          ),
                          child: TextButton.icon(
                            // style: ButtonStyle(backgroundColor: ),
                            onPressed: () async {
                              await Permission.microphone.request();
                            },
                            icon: Icon(Icons.mic),
                            label: Text("Allow Microphone"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ).asGlass(clipBorderRadius: BorderRadius.circular(15)),
        ),
      );
    } else {}
  }

  void _onStatus(String status) async {
    lastStatus.value = status;
    if (status == "done") {
      recordButtonColor.value = Colors.lightBlueAccent;
      if (recordedString.value == "") {
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(duration: 100);
        }
        Fluttertoast.showToast(
            msg: "No voice detected",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        developer.log("Vibrating");
      }
      recordedString.value = "";

      developer.log("Done Listening");
    }

    developer.log('Status: $status');
  }

  void _onError(SpeechRecognitionError error) {
    recordButtonColor.value = Colors.lightBlueAccent;
    // lastError.value = '${error.errorMsg} - ${error.permanent}';
    developer.log('Error: ${error.errorMsg}');
  }

  void stopListening() async {
    recordButtonColor.value = Colors.lightBlueAccent;
    await speechToText.stop();
    developer.log("Stopped Listening");
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    developer.log("Result: ${result}");
    if (result.finalResult) {
      textEditingController.text = result.recognizedWords;

      recordedString.value = result.recognizedWords;
      developer.log(
          "textController ${textEditingController.text} | recordedString  ${recordedString.value}");
      await sendMessageButton(isVoiceResponse: true);

      developer.log("Result: ${result.recognizedWords}");
    } else {
      // if (result.recognizedWords == "") {
      //   developer.log("Vibrating inside empty recognized words");
      //   if (await Vibration.hasVibrator()) {
      //     Vibration.vibrate(duration: 100);
      //   }
      // }
      textEditingController.text = result.recognizedWords;
      developer.log("Partial Result: ${result.recognizedWords}");
    }
  }

  @override
  Future<void> onInit() async {
    final argument = Get.arguments;
    print("argument: $argument");
    await _checkPermissionsAndInitialize();
    await flutterTts.awaitSpeakCompletion(false);
    flutterTts.completionHandler =
        () => isSpeaking.value = false; // Set to false when done speaking

    recordedString.value = "";

    if (argument != null && argument[0] is AIChatModel) {
      AIChatModel aiChatModel = argument[0];
      if (aiChatModel.type == mainContainerType.avatar) {
        gender_title.value = aiChatModel.name;
        main_image.value = aiChatModel.image; // ?
        limit = "Talk to me as ${aiChatModel.name}";
        // log("");.
        print("Entered in avatar");
        showAvatar.value = true;
        avatar.value = aiChatModel.image;
        initData(aiChatModel);
      }

      // Now you can work with aiChatModel as an AIChatModel object
    } else {
      // Handle the case where argument is not an AIChatModel
    }

    try {
      if (argument != null) {
        if (argument[1] is FirebaseCharecter) {
          firebaseCharecter = argument[1];
          if (firebaseCharecter!.animationUrl! != "") {
            initializeVideo(firebaseCharecter!.animationUrl!);
          }

          isLoved.value = await getIsLoved(firebaseCharecter!.title);

          developer.log(
              "FirebaseCharecter: ${firebaseCharecter!.toJson()} This is show video : ${showVideo.value}");
        }
      }
    } on Exception catch (e) {
      developer.log("Error in FirebaseCharecter: $e");
      // TODO
    }

    Random random = Random();
    int randomIndex = random.nextInt(dummyAiBotChatList.length);
    String randomMessage = dummyAiBotChatList[randomIndex];

    openAi = OpenAI.instance.build(
      token: AppStrings.OPENAI_TOKEN,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 20),
        connectTimeout: const Duration(seconds: 20),
      ),
      enableLog: true,
    );

    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    typingAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    animationController.repeat(reverse: true);

    homectl.CheckUser().then((value) {
      homectl.getGems();
    });

    super.onInit();
    // get_gender();
// ? Commented by jamal start
    // if (RevenueCatService().currentEntitlement.value == Entitlement.paid) {
    //   premiumUser.value = true;
    // } else {
    //   // AppLovinProvider.instance.showInterstitial();
    //   //     getlimit().then((value) {
    //   //   getlimit();

    //   // });
    // }
    // ? Commented by jamal end

    developer.log("Main Image: last ${main_image.value}");
  }

  RxBool listenting = false.obs;

  // Future Speech_to_text() async {
  //   listenting.value = true;
  //   initSpeechState().then((value) {
  //     startListening();
  //   });
  // }

  RxString currentLocaleId = ''.obs;
  RxBool hasSpeech = false.obs;
  RxString lastError = ''.obs;
  RxString lastStatus = ''.obs;

  bool _logEvents = false;

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      debugPrint('$eventTime $eventDescription');
    }
  }

  Future get_gender() async {
    gender_title.value = "AI Friend";
    main_image.value = AppImages.AlbertEinstein;
  }

  List<Messages> conversation = [];

  Future<void> sendMessageButton({bool isVoiceResponse = false}) async {
    print("Send Message ${textEditingController.text}");
    if (!wait.value) {
      if (textEditingController.text.isNotEmpty) {
        isWaitingForResponse.value = true;
        // ? Commented by jamal start
        sendMessage("${textEditingController.text}", inputFieldContext,
            isVoiceResponse);
        //// ? Commented by jamal end
        lastMessage.value = textEditingController.text;
        textEditingController.clear();
      }
    }
  }

// ? Commented by jamal start
  Future sendMessage(String message, context, bool isVoiceResponse) async {
    lastMessage.value = message;
    bool result = await InternetConnectionChecker().hasConnection;
    // print("credits:${request_limit.value}");

    // if (RevenueCatService().currentEntitlement.value == Entitlement.free) {
    if (homectl.gems.value > 0) {
      ChatMessage userMessage = ChatMessage(
          senderType: SenderType.User,
          message: message,
          isVoiceResponse: isVoiceResponse);
      chatList.insert(0, userMessage);

      await MessageApiCall(message, result, context, isVoiceResponse);
    } else {
      isWaitingForResponse.value = false;

      // AwesomeDialog(
      //     context: context,
      //     dialogBackgroundColor: AppColors.white_color,
      //     animType: AnimType.scale,
      //     dialogType: DialogType.noHeader,
      //     title: '',
      //     titleTextStyle: TextStyle(color: AppColors.black_color, fontSize: 20),
      //     descTextStyle: TextStyle(color: AppColors.black_color, fontSize: 14),
      //     desc: '',
      //     // btnOkIcon: Icons.launch,
      //     body: Container(
      //         child: Column(
      //       children: [
      //         Padding(
      //           padding: EdgeInsets.all(SizeConfig.screenWidth * 0.04),
      //           // padding: const EdgeInsets.all(8.0),
      //           child: Text("Ran out of Gems!", style: StyleSheet.view_heading),
      //         ),
      //         // SizedBox(height: SizeConfig.screenHeight *0.02,),
      //         Padding(
      //           padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
      //           child: Column(
      //             children: [
      //               Text("Your Gems are over!", style: StyleSheet.sub_heading2),
      //               Text("Click OK to get more",
      //                   style: StyleSheet.sub_heading2),
      //             ],
      //           ),
      //         ),
      //         // SizedBox(height: SizeConfig.screenHeight *0.02,),
      //       ],
      //     )),
      //     btnOkColor: AppColors.buttonColor,
      //     btnCancelColor: AppColors.brightbuttonColor,
      //     btnOkText: "OK",
      //     btnOkOnPress: () {
      //       Get.toNamed(Routes.GemsView);
      //       // AppLovinProvider.instance.showRewardedAd(increase_credits);
      //       // final service = FlutterBackgroundService();
      //       // AllowStepToCount(service);
      //     },
      //     btnCancelOnPress: () {
      //       // onEndIconPress(context);
      //     })
      //   ..show();
    }
  }

// ? Commented by jamal end
  Future<void> MessageApiCall(
      String message, bool result, context, bool isVoiceResponse) async {
    if (message.isNotEmpty && result == true) {
      // if (message.isNotEmpty) {
      wait.value = true;

      // final userMessage = {"role": "user", "content": message};
      // final userMessage = Messages(role: Role.user, content: message);
      final systemMessage = Messages(role: Role.user, content: limit);

      conversation.add(systemMessage);

      final userMessage = Messages(role: Role.user, content: message);

      conversation.add(userMessage);
      HomeViewCTL homeController = Get.find();
      saveMessage(message, "User", gender_title.value,
          homeController.uniqueId ?? "1234");
      // saveHighPriorityMessage(message, "User", gender_title.value,
      //     homeController.uniqueId ?? "1234");
      saveLocalDBMessage(
          message: message,
          userType: "user",
          aiChatModel: myAIChatModel,
          isVoiceResponse: isVoiceResponse);
      // userMessages.add(message);

      String? geminiResponse = await sendGemeniMessage(chatList, message);

      if (geminiResponse == null) {
        isWaitingForResponse.value = false;

        showServerLimitError(context);

        //? OpenAIImplementation Belo
      } else {
        //?Bard Response Recieved
        ChatMessage messageReceived = ChatMessage(
            senderType: SenderType.Bot,
            message: geminiResponse,
            isVoiceResponse: isVoiceResponse);
        EasyLoading.dismiss();

        isWaitingForResponse.value = false;
        chatList.insert(0, messageReceived);
        saveMessage(geminiResponse, "Bard", gender_title.value,
            homeController.uniqueId ?? "1234");
        saveHighPriorityMessage(geminiResponse, "Bard", gender_title.value,
            homeController.uniqueId ?? "1234");
        saveLocalDBMessage(
            message: geminiResponse,
            userType: "bot",
            aiChatModel: myAIChatModel,
            isVoiceResponse: isVoiceResponse);
      }

      // print("chatList: ${chatList[0].input}");
      // userMessages.value = userMessages.reversed.toList();
      textEditingController.clear();
      wait.value = false;
      // if(request_limit >= -1){
      //   request_limit--;
      // }

      // navCTL.gems.value = navCTL.gems.value - GEMS_RATE.NormalChat_GEMS_RATE;

      // savelimit();

      // navCTL.saveGems(navCTL.gems.value);
      // homectl.decreaseGEMS(GEMS_RATE.NormalChat_GEMS_RATE);
    } else {
      // AwesomeDialog(
      //   context: context,
      //   dialogBackgroundColor: AppColors.white_color,
      //   animType: AnimType.scale,
      //   dialogType: DialogType.noHeader,
      //   title: 'Please Check your Internet Connection!',
      //   titleTextStyle: TextStyle(color: AppColors.black_color, fontSize: 20),
      //   descTextStyle: TextStyle(color: AppColors.black_color, fontSize: 14),
      //   desc:
      //       'The Offline Mode Alert is a feature that notifies users of no internet connection. It helps maintain a smooth user experience by displaying a clear message and providing suggestions for reconnecting.',
      //   // btnOkIcon: Icons.launch,
      //   body: Container(
      //       child: Column(
      //     children: [
      //       Padding(
      //         padding: EdgeInsets.all(SizeConfig.screenWidth * 0.04),
      //         // padding: const EdgeInsets.all(8.0),
      //         child:
      //             Text("Offline Mode Alert!", style: StyleSheet.view_heading),
      //       ),
      //       // SizedBox(height: SizeConfig.screenHeight *0.02,),
      //       Padding(
      //         padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
      //         child: Text(
      //             "Please ensure that you are currently connected to the internet.",
      //             style: StyleSheet.sub_heading2),
      //       ),
      //       // SizedBox(height: SizeConfig.screenHeight *0.02,),
      //     ],
      //   )),
      //   btnOkColor: AppColors.buttonColor,
      //   btnCancelColor: AppColors.brightbuttonColor,
      //   btnOkText: "OK",
      //   btnOkOnPress: () {
      //     // final service = FlutterBackgroundService();
      //     // AllowStepToCount(service);
      //   },
      //   // btnCancelOnPress: () {
      //   //   // onEndIconPress(context);
      //   // }
      // )..show();
    }
  }

  showServerLimitError(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sorry! '),
        content: Text(
            'We\'re currently at our limit right now. Please try again later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showNoMoreChats() {
    Get.dialog(
      AlertDialog(
        title: Text('Free Chats Finished'),
        content: Text('You have used up all your free chats.'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement the action for watching an ad
              // AppLovinProvider.instance.showRewardedAd(onRewardWatched);
              Get.back(); // Close the dialog
            },
            icon: Icon(Icons.play_arrow),
            label: Text('Watch Ad for 5 More Chats'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> initData(AIChatModel aiChatModel) async {
    if (aiChatModel.type == mainContainerType.avatar) {
      FirebaseAnalytics.instance.logSelectContent(
          contentType: aiChatModel.name, itemId: aiChatModel.discription);
      // limit = "Talk to me as ${aiChatModel.name}";
      limit = aiChatModel.discription;
    }
    myAIChatModel = aiChatModel;

    // Now you can work with aiChatModel as an AIChatModel object

    // textEditingController.
    // textFieldFocusNode.requestFocus();

    // Adding a random message from the list to chatList
    Random random = Random();
    int randomIndex = random.nextInt(aiChatModel.stringList.length);
    String randomMessage = aiChatModel.stringList[randomIndex];
    chatList.clear();
    conversation.clear();
    gender_title.value = aiChatModel.name;
    main_image.value = aiChatModel.image; // ?
    developer.log("Main Image: ${main_image.value}");
    print("Image: ${main_image.value}");
    // chatList.insert(
    //     0,
    //     ChatMessage(
    //       senderType: SenderType.Bot,
    //       message: randomMessage,
    //     ));
    developer.log("Training History String ${aiChatModel.history}");
    List<Content> chatHistorytContent = [];
    chatTrainingHistiry = ConvertStringIntoMapList(aiChatModel.history);
    developer.log("Training History $chatTrainingHistiry");
    String systemInstruction = aiChatModel.discription;
    systemInstruction += RCVariables.extraInstruction;
    developer.log("Extra Instruction: ${RCVariables.extraInstruction}");

    // systemInstruction +=
    //     "\nNote: Dont do anything else other then your character. and never ever mention that you are an AI model/bot/trained or anything like that. and last but not the least try to wrap your response in within 50-70 words";

    // developer.log("System Instructions: $systemInstruction");
    // chatHistorytContent.add(Content.system(systemInstruction));
    chatHistorytContent.add(Content.text(systemInstruction));
    chatHistorytContent.add(Content('model', [TextPart("Ok got it")]));

    //? Implement
    chatTrainingHistiry.forEach((element) {
      String role = element['role'] ?? "user";
      List<dynamic> list = element['parts'] as List<dynamic>;
      String parts = list.first;

      // Content trainingContent = Content(role);
      if (role == 'user') {
        chatHistorytContent.add(Content.text(parts));
      } else {
        chatHistorytContent.add(Content('model', [TextPart(parts)]));
      }
    });

    try {
      dbMessages = await ChatHistoryDatabaseHelper.db
          .getAllMessagesForCharacter(
              "${aiChatModel.name}_${aiChatModel.category}");

      if (dbMessages.isNotEmpty) {
        final reversedMessages = dbMessages.reversed;
        for (var dbMessage in reversedMessages) {
          developer.log(
              "DBMessage: ${dbMessage.message}  Type: ${dbMessage.senderType}");
          if (dbMessage.senderType == "user") {
            chatList.add(ChatMessage(
                senderType: SenderType.User,
                message: dbMessage.message,
                isVoiceResponse: dbMessage.isVoiceResponse));
          } else {
            chatList.add(ChatMessage(
                senderType: SenderType.Bot,
                message: dbMessage.message,
                isVoiceResponse: dbMessage.isVoiceResponse));
          }
        }

        // chatList.add(
        //     // 0,
        //     ChatMessage(
        //   senderType: SenderType.Bot,
        //   message: randomMessage,
        // ));
        // saveLocalDBMessage(
        //     message: randomMessage, userType: "bot", aiChatModel: aiChatModel);
      } else {
        chatList.insert(
            0,
            ChatMessage(
                senderType: SenderType.Bot,
                message: randomMessage,
                isVoiceResponse: false));
        saveLocalDBMessage(
            message: randomMessage,
            userType: "bot",
            aiChatModel: aiChatModel,
            isVoiceResponse: false);
      }
      developer.log("DBMessage:");
    } on Exception catch (e) {
      // TODO
      developer.log("DB Intialize Error: $e");
      if (dbMessages.isEmpty) {
        chatList.insert(
            0,
            ChatMessage(
                senderType: SenderType.Bot,
                message: randomMessage,
                isVoiceResponse: false));
        saveLocalDBMessage(
            message: randomMessage,
            userType: "bot",
            aiChatModel: aiChatModel,
            isVoiceResponse: false);
      }
    }

    List<Content> dbHistory = dbMessagesTodbHistory(dbMessages);

    initalizeModel(chatHistorytContent, dbHistory);
  }

  //? Gemeni Original Package implementation
  // int messageCount = 0;
  Future<String?> sendGemeniMessage(
      RxList<ChatMessage> history, message) async {
    // messageCount++;
    print("sendGemeniMessage Called..");
    String? generatedMessage = null;

    // developer.log("chatContent $chatContent");

    try {
      final response = await _chat.sendMessage(Content.text(
          "$message The response must be concise and should be under 30 words"));
      final text = response.text;
      if (text == null) {
        generatedMessage = getRandomDenielMessage();
      } else {
        generatedMessage = text;
        // [[[[[[[[[[Commented by Jamal Temp]]]]]]]]]]
        // homectl.decreaseGEMS(GEMS_RATE.NormalChat_GEMS_RATE);
        developer.log(
            "Token Consumed: ${response.usageMetadata!.totalTokenCount ?? 0}");
      }

      return generatedMessage;
    } catch (e) {
      developer.log('Gemeni Error $e', error: e);

      final modifiedIterable = _chat.history
          .takeWhile((element) => element != _chat.history.last)
          .toList();
      // _chat.history=modifiedIterable;
      _chat = _model.startChat(
        history: modifiedIterable,
        safetySettings: [
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        ],
        generationConfig: GenerationConfig(
          candidateCount: 1,
          // maxOutputTokens: 200,
        ),
      );

      return getRandomErrorMessage();

      // generatedMessage = "Error Message $e";
    }
  }

  // Future<String?> sendGemeniMessage(
  //     RxList<ChatMessage> history, message) async {
  //   // messageCount++;
  //   print("sendGemeniMessage Called..");
  //   String? generatedMessage = null;

  //   // Content userInstruction =
  //   //     Content(parts: [Parts(text: limit)], role: 'user');

  //   List<Content> chatContent = [];
  //   List<Content> chatHistorytContent = [];

  //   chatTrainingHistiry.forEach((element) {
  //     String role = element['role'] ?? "user";
  //     List<dynamic> list = element['parts'] as List<dynamic>;
  //     String parts = list.first;

  //     Content trainingContent =
  //         Content(parts: [Parts(text: parts)], role: role);
  //     chatHistorytContent.add(trainingContent);
  //   });

  //   chatContent = chatHistorytContent;
  //   if (chatContent.isEmpty) {
  //     Content userInstruction =
  //         Content(parts: [Parts(text: limit)], role: 'user');
  //     chatContent.add(userInstruction);
  //   }

  //   history.take(8).toList().reversed.forEach((element) {
  //     if (element.senderType == SenderType.Bot) {
  //       Content content =
  //           Content(parts: [Parts(text: element.message)], role: 'model');
  //       chatContent.add(content);

  //       developer.log("Test Chat: ${element.message},   Sender: Model");
  //     } else {
  //       String msg = element.message +
  //           "\nNote: Your response must be concise and should be under 30 words";
  //       Content content2 =
  //           Content(parts: [Parts(text: element.message)], role: 'user');
  //       chatContent.add(content2);
  //       developer.log("Test Chat: ${element.message},   Sender: User");
  //     }

  //     // Add both content and content2 to chatContent
  //   });

  //   developer.log("chatContent $chatContent");

  //   final gemini = Gemini.instance;
  //   List<SafetySetting>? safetySettings = <SafetySetting>[
  //     SafetySetting(
  //         category: SafetyCategory.sexuallyExplicit,
  //         threshold: SafetyThreshold.blockNone)
  //   ];

  //   try {
  //     var value = await gemini.chat(chatContent,
  //         safetySettings: safetySettings,
  //         generationConfig: GenerationConfig(maxOutputTokens: 100));
  //     generatedMessage = value?.output ?? getRandomDenielMessage();
  //     if (value?.output != null) {
  //       homectl.decreaseGEMS(GEMS_RATE.NormalChat_GEMS_RATE);
  //     }
  //     developer.log(value?.output ?? 'without output');
  //     return generatedMessage;
  //   } catch (e) {
  //     developer.log('Gemeni Error $e', error: e);

  //     return getRandomErrorMessage();

  //     // generatedMessage = "Error Message $e";
  //   }
  // }

  String getRandomErrorMessage() {
    final random = Random();
    if (myAIChatModel.name.toLowerCase().contains("sex") ||
        myAIChatModel.name.toLowerCase().contains("sex")) {
      int randomIndex = random.nextInt(Therapist_denielMessages.length);

      return Therapist_denielMessages[randomIndex];
    }
    int randomIndex = random.nextInt(errorMessages.length);

    return errorMessages[randomIndex];
  }

  String getRandomDenielMessage() {
    final random = Random();
    int randomIndex = random.nextInt(denielMessages.length);
    return denielMessages[randomIndex];
  }

  void ShareMessage(String message) {
    Share.share(message);
  }

  void CopyMessage(String message) {
    Clipboard.setData(new ClipboardData(text: message))
        .then((result) => showCopySuccessSnackBar())
        .catchError((error) => showCopyErrorSnackBar());
  }

  void showCopySuccessSnackBar() {
    final snackBar = SnackBar(content: Text('Message copied to clipboard'));
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  void showCopyErrorSnackBar() {
    final snackBar =
        SnackBar(content: Text('Error copying message to clipboard'));
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }

  Future<void> saveMessage(String message, String userType,
      String characterName, String userId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final characterChatHistoryCollection = firestore
          .collection('userChatHistory')
          .doc(userId)
          .collection(characterName);

      // Create a new FirebaseChat object
      final newChatMessage = FirebaseChat(
        timestamp: Timestamp.now(),
        message: message,
        senderType: userType,
      );

      // Add the new chat message directly to the character's chat history collection
      await characterChatHistoryCollection.add(newChatMessage.toMap());
    } catch (error) {
      print('Error saving message: $error');
      // Handle errors appropriately
    }

    if (homectl.reviewCounter >= 35) {
      homectl.reviewCounter = 0;
      homectl.showReviewDialogue(Get.context!);
    } else {
      homectl.reviewCounter++;
    }
  }

  Future<void> saveLocalDBMessage(
      {required String message,
      required String userType,
      required AIChatModel aiChatModel,
      required bool isVoiceResponse}) async {
    HomeViewCTL homeViewCTL = Get.find();
    developer.log("Saving Local Message");
    try {
      DBMessage dbMessage = DBMessage(
        userId: homeViewCTL.uniqueId ?? "1234",
        characterId: "${aiChatModel.name}_${aiChatModel.category}",
        message: message,
        senderType: userType,
        isVoiceResponse: isVoiceResponse,
      );
      ChatHistoryDatabaseHelper.db.addChatMessage(dbMessage).then((value) {
        developer
            .log("Message Saved: ${aiChatModel.name}_${aiChatModel.category}");
      });
    } catch (error) {
      developer.log('Error saving message: $error');
      // Handle errors appropriately
    }
  }

  Future<void> saveHighPriorityMessage(String message, String userType,
      String characterName, String userId) async {
    print("Charecter Name $characterName");

    if (characterName.toLowerCase().contains("sex") ||
        characterName.toLowerCase().contains("dating") ||
        characterName.toLowerCase().contains("rin")) {
      print("Charecter Name Matched");

      try {
        final firestore = FirebaseFirestore.instance;
        final userChatHistoryCollection = firestore
            .collection('priorityChatHistory')
            .doc("${userId}_${characterName}");
        // final characterDoc =
        //     userChatHistoryCollection.collection(characterName).doc();

        // Check if document exists, use set for new documents
        final docRef = userChatHistoryCollection;
        final docSnapshot = await docRef.get();
        if (!docSnapshot.exists) {
          await docRef.set({'chatHistory': []});
        }
        // Create a new message object
        final newChatMessage = {
          'message': message,
          'senderType': userType,
          'timestamp': Timestamp.now(),
        };

        // Add the new message to the character's chat history using arrayUnion
        await userChatHistoryCollection.update({
          'chatHistory': FieldValue.arrayUnion([newChatMessage]),
        });

        print("Priority message Saved..");
      } catch (error) {
        print('Error saving message: $error');
      }
    }
  }

  List<Map<String, dynamic>> ConvertStringIntoMapList(
      String? FormattedStringData) {
    var maps = <Map<String, dynamic>>[];
    try {
      var jsonData = jsonDecode(FormattedStringData ?? "");
      // Check if jsonData is a list; if not, wrap it in a list
      if (jsonData is List) {
        // Map each item in the list to SlideResponse
        maps = jsonData.map((item) => item as Map<String, dynamic>).toList();
        // Log the data from the first item
        return maps;
      } else {
        return maps;
      }
    } catch (e) {
      developer.log("Error: $e");

      return maps;
    }
  }

  // void initSpeec

  void initalizeModel(List<Content> history, List<Content> dbHistory) {
    final apiKey = RCVariables.apiKey;
    final modelName = RCVariables.geminiModel;
    List<Content> actualHistory = [];
    _model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
    );

    if (!dbHistory.isEmpty) {
      if (history.last.role == "user") {
        history.removeLast();
        developer.log("Last History Message ${history.last.role}");
      }

      actualHistory = dbHistory;
      developer.log("Using DBHistory");
    } else if (!history.isEmpty) {
      if (history.last.role == "user") {
        history.removeLast();
        developer.log("Last History Message ${history.last.role}");
      }
      actualHistory = history;
      developer.log("Using Static History");
    }

    _chat = _model.startChat(
      history: actualHistory,
      safetySettings: [
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
      ],
      generationConfig: GenerationConfig(
        candidateCount: 1,
        // maxOutputTokens: 200,
      ),
    );
    // _chat = _model.startChat();
  }

  List<Content> dbMessagesTodbHistory(List<DBMessage> dbMessages) {
    List<Content> chatHistorytContent = [];

    if (dbMessages.isNotEmpty) {
      String systemInstruction = myAIChatModel.discription;

      systemInstruction += RCVariables.extraInstruction;
      developer.log("Extra Instruction: ${RCVariables.extraInstruction}");
      // developer.log("System Instructions: $systemInstruction");
      // chatHistorytContent.add(Content.system(systemInstruction));
      chatHistorytContent.add(Content.text(systemInstruction));
      chatHistorytContent.add(Content('model', [TextPart("Ok Got it")]));
      if (dbMessages.length > 16) {
        final last16Messages = dbMessages.sublist(dbMessages.length - 16);

        for (var message in last16Messages) {
          if (message.senderType == 'user') {
            chatHistorytContent.add(Content.text(message.message));
          } else {
            chatHistorytContent
                .add(Content('model', [TextPart(message.message)]));
          }
        }
      } else {
        // Add all messages if there are less than 16
        for (var message in dbMessages) {
          if (message.senderType == 'user') {
            chatHistorytContent.add(Content.text(message.message));
          } else {
            chatHistorytContent
                .add(Content('model', [TextPart(message.message)]));
          }
        }
      }
    }

    return chatHistorytContent;
  }

  Future<void> increaseLovedBy(FirebaseCharecter updatedCharacter) async {
    if (kDebugMode) {
      final random = Random();
      int rand = random.nextInt(50000) + 1000;
      updatedCharacter.lovedBy = updatedCharacter.lovedBy! + rand;
    } else {
      updatedCharacter.lovedBy = updatedCharacter.lovedBy! + 1;
    }
    // updatedCharacter.lovedBy = updatedCharacter.lovedBy! + 1;
    final categoriesRef = FirebaseFirestore.instance
        .collection(APPConstants.CharecterCollection)
        .doc(APPConstants.CatagoriesCollection)
        .collection('categories');

    final categoryDoc =
        await categoriesRef.doc(updatedCharacter.category).get();

    if (categoryDoc.exists) {
      // Get the list of characters
      List<dynamic> characters = categoryDoc.data()!['characters'];

      // Find the index of the character with the specified name
      int characterIndex = characters
          .indexWhere((char) => char['title'] == updatedCharacter.title);

      if (characterIndex != -1) {
        // Update the character
        characters[characterIndex] = updatedCharacter.toJson();

        // Save the updated list back to Firestore
        await categoryDoc.reference.update({'characters': characters});
        await setIsLoved(true, updatedCharacter.title);
        isLoved.value = await getIsLoved(updatedCharacter.title);
        developer.log("Updated Charecter: ${firebaseCharecter!.toJson()}");
      } else {
        developer.log('Character not found');
      }
    } else {
      developer.log('Category not found');
    }
  }

  Future<void> setIsLoved(bool isLoved, String title) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoved_$title', isLoved);
  }

  Future<bool> getIsLoved(String title) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoved_$title') ?? false;
  }

  void reportMessage(BuildContext context, String message, int index) {
    final TextEditingController customReasonController =
        TextEditingController();
    List<String> reasons = [
      "harmful/Unsafe",
      "Sexual Explicit Content",
      'Repetitive',
      'Hate and harrasment',
      'Misinformation',
      'Frauds and scam',
      "Spam",
      "Other"
    ];
    RxString selectedReason = "".obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Report Inappropriate Message"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select a reason:"),
                ...reasons.map((reason) {
                  return Obx(() => RadioListTile(
                        title: Text(reason),
                        value: reason,
                        groupValue: selectedReason.value,
                        onChanged: (value) {
                          selectedReason.value = value!;
                          if (selectedReason != "Other") {
                            customReasonController.clear();
                          }
                        },
                      ));
                }).toList(),
                Obx(() => selectedReason.value == "Other"
                    ? TextField(
                        controller: customReasonController,
                        decoration: InputDecoration(
                          labelText: "Enter custom reason",
                        ),
                      )
                    : Container()),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Report"),
              onPressed: () async {
                String reportReason = selectedReason.value == "Other"
                    ? customReasonController.text
                    : selectedReason.value;

                if (reportReason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select or enter a reason.")),
                  );
                  return;
                }

                EasyLoading.show(status: "Please Wait...");
                try {
                  HomeViewCTL homeViewCTL = Get.find();
                  // Save report in Firestore
                  await FirebaseFirestore.instance
                      .collection('reported_messages')
                      .doc('${gender_title.value}_${homeViewCTL.uniqueId}')
                      .set({
                    'message': message,
                    'senderId': homeViewCTL.uniqueId ?? "1234",
                    'messageId': gender_title.value,
                    'reason': reportReason,
                    'reportedAt': DateTime.now(),
                  });
                  // await FirebaseFirestore.instance
                  //     .collection('reported_messages')
                  //     .add({
                  //   'message': message,
                  //   'senderId': homeViewCTL.uniqueId ?? "1234",
                  //   'messageId': gender_title.value,
                  //   'reason': reportReason,
                  //   'reportedAt': DateTime.now(),
                  // });

                  Navigator.of(context).pop();
                  EasyLoading.dismiss();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Message reported successfully.")),
                  );
                  chatList[index].isFeedBack.value = true;
                  chatList[index].isGood.value = false;
                } catch (e) {
                  EasyLoading.dismiss();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to report message: $e")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void GoodResponse(String message, int index) {
    print("GoodResponse reported..");
    feedbackMessages.add(message);
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text("Feedback saved successfully")),
    );

    chatList[index].isFeedBack.value = true;
    chatList[index].isGood.value = true;
  }
}

enum SenderType {
  User,
  Bot,
}

class ChatMessage {
  SenderType senderType;
  String message;
  bool isVoiceResponse = false;
  Rx<bool> isFeedBack;
  Rx<bool> isGood;

  ChatMessage({
    required this.senderType,
    required this.message,
    required this.isVoiceResponse,
    Rx<bool>? isFeedBack,
    Rx<bool>? isGood,
  })  : isFeedBack = isFeedBack ?? false.obs,
        isGood = isGood ?? false.obs;
}
