import 'package:character_ai_delta/app/data/ai_model.dart';
import 'package:character_ai_delta/app/data/firbase_charecters.dart';
import 'package:character_ai_delta/app/data/firebase_categories.dart';
import 'package:character_ai_delta/app/routes/app_pages.dart';
import 'package:get/get.dart';

class HomeViewSliderCtl extends GetxController {
  late List<FirebaseCharecter> firebaseCharactersList;
  late List<AIChatModel> aiChatModelsList;

  @override
  void onInit() {
    super.onInit();
    // Initialize the lists here
    firebaseCharactersList = FirebaseCatagory(id: 'New').characters;
    aiChatModelsList = generateAIChatModels(firebaseCharactersList);
  }

  List<AIChatModel> generateAIChatModels(List<FirebaseCharecter> characters) {
    return characters.map((character) {
      return AIChatModel(
        character.title,
        [character.firstMessage],
        character.imageUrl,
        false,
        character.description,
        Routes.GfChatView,
        mainContainerType.avatar,
        character.historyMessages,
        character.category,
      );
    }).toList();
  }

  @override
  void onClose() {
    super.onClose();
  }
}





// FirebaseCharecter createFirebaseCharacter(Map<String, dynamic> json) {
//   return FirebaseCharecter.fromJson(json);
// }
// List<AIChatModel>=generateAIChatModels();


  // void openAvatarChat(
  //     AIChatModel textSuggestion, FirebaseCharecter firebaseCharecter) {
  
  //   Get.toNamed(textSuggestion.route,
  //       arguments: [textSuggestion, firebaseCharecter]);
  // }
  // GfChatViewController gfChatViewController = Get.find();
    // gfChatViewController.initData(textSuggestion);
    // current_index.value = 1;


        // AIChatModel aiChatModel = AIChatModel(
        //     character.title,
        //     [character.firstMessage],
        //     character.imageUrl,
        //     false,
        //     character.description,
        //     Routes.GfChatView,
        //     mainContainerType.avatar,
        //     character.historyMessages,
        //     character.category);

        // String history = character.historyMessages ?? "";
        // print("Firebase History: $history");
        // controller.openAvatarChat(aiChatModel, character);

        // if (controller.adCounter == 3) {
        //   controller.adCounter = 1;
        //   if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
        //     MetaAdsProvider.instance.showInterstitialAd();
        //   } else {
        //     AppLovinProvider.instance.showInterstitial(() {}, false);
        //   }
        // } else {
        //   controller.adCounter++;
        // }
      

