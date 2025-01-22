import 'dart:developer';

import 'package:character_ai_delta/app/data/ai_model.dart';
import 'package:character_ai_delta/app/data/firbase_charecters.dart';
import 'package:character_ai_delta/app/data/firebase_categories.dart';
import 'package:character_ai_delta/app/utills/app_const.dart';
import 'package:character_ai_delta/app/utills/gems_rate.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_rating_dialog/slide_rating_dialog.dart';

class AdminCharEditCTL extends GetxController {
  //TODO: Implement AdminCharacterController
  FirebaseCharecter? character;

  double get averageRating {
    int totalStars = (character!.star1 ?? 0) +
        (character!.star2 ?? 0) +
        (character!.star3 ?? 0) +
        (character!.star4 ?? 0) +
        (character!.star5 ?? 0);
    int totalReviews = [
      character!.star1,
      character!.star2,
      character!.star3,
      character!.star4,
      character!.star5
    ].where((star) => star != null).length;

    return totalReviews > 0 ? totalStars / totalReviews : 0.0;
  }

  // bool? firstTime = false;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit

    final arguments = Get.arguments;
    character = arguments[0];
    super.onInit();
  }

  double calculateAverageRating(FirebaseCharecter character) {
    int totalRatings = _countTotalRatings(character);
    if (totalRatings == 0) return 0.0;

    double sum = 0.0;
    if (character.star1 != null) sum += character.star1! * 1;
    if (character.star2 != null) sum += character.star2! * 2;
    if (character.star3 != null) sum += character.star3! * 3;
    if (character.star4 != null) sum += character.star4! * 4;
    if (character.star5 != null) sum += character.star5! * 5;

    return sum / totalRatings;
  }
  //? Firebase Implementation

  int _countTotalRatings(FirebaseCharecter character) {
    int count = 0;
    if (character.star1 != null) count += character.star1!;
    if (character.star2 != null) count += character.star2!;
    if (character.star3 != null) count += character.star3!;
    if (character.star4 != null) count += character.star4!;
    if (character.star5 != null) count += character.star5!;
    return count;
  }

  Future<void> saveCharecter() async {
    EasyLoading.show(status: "Saving Charecter...");
    if (character != null) {
      try {
        await editCharacter(character!.category, character!.title, character!);

        log("Charecter: ${character!.toJson()}");
        EasyLoading.showSuccess("Saved");
        EasyLoading.dismiss();
      } on Exception catch (e) {
        EasyLoading.showError("Error in Saving");

        log("Error Editing Char: $e"); // TODO
      }
    }
  }

  Future<void> editCharacter(String category, String characterName,
      FirebaseCharecter updatedCharacter) async {
    final categoriesRef = FirebaseFirestore.instance
        .collection(APPConstants.CharecterCollection)
        .doc(APPConstants.CatagoriesCollection)
        .collection('categories');

    final categoryDoc = await categoriesRef.doc(category).get();

    if (categoryDoc.exists) {
      // Get the list of characters
      List<dynamic> characters = categoryDoc.data()!['characters'];

      // Find the index of the character with the specified name
      int characterIndex =
          characters.indexWhere((char) => char['title'] == characterName);

      if (characterIndex != -1) {
        // Update the character
        characters[characterIndex] = updatedCharacter.toJson();

        // Save the updated list back to Firestore
        await categoryDoc.reference.update({'characters': characters});
      } else {
        log('Character not found');
      }
    } else {
      log('Category not found');
    }
  }
}
