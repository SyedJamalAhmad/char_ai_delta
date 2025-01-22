import 'dart:developer';

import 'package:character_ai_delta/app/data/firbase_charecters.dart';
import 'package:character_ai_delta/app/modules/Admin/admin_character/controllers/admin_char_edit_ctl.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:input_slider/input_slider.dart';
import 'package:input_slider/input_slider_form.dart';

class AdminCharEditView extends GetView<AdminCharEditCTL> {
  // final FirebaseCharecter character;

  // CharacterDetailsScreen({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.character!.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 200,
                height: 200,
                child: Image.network(controller.character!.imageUrl)),
            SizedBox(height: 16),
            Text(
              controller.character!.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text('Category: ${controller.character!.category}'),
            SizedBox(height: 16),
            Text('First Message: ${controller.character!.firstMessage}'),
            SizedBox(height: 16),
            Text('Intro: ${controller.character!.intro}'),
            SizedBox(height: 16),
            Text('Priority: ${controller.character!.priority}'),
            SizedBox(height: 16),
            if (controller.character!.historyMessages != null)
              Text('History: ${controller.character!.historyMessages}'),
            SizedBox(height: 16),
            RatingWidget(
              averageRating: controller.character!.star1!.toDouble(),
              star: 1,
            ),
            RatingWidget(
                averageRating: controller.character!.star2!.toDouble(),
                star: 2),
            RatingWidget(
                averageRating: controller.character!.star3!.toDouble(),
                star: 3),
            RatingWidget(
                averageRating: controller.character!.star4!.toDouble(),
                star: 4),
            RatingWidget(
                averageRating: controller.character!.star5!.toDouble(),
                star: 5),
            RatingWidget(
                averageRating:
                    controller.calculateAverageRating(controller.character!),
                star: 5),

            Row(
              children: [
                Text("Star1"),
                horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
                Container(
                    width: SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                      controller: TextEditingController(
                          text: controller.character!.star1!.toString()),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        controller.character!.star1 = int.parse(value);
                        log("Rating: ${controller.calculateAverageRating(controller.character!)}");
                      },
                    )),
              ],
            ),
            Row(
              children: [
                Text("Star2"),
                horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
                Container(
                    width: SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                      controller: TextEditingController(
                          text: controller.character!.star2!.toString()),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        controller.character!.star2 = int.parse(value);
                        log("Rating: ${controller.calculateAverageRating(controller.character!)}");
                      },
                    )),
              ],
            ),
            Row(
              children: [
                Text("Star3"),
                horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
                Container(
                    width: SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                      controller: TextEditingController(
                          text: controller.character!.star3!.toString()),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        controller.character!.star3 = int.parse(value);
                        log("Rating: ${controller.calculateAverageRating(controller.character!)}");
                      },
                    )),
              ],
            ),
            Row(
              children: [
                Text("Star4"),
                horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
                Container(
                    width: SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                      controller: TextEditingController(
                          text: controller.character!.star4!.toString()),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        controller.character!.star4 = int.parse(value);
                        log("Rating: ${controller.calculateAverageRating(controller.character!)}");
                      },
                    )),
              ],
            ),
            Row(
              children: [
                Text("Star5"),
                horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
                Container(
                    width: SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                      controller: TextEditingController(
                          text: controller.character!.star5!.toString()),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        controller.character!.star5 = int.parse(value);
                        log("Rating: ${controller.calculateAverageRating(controller.character!)}");
                      },
                    )),
              ],
            ),
            Row(
              children: [
                Text("Chatters"),
                horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
                Container(
                    width: SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                      controller: TextEditingController(
                          text: controller.character!.chatters!.toString()),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        controller.character!.chatters = int.parse(value);
                      },
                    )),
              ],
            ),
            Row(
              children: [
                Text("LovedBy"),
                horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
                Container(
                    width: SizeConfig.blockSizeHorizontal * 60,
                    child: TextFormField(
                      controller: TextEditingController(
                          text: controller.character!.lovedBy!.toString()),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        controller.character!.lovedBy = int.parse(value);
                        log("Value: $value");
                        log("Charecter: ${controller.character!.toJson()}");
                      },
                    )),
              ],
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 2),

            ElevatedButton(
                onPressed: () {
                  controller.saveCharecter();
                },
                child: Text("Save")),
            // Expanded(
            //   child: InputSliderForm(
            //       leadingWeight: 1,
            //       sliderWeight: 20,
            //       activeSliderColor: Colors.red,
            //       inactiveSliderColor: Colors.green[100],
            //       filled: true,
            //       vertical: true,
            //       children: [
            //         InputSlider(
            //           onChange: (value) {
            //             print("Setting 1 changed");
            //           },
            //           min: 0.0,
            //           max: 10.0,
            //           decimalPlaces: 0,
            //           defaultValue: 5.0,
            //           leading: Text("Setting 1:"),
            //         ),
            //         InputSlider(
            //           onChange: (value) {
            //             print("Setting 2 changed");
            //           },
            //           min: 0.0,
            //           max: 1.0,
            //           decimalPlaces: 3,
            //           defaultValue: 0.32,
            //         ),
            //       ]),
            // ),
          ],
        ),
      ),
    );
  }
}

class RatingWidget extends StatelessWidget {
  final double averageRating;
  final int star;

  RatingWidget({required this.averageRating, required this.star});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
            star, (index) => Icon(Icons.star, color: Colors.yellow)),
        // Icon(Icons.star, color: Colors.yellow),
        SizedBox(width: 8),
        Text(
          averageRating.toStringAsFixed(1),
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
