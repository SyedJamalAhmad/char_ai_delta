import 'package:character_ai_delta/app/modules/avatar/controller/intro_avatar_ctl.dart';
import 'package:character_ai_delta/app/modules/avatar/views/avatar_view_1.dart';
import 'package:character_ai_delta/app/modules/avatar/views/avatar_view_2.dart';
import 'package:character_ai_delta/app/modules/avatar/views/avatar_view_3.dart';
import 'package:character_ai_delta/app/modules/avatar/views/avatar_view_4.dart';
import 'package:character_ai_delta/app/modules/avatar/views/avatar_view_5.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroAvatar extends GetView<IntroAvatarCTL> {
  const IntroAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: GestureDetector(
      //     onTap: () {
      //       controller.tabIndex.value;
      //     },
      //     child: Icon(
      //       Icons.arrow_back_ios_new_rounded,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: [
              Avatar1(),
              Avatar2(),
              Avatar3(),
              Avatar4(),
              Avatar5()

              //  Question1(),
              //  Question2(),
              //  Question3(),
              //  IntroView1()
            ],
          )),
    );
  }
}
