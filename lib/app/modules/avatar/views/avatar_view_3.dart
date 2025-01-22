import 'package:character_ai_delta/app/modules/avatar/controller/intro_avatar_ctl.dart';
import 'package:character_ai_delta/app/utills/colors.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Avatar3 extends GetView<IntroAvatarCTL> {
  const Avatar3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Character age",
          style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 6,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            controller.tabIndex.value = 1;
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
              "Your character's age",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 1),
            Text(
              "We use this information to create characters",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.grey),
            ),
            //  ? Temporary Container
            Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 4),
              height: SizeConfig.blockSizeVertical * 30,
              width: SizeConfig.blockSizeHorizontal * 50,
              child: Image.asset(controller.avatarImageAsset),
            ),
            // ? Remove Container when Number picker added
//             Obx(
//               () => NumberPicker(
//                 itemWidth: SizeConfig.blockSizeHorizontal * 40,
//                 minValue: 300,
//                 maxValue: 1800,
//                 // value: controller.duration.value,
//                 step: 300,
//                 textMapper: (numberText) {
//                   int number = int.parse(numberText);
//                   int minutes = number ~/ 60;
//                   // int seconds = number % 60;
// // :${seconds.toString().padLeft(2, '0')}
//                   return "${minutes.toString().padLeft(2, '0')} min";
//                 },
//                 onChanged: ((value) => {
//                       // controller.duration.value = value,
//                     }),
//                 selectedTextStyle: TextStyle(
//                     fontSize: SizeConfig.blockSizeHorizontal * 7,
//                     color: Colors.white),
//                 textStyle: TextStyle(
//                     fontSize: SizeConfig.blockSizeHorizontal * 4,
//                     color: Colors.grey),
//               ),
//             ),
            verticalSpace(SizeConfig.blockSizeVertical * 5),
            Text(
              "Your character's gender",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 1),
            Text(
              "We use this information to create characters",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.grey),
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(() => ChoiceChip(
                      elevation: 20,
                      backgroundColor: AppColors.cardBackground_color,
                      selectedColor:
                          Color(0xFF00DADD), // Customize selected color
                      label: Text("Male",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              color: Colors.white)),
                      selected: controller.avatarGender.value == "Male",
                      onSelected: (selected) {
                        controller.avatarGender.value = "Male";
                      },
                    )),
                Obx(() => ChoiceChip(
                      elevation: 20,
                      backgroundColor: AppColors.cardBackground_color,
                      selectedColor:
                          Color(0xFF00DADD), // Customize selected color
                      label: Text("Female",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              color: Colors.white)),
                      selected: controller.avatarGender.value == "Female",
                      onSelected: (selected) {
                        controller.avatarGender.value = "Female";
                      },
                    )),
                Obx(() => ChoiceChip(
                      elevation: 20,
                      backgroundColor: AppColors.cardBackground_color,
                      selectedColor:
                          Color(0xFF00DADD), // Customize selected color
                      label: Text("Non-Binary",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4,
                              color: Colors.white)),
                      selected: controller.avatarGender.value == "Non-Binary",
                      onSelected: (selected) {
                        controller.avatarGender.value = "Non-Binary";
                      },
                    )),
              ],
            ),

            Spacer(),
            GestureDetector(
              onTap: () {
                controller.tabIndex.value = 3;
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
