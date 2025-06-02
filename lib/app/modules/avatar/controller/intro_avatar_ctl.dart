import 'package:character_ai_delta/app/data/user_avatar.dart';
import 'package:character_ai_delta/app/modules/avatar/views/avatar_view.dart';
import 'package:character_ai_delta/app/modules/controllers/create_avatar_ctl.dart';
import 'package:character_ai_delta/app/provider/meta_ads_provider.dart';
import 'package:character_ai_delta/app/provider/useravatar_dbhelper.dart';
import 'package:character_ai_delta/app/routes/app_pages.dart';
import 'package:character_ai_delta/app/utills/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class IntroAvatarCTL extends GetxController {
  RxInt tabIndex = 0.obs;

  TextEditingController avatarNameTextCTL = TextEditingController();
  TextEditingController avatarFirstTextCTL = TextEditingController();
  String avatarImageAsset = AppImages.Gojo_Satoru;
  List<String> interest = [];
  RxString avatarGender = "Male".obs;

  List<String> animalImages = [
    AppImages.cat,
    AppImages.dog,
    // AppImages.l,
  ];

  List<String> personImage = [
    AppImages.AlbertEinstein,
    // AppImages.CodeDebugger,
    AppImages.SirIsaacNewton,
    AppImages.DatingCoach,
    AppImages.Gojo_Satoru,
    AppImages.Healtcare,
    AppImages.Makima,
  ];
  List<String> OtherImage = [
    // AppImages.DatingCoach,
    // AppImages.Gojo_Satoru,
    // AppImages.Healtcare,
    // AppImages.Makima,
    AppImages.CodeDebugger
  ];

  RxList<String> currentList = <String>[
    AppImages.AlbertEinstein,
    AppImages.CodeDebugger,
    AppImages.SirIsaacNewton,
  ].obs;

  final options = [
    'art',
    'astrology',
    'books',
    'buisness',
    'cars',
    'crypto',
    'dance',
    'fitness',
    'food',
    'games',
    'history',
    'languages',
    'meditation',
    'movies',
    'music',
    'nature',
    'philosphy',
    'photo & video',
    'religion',
    'relationship',
    'science',
    'sports',
    'technology',
    'travel',
  ];

  final nameOptions = [
    'Rowan',
    'Cersei',
    'Luke',
    'Yennefer',
    'Jacob',
    'Alice',
  ];

  var selectedOptions = <String>[].obs;
  var nameSelectedOptions = <String>[].obs;
  String currentCharType = "Person";

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
    final charType = Get.arguments as CreateCharType?;
    if (charType != null) {
      // final charType =
      // arguments[0] as CreateCharType?; // Cast as CreateCharType

      print("CharType: $charType");
      // Use the charType enum value
      switch (charType) {
        case CreateCharType.Person:
          // Handle Person type
          currentList.value = personImage;
          currentCharType = "Person";
          break;
        case CreateCharType.Animal:
          currentList.value = animalImages;
          currentCharType = "Animal";

          // Handle Animal type
          break;
        case CreateCharType.Others:
          currentList.value = OtherImage;
          currentCharType = "Other then Person and Animal";

          // Handle Others type
          break;
      }
    } else {
      print("no arguments were passed");

      // Handle the case where no arguments were passed
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void SaveUserAvatar() async {
    EasyLoading.show(status: "Creating Charecter");
    String imageAsset = avatarImageAsset;
    String AvatarName = avatarNameTextCTL.text;
    String Avatar1stMessage = avatarFirstTextCTL.text;

    String avatartDescription = getAvatarDescription(AvatarName);

    UserPersonalizedAvatar avatar = UserPersonalizedAvatar(
      imageAsset: imageAsset,
      avatarName: AvatarName,
      avatarFirstMessage: Avatar1stMessage,
      avatarDescription: avatartDescription,
      id: 0,
    );

    try {
      await UserAvatarDatabaseHelper.db.insertAvatar(avatar);
      print('Avatar added successfully!');
      EasyLoading.showSuccess("Avatar Created..");
      CreateAvatarCTL createAvatarCTL = Get.find();
      createAvatarCTL.fetchAvatars();
      if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
        MetaAdsProvider.instance.showInterstitialAd();
      } else {
        // AppLovinProvider.instance.showInterstitial(() {}, false);
      }
      // Get.off(Routes.NavView);
      Get.until((route) => Get.currentRoute == Routes.NavView);
    } catch (error) {
      EasyLoading.showError("Avatar Created..");

      print('Error adding avatar: $error');
    }
    uploadAvatarToFirestore(avatar);
  }

  String getAvatarDescription(String name) {
    return '''Your name is $name your interest is in 
    ${selectedOptions.value} 
    your gender is: ${avatarGender.value}
    charecter Type: $currentCharType

    using all this information talk as all of these informations are your and you are trained to mimic this charecter. and never tell about yourself without being asked.  
     ''';
  }

  Future<void> uploadAvatarToFirestore(UserPersonalizedAvatar avatar) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final avatarsCollection = firestore.collection('userAvatars');

      // Generate a unique ID for the avatar (Firestore will also create one if omitted)
      // final avatarId = avatarsCollection.doc().id;

      // Update the avatar's ID before uploading
      // avatar.id = avatarId;

      await avatarsCollection.add(avatar.toMap());

      print('Avatar uploaded to Firestore successfully!');
    } catch (error) {
      print('Error uploading avatar to Firestore: $error');
      // Handle errors appropriately (e.g., display error messages, retry logic)
    }
  }
}
