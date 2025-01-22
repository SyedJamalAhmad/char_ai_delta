import 'package:applovin_max/applovin_max.dart';
import 'package:character_ai_delta/app/modules/avatar/controller/intro_avatar_ctl.dart';
import 'package:character_ai_delta/app/utills/app_strings.dart';
import 'package:character_ai_delta/app/utills/colors.dart';
import 'package:character_ai_delta/app/utills/images.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Avatar2 extends GetView<IntroAvatarCTL> {
  const Avatar2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Character Image",
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 6,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            controller.tabIndex.value = 0;
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          verticalSpace(SizeConfig.blockSizeVertical * 7),
          Text(
            "Your character's photo",
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 5,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          verticalSpace(SizeConfig.blockSizeVertical * 1),
          Text(
            "What would your character look like",
            style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 4,
                color: Colors.grey),
          ),
          Expanded(
            child: Obx(() => GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: SizeConfig.blockSizeHorizontal * 4,
                  ),
                  padding: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 3,
                    left: SizeConfig.blockSizeHorizontal * 3,
                    right: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  itemCount: controller.currentList
                      .length, // Assuming you have 8 images to display
                  itemBuilder: (context, index) {
                    // Assuming AppImages is an enum containing image asset paths
                    String imageToDisplay = controller.currentList[index];
                    return create_images(
                        imageToDisplay); // Call your image creation function
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget create_images(String image) {
    return GestureDetector(
      onTap: () {
        controller.avatarImageAsset = image;
        controller.tabIndex.value = 2;
      },
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
        height: SizeConfig.blockSizeVertical * 8,
        width: SizeConfig.blockSizeHorizontal * 20,
        decoration: BoxDecoration(
            color: AppColors.cardBackground_color,
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 3)),
        child: Image.asset(
          image,
        ),
      ),
    );
  }
}
