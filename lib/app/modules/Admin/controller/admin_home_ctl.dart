import 'dart:convert';
import 'dart:io';

import 'package:character_ai_delta/app/data/firbase_charecters.dart';
import 'package:character_ai_delta/app/utills/app_const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';

class AdminHomeCTL extends GetxController {
  final selectedCategory = APPConstants.categoryList[0].obs;
  final title = TextEditingController();
  final ImageLink = TextEditingController();
  final description = TextEditingController();
  final firstMessage = TextEditingController();
  final intro = TextEditingController();
  final imageFile = Rx<XFile?>(null);
  Rx<Uint8List?> memoryImageFile = Rx<Uint8List?>(null);

  RxBool imageEnabled = true.obs;

  final _loading = false.obs;
  bool get loading => _loading.value;

  // void pickImage() async {
  //   final pickedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     imageFile.value = pickedImage;
  //     if (kIsWeb) {
  //       memoryImageFile.value = await pickedImage.readAsBytes();
  //     }
  //   }
  // }

  void uploadData() async {
    print("Upload Call..");
    if (imageFile.value != null && title.text.isNotEmpty) {
      _loading.value = true;

      try {
        if (!kIsWeb) {
          print("Platform is Android");

          // Upload image to Firebase Storage
          final ref = FirebaseStorage.instance
              .ref()
              .child('images/${imageFile.value!.name}');
          final uploadTask = ref.putFile(File(imageFile.value!.path));
          final url = await (await uploadTask).ref.getDownloadURL();

          // Save data to Firebase Firestore
          final data = FirebaseCharecter(
              title: title.text,
              description: description.text,
              firstMessage: firstMessage.text,
              intro: intro.text,
              category: selectedCategory.value,
              imageUrl: url,
              historyMessages: null);
          await FirebaseFirestore.instance
              .collection(APPConstants.CharecterCollection)
              .doc(APPConstants
                  .CatagoriesCollection) // Use the category as the document ID
              .collection(selectedCategory
                  .value) // Create a subcollection with the same name
              .add(data.toJson());

          Get.snackbar('Success', 'Data uploaded successfully!');
          resetFields();
        } else {
          print("Platform is web");
          final ref = FirebaseStorage.instance
              .ref()
              .child('images/${imageFile.value!.name}');
          final metadata = SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {'picked-file-path': imageFile.value!.path},
          );

          final uploadTask = ref.putData(memoryImageFile.value!);
          final url = await (await uploadTask).ref.getDownloadURL();

          // Save data to Firebase Firestore
          final data = FirebaseCharecter(
              title: title.text,
              description: description.text,
              firstMessage: firstMessage.text,
              intro: intro.text,
              category: selectedCategory.value,
              imageUrl: url,
              historyMessages: null);

          await addCharacter(data);
          // await FirebaseFirestore.instance
          //     .collection(APPConstants.CharecterCollection)
          //     .doc(APPConstants
          //         .CatagoriesCollection) // Use the category as the document ID
          //     .collection(selectedCategory
          //         .value) // Create a subcollection with the same name
          //     .add(data.toJson());

          Get.snackbar('Success', 'Data uploaded successfully!');
          resetFields();
        }
      } catch (e) {
        print("FirebaseError: $e");
        Get.snackbar('Error', 'Failed to upload data: $e');
      } finally {
        _loading.value = false;
      }
    } else {
      Get.snackbar(
          'Error', 'Please select an image and fill in the required fields.');
    }
  }

  void resetFields() {
    title.text = '';
    description.text = '';
    firstMessage.text = '';
    intro.text = '';
    selectedCategory.value = APPConstants.categoryList[0];
    imageFile.value = null;
  }

  Future<void> addCharacter(FirebaseCharecter character) async {
    final categoriesRef = FirebaseFirestore.instance
        .collection(APPConstants.CharecterCollection)
        .doc(APPConstants.CatagoriesCollection)
        .collection('categories');

    final categoryDoc = await categoriesRef.doc(character.category).get();

    if (categoryDoc.exists) {
      // Category exists, add character to its list
      await categoryDoc.reference.update({
        'characters': FieldValue.arrayUnion([character.toJson()])
      });
    } else {
      // Category doesn't exist, create it with the character
      await categoriesRef.doc(character.category).set({
        'characters': [character.toJson()]
      });
    }
  }

  void uploadWithImageLink() async {
    print("Upload Call..");
    if (title.text.isNotEmpty && ImageLink.text.isNotEmpty) {
      _loading.value = true;

      try {
        final url = ImageLink.text;

        // Save data to Firebase Firestore
        final data = FirebaseCharecter(
            title: title.text,
            description: description.text,
            firstMessage: firstMessage.text,
            intro: intro.text,
            category: selectedCategory.value,
            imageUrl: url,
            historyMessages: null);

        await addCharacter(data);
        // await FirebaseFirestore.instance
        //     .collection(APPConstants.CharecterCollection)
        //     .doc(APPConstants
        //         .CatagoriesCollection) // Use the category as the document ID
        //     .collection(selectedCategory
        //         .value) // Create a subcollection with the same name
        //     .add(data.toJson());

        Get.snackbar('Success', 'Data uploaded successfully!');
        resetFields();
      } catch (e) {
        print("FirebaseError: $e");
        Get.snackbar('Error', 'Failed to upload data: $e');
      } finally {
        _loading.value = false;
      }
    } else {
      Get.snackbar(
          'Error', 'Please select an image and fill in the required fields.');
    }
  }

  Future<void> uploadJsonStringToFirestore(String jsonString) async {
    try {
      // Decode the JSON string into a Map
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      // Reference to the categories collection
      final categoriesRef = FirebaseFirestore.instance
          .collection(APPConstants.CharecterCollection)
          .doc(APPConstants.CatagoriesCollection)
          .collection('categories');

      // Iterate over each category and upload the data
      for (var entry in jsonData.entries) {
        await categoriesRef.doc(entry.key).set(entry.value);
      }

      print('JSON data has been uploaded successfully to Firestore.');
    } catch (e) {
      print('An error occurred while uploading JSON data: $e');
    }
  }
}
