import 'package:character_ai_delta/app/modules/avatar/controller/intro_avatar_ctl.dart';
import 'package:character_ai_delta/app/utills/colors.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class Avatar5 extends GetView<IntroAvatarCTL> {
  const Avatar5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your message",
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 6,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            controller.tabIndex.value = 3;
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            verticalSpace(SizeConfig.blockSizeVertical * 7),
            Text(
              "Your character's first message",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 1),
            Text(
              "How would introuce my themselves",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.grey),
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 5),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 13,
                    right: SizeConfig.blockSizeHorizontal * 13),
                child: TextFormField(
                  controller: controller.avatarFirstTextCTL,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    fillColor: AppColors.cardBackground_color,
                    filled: true,
                    hintText: "Type here.",

                    hintStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        color: Colors.grey.shade700),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 4,
                        vertical: SizeConfig.blockSizeVertical * 2),
                    // Set the color of the cursor
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 6),
                      borderSide: BorderSide(
                          color: Colors
                              .transparent), // Set the color of the focused border
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 6),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                      color: Colors.white),
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                if (controller.avatarFirstTextCTL.text.isEmpty) {
                  EasyLoading.showError("Please write first message");
                } else {
                  controller.SaveUserAvatar();
                }
                // // // //
              },
              child: Container(
                margin:
                    EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 4),
                height: SizeConfig.blockSizeVertical * 7,
                width: SizeConfig.blockSizeHorizontal * 70,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF00DADD), // Shadow color
                        spreadRadius: 0, // Spread radius
                        blurRadius: 10, // Blur radius
                        offset: Offset(0, 2), // Offset in x and y direction
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 10),
                    color: AppColors.ScaffoldColor,
                    border: Border.all(color: Color(0xFF00DADD))

                    // gradient: LinearGradient(colors: [
                    //   Color(0xFF00DADD),
                    //   Color(0xFF0E898A)
                    // ])
                    ),
                child: Center(
                  child: Text(
                    "Continue",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00DADD)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
