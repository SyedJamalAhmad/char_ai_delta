import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:character_ai_delta/app/data/ai_model.dart';
import 'package:character_ai_delta/app/data/firbase_charecters.dart';
import 'package:character_ai_delta/app/data/firebase_categories.dart';
import 'package:character_ai_delta/app/provider/applovin_ads_provider.dart';
import 'package:character_ai_delta/app/routes/app_pages.dart';
import 'package:character_ai_delta/app/utills/colors.dart';
import 'package:character_ai_delta/app/utills/images.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:character_ai_delta/app/utills/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';

import '../controllers/admin_character_controller.dart';

class AdminCharacterView extends GetView<AdminCharacterController> {
  const AdminCharacterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.ScaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.screenWidth * 0.02),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Platform.isAndroid || Platform.isIOS
                  //     ?

                  Flexible(
                    flex: 1,
                    child: Text(
                      'Character AI',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF), // #FFF in hexadecimal
                        fontFamily:
                            'Iceland', // make sure to add the font file to your project
                        fontSize: 25.0, // in logical pixels
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        // w400, // normal weight
                        height: 1.0, // normal line height
                      ),
                    ),
                  ),
                  horizontalSpace(SizeConfig.blockSizeHorizontal),

                  Platform.isIOS
                      ? Container()
                      : Flexible(
                          flex: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                // ? Commented by jamal start
                                onTap: () {
                                  Get.toNamed(Routes.GemsView);
                                },
                                // ? Commented by jamal end
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.bottomNavColor,
                                    border: Border.all(
                                        color: Colors.white, width: 0.3),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height:
                                              SizeConfig.screenHeight * 0.03,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              AppImages.gems,
                                              scale: 30,
                                            ),
                                            Obx(
                                              () => Text(
                                                " ${controller.gems.value}",
                                                style: StyleSheet
                                                    .Intro_Sub_heading2,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  SizeConfig.screenWidth * 0.01,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.02,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: controller.categoriesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error fetching categories'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final newCategory = snapshot.data!.docs
                        .where((doc) => doc.id == "New")
                        .first;

                    List<FirebaseCatagory> otherCategoriesList = snapshot
                        .data!.docs
                        .map((doc) => FirebaseCatagory.fromJson(
                            doc.data() as Map<String, dynamic>, doc.id))
                        .toList();

                    otherCategoriesList
                        .sort(((a, b) => a.priority - b.priority));

                    return Expanded(
                      child: Column(
                        children: [
                          Obx(() => Container(
                                // height: SizeConfig.blockSizeVertical * 20,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Wrap(
                                    // scrollDirection: Axis.horizontal,
                                    spacing:
                                        8.0, // Adjust spacing between chips
                                    children: [
                                      ChoiceChip(
                                        showCheckmark: false,
                                        selectedColor: Colors.white,
                                        labelStyle: controller
                                                    .selectedCategory.value ==
                                                'All'
                                            ? TextStyle(color: Colors.black)
                                            : TextStyle(color: Colors.white),
                                        backgroundColor:
                                            AppColors.bottomNavColor,
                                        // disabledColor: Colors.green,
                                        label: Text('All'),
                                        selected:
                                            controller.selectedCategory.value ==
                                                "All", // Initially select "All"
                                        onSelected: (selected) {
                                          controller.selectedCategory.value =
                                              "All";

                                          // Show all categories view
                                        },
                                      ),
                                      for (final category
                                          in otherCategoriesList)
                                        ChoiceChip(
                                          showCheckmark: false,
                                          selectedColor: Colors.white,
                                          labelStyle: controller
                                                      .selectedCategory.value ==
                                                  category.id
                                              ? TextStyle(color: Colors.black)
                                              : TextStyle(color: Colors.white),
                                          backgroundColor:
                                              AppColors.bottomNavColor,
                                          // disabledColor: Colors.green,
                                          label: Text(category.id),
                                          selected: controller
                                                  .selectedCategory.value ==
                                              category.id,
                                          onSelected: (selected) {
                                            controller.selectedCategory.value =
                                                selected ? category.id : "All";

                                            controller
                                                    .FBselectedCatagory.value =
                                                otherCategoriesList
                                                    .where((element) =>
                                                        element.id ==
                                                        controller
                                                            .selectedCategory
                                                            .value)
                                                    .first;
                                            // Navigate to individual category view
                                            // Navigator.pushNamed(
                                            //     context, '/individualCategory',
                                            //     arguments: category);
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              )),
                          verticalSpace(SizeConfig.blockSizeVertical),
                          Obx(() => Expanded(
                                child: controller.selectedCategory.value ==
                                        "All"
                                    ? _allCategoriesViews(otherCategoriesList)
                                    : _IndividualCatagoriesItemView(
                                        controller.selectedCategory.value,
                                        controller.FBselectedCatagory
                                            .value), // Display appropriate view
                              )),
                        ],
                      ),
                    );

                    //     Expanded(
                    //   child: _allCategoriesViews(otherCategoriesList),
                    // );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  ListView _allCategoriesViews(List<FirebaseCatagory> otherCategoriesList) {
    return ListView.builder(
      // itemCount: otherCategoriesList.length,
      itemCount: (otherCategoriesList.length * 2),
      itemBuilder: (context, index) {
        if (index.isEven) {
          int itemIndex = index ~/ 2; // Get category item index
          FirebaseCatagory catagory = otherCategoriesList.elementAt(itemIndex);
          // if (catagory.id == "New") {
          //   catagory.id = "Trending";
          // }
          return _catagoriesItem(catagory.id, catagory);
        } else {
          if (index % 3 == 0) {
            //? ShowAd
            return Container(
                // height: 60,
                // color: Colors.amber,
                // child: AppLovinProvider.instance.showMrecWidget()
                );
          } else {
            //?Empty Container
            return Container(
              width: 500,
              height: 2,
              // color: Colors.yellow,
            );
          }
          // Show Ad widget
        }
        // FirebaseCatagory catagory = otherCategoriesList.elementAt(index);
        // if (catagory.id == "New") {
        //   catagory.id = "Trending";
        // }
        // return _catagoriesItem(
        //     // otherCategories.elementAt(index - 1).id,
        //     catagory.id,
        //     catagory);
      },
    );
  }

  Column _catagoriesItem(String name, FirebaseCatagory category) {
    category.characters = category.characters.reversed.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 3,
              right: SizeConfig.blockSizeHorizontal * 3,
              bottom: SizeConfig.blockSizeVertical * 1),
          child: Row(
            children: [
              Text(
                name,
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  controller.FBselectedCatagory.value = category;

                  controller.selectedCategory.value = name;
                },
                child: Container(
                  // color: Colors.red,
                  child: Row(
                    children: [
                      Text(
                        "All",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      horizontalSpace(SizeConfig.blockSizeHorizontal * 2),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: SizeConfig.blockSizeHorizontal * 4,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // First ListView

        Container(
          height: SizeConfig.screenHeight * 0.3,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 2,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: category
                .characters.length, // Assuming you have 6 characters to display
            itemBuilder: (context, index) {
              return all_characters(category.characters[index],
                  name); // Call your function to build each character widget
            },
          ),
        ),
        // Second ListView

        // Add more ListViews as needed
      ],
    );
  }

  Column _IndividualCatagoriesItemView(String name, FirebaseCatagory category) {
    category.characters = category.characters.reversed.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // StaggeredGridView
        verticalSpace(SizeConfig.blockSizeVertical * 2),
        Expanded(
          child: MasonryGridView.count(
            crossAxisCount: 2, // Adjust the number of columns as needed
            // Adjust tile size as needed
            itemCount: category.characters.length,

            itemBuilder: (context, index) {
              return individual_all_characters(
                  category.characters[index], index, name);
            },
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 2,
            ),

            crossAxisSpacing: SizeConfig.blockSizeHorizontal * 2,
            mainAxisSpacing:
                SizeConfig.blockSizeVertical * 1.5, // Add spacing between rows
          ),
        ),
      ],
    );
  }

  Widget all_characters(FirebaseCharecter character, String catagory) {
    bool isNew = catagory == "Trending" ? true : false;
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: SizeConfig.blockSizeHorizontal * 35,
            height: SizeConfig.blockSizeVertical * 23,
            child: Stack(
              children: [
                Hero(
                  tag: character.title,
                  child: Container(
                    margin: EdgeInsets.only(
                        right: SizeConfig.blockSizeHorizontal * 3),
                    width: SizeConfig.blockSizeHorizontal * 35,
                    height: SizeConfig.blockSizeVertical * 23,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground_color,
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 5),
                      // Apply the border radius to the image itself
                      image: DecorationImage(
                        fit: BoxFit.cover, // Fill the entire container
                        image: CachedNetworkImageProvider(character.imageUrl),
                      ),
                    ),
                  ),
                ),
                isNew
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.terndingBoxColor,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 3),
                          ),
                          margin: EdgeInsets.all(
                              SizeConfig.blockSizeVertical * 0.8),
                          padding: EdgeInsets.all(
                              SizeConfig.blockSizeVertical * 0.8),
                          child: Text(
                            "🔥 NEW",
                            style: TextStyle(
                                color: AppColors.white_color,
                                fontSize: 9,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 1),
          Text(
            character.title,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 4,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget individual_all_characters(
      FirebaseCharecter character, int index, String catagory) {
    bool isNew = catagory == "Trending" ? true : false;
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.AdminCharEditView,
            arguments: [character, index, catagory]);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Hero(
                tag: character.title,
                child: Container(
                  margin: EdgeInsets.only(
                      right: SizeConfig.blockSizeHorizontal * 3),
                  // width: SizeConfig.blockSizeHorizontal * 35,
                  height: index % 2 == 0
                      ? SizeConfig.blockSizeVertical * 40
                      : SizeConfig.blockSizeVertical * 23,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground_color,
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 5),
                    // Apply the border radius to the image itself
                    image: DecorationImage(
                      fit: BoxFit.cover, // Fill the entire container
                      image: CachedNetworkImageProvider(character.imageUrl),
                    ),
                  ),
                ),
              ),
              isNew
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.terndingBoxColor,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.blockSizeHorizontal * 3),
                        ),
                        margin:
                            EdgeInsets.all(SizeConfig.blockSizeVertical * 0.8),
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeVertical * 0.8),
                        child: Text(
                          "🔥 NEW",
                          style: TextStyle(
                              color: AppColors.white_color,
                              fontSize: 9,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 1),
          Text(
            character.title,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 4,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  _individualCategoryView(selectedCategory) {}
}
