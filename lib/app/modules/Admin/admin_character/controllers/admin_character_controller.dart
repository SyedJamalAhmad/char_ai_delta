import 'package:character_ai_delta/app/data/ai_model.dart';
import 'package:character_ai_delta/app/data/firebase_categories.dart';
import 'package:character_ai_delta/app/utills/app_const.dart';
import 'package:character_ai_delta/app/utills/gems_rate.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_rating_dialog/slide_rating_dialog.dart';

class AdminCharacterController extends GetxController {
  //TODO: Implement AdminCharacterController

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
  }

  void openAvatarChat(AIChatModel textSuggestion) {
    // GfChatViewController gfChatViewController = Get.find();
    // gfChatViewController.initData(textSuggestion);
    current_index.value = 1;
    Get.toNamed(textSuggestion.route, arguments: textSuggestion);
  }

  //? Firebase Implementation

  Stream<QuerySnapshot> get categoriesStream {
    return FirebaseFirestore.instance
        .collection(APPConstants.CharecterCollection)
        .doc(APPConstants.CatagoriesCollection)
        .collection('categories')
        .snapshots();
  }
}
