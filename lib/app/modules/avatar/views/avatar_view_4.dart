import 'package:character_ai_delta/app/modules/avatar/controller/intro_avatar_ctl.dart';
import 'package:character_ai_delta/app/utills/colors.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class Avatar4 extends GetView<IntroAvatarCTL> {
  const Avatar4({super.key});

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
            controller.tabIndex.value = 2;
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: SizeConfig.screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpace(SizeConfig.blockSizeVertical * 7),
              Text(
                "Your character's interest",
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 1),
              Text(
                "You can choose upto 3 interests",
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 4,
                    color: Colors.grey),
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 3),
              Obx(() => Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: controller.options
                        .map(
                          (option) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: FilterChip(
                                label: Text(option),
                                labelStyle: TextStyle(
                                  color: controller.selectedOptions
                                          .contains(option)
                                      ? AppColors.cardBackground_color
                                      : Colors.white,
                                  letterSpacing: 1,
                                ),
                                // labelStyle: GoogleFonts.londrinaSolid(
                                //   textStyle: TextStyle(
                                //     // fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                                //     fontSize: 45.sp,

                                //     color: controller.selectedOptions
                                //             .contains(option)
                                //         ? Colors.black
                                //         : Colors.white,
                                //     letterSpacing: 1,
                                //     // shadows: [
                                //     //   Shadow(
                                //     //       offset: Offset(-1, -1),
                                //     //       color: Colors.black),
                                //     //   Shadow(
                                //     //       offset: Offset(1, -1),
                                //     //       color: Colors.black),
                                //     //   Shadow(
                                //     //       offset: Offset(-1, 1),
                                //     //       color: Colors.black),
                                //     //   Shadow(
                                //     //       offset: Offset(1, 1),
                                //     //       color: Colors.black),
                                //     // ],
                                //   ),
                                // ),
                                selected:
                                    controller.selectedOptions.contains(option),
                                onSelected: (selected) {
                                  if (selected) {
                                    if (controller.selectedOptions.length < 3) {
                                      controller.selectedOptions.add(option);
                                    } else {
                                      EasyLoading.showError(
                                          "You cannot select more then 3");
                                    }
                                  } else {
                                    controller.selectedOptions.remove(option);
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors
                                        .white, // set border color to white
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
              // Spacer(),
              GestureDetector(
                onTap: () {
                  controller.tabIndex.value = 4;
                },
                child: Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8),
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
      ),
    );
  }
}
