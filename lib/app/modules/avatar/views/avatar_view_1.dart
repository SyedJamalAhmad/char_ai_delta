import 'package:character_ai_delta/app/modules/avatar/controller/intro_avatar_ctl.dart';
import 'package:character_ai_delta/app/utills/colors.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class Avatar1 extends GetView<IntroAvatarCTL> {
  const Avatar1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Character Info",
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 6,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
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
            verticalSpace(SizeConfig.blockSizeVertical * 10),
            Text(
              "Your character's name",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 1),
            Text(
              "We use this information to create character",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.grey),
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 10),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 10,
                  right: SizeConfig.blockSizeHorizontal * 10),
              child: Row(
                children: [
                  Text(
                    "Name",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 5,
                        color: Colors.white),
                  ),
                  horizontalSpace(SizeConfig.blockSizeHorizontal * 4),
                  Expanded(
                    child: TextFormField(
                      controller: controller.avatarNameTextCTL,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Ashley, Mia, Jake, etc.",
                        hintStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4,
                            color: Colors.grey.shade700),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 4),
                        // Set the color of the cursor
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .white), // Set the color of the focused border
                        ),
                      ),
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 3),
            Obx(() => Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: controller.nameOptions
                      .map(
                        (option) => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: ChoiceChip(
                              label: Text(option),
                              labelStyle: TextStyle(
                                color: controller.nameSelectedOptions
                                        .contains(option)
                                    ? AppColors.cardBackground_color
                                    : Color(0xFF00DADD),
                                letterSpacing: 1,
                              ),
                              selected: controller.nameSelectedOptions
                                  .contains(option),
                              onSelected: (selected) {
                                if (selected) {
                                  controller.nameSelectedOptions.clear();
                                  controller.nameSelectedOptions.add(option);
                                  controller.avatarNameTextCTL.text = option;
                                }
                              },
                              // ? Commented by jamal start
                              // onSelected: (selected) {
                              //   if (selected) {
                              //     if (controller.nameSelectedOptions.length <
                              //         1) {
                              //       controller.nameSelectedOptions.add(option);
                              //       controller.avatarNameTextCTL.text = option;
                              //     } else {
                              //       EasyLoading.showError(
                              //           "Please Select one name");
                              //     }
                              //   } else {
                              //     controller.selectedOptions.remove(option);
                              //   }
                              // },
                              // ? Commented by jamal end
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color:
                                      Colors.white, // set border color to white
                                  width: 1, // set border width
                                ),
                              ),
                              backgroundColor: AppColors.cardBackground_color
                              //   Theme.of(context)
                              // .scaffoldBackgroundColor, // set background color to transparent
                              // selectedColor: Colors.white,
                              ),
                        ),
                      )
                      .toList(),
                )),
            Spacer(),
            GestureDetector(
              onTap: () {
                if (controller.avatarNameTextCTL.text.isEmpty) {
                  EasyLoading.showError("Please write the name..");
                } else {
                  controller.tabIndex.value = 1;
                }
              },
              child: Container(
                margin:
                    EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 4),
                height: SizeConfig.blockSizeVertical * 7,
                width: SizeConfig.blockSizeHorizontal * 70,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo, // Shadow color
                        spreadRadius: 0, // Spread radius
                        blurRadius: 10, // Blur radius
                        offset: Offset(0, 2), // Offset in x and y direction
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 10),
                    color: AppColors.ScaffoldColor,
                    border: Border.all(color: Colors.indigo)

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
