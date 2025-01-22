import 'package:character_ai_delta/app/data/ai_model.dart';
import 'package:character_ai_delta/app/data/firbase_charecters.dart';
import 'package:character_ai_delta/app/modules/controllers/home_view_slider_ctl.dart';
import 'package:character_ai_delta/app/modules/views/gf_chat_view.dart';
import 'package:character_ai_delta/app/modules/views/new_gf_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewSlider extends GetView<HomeViewSliderCtl> {
  const HomeViewSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.aiChatModelsList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat Views'),
          bottom: TabBar(
            isScrollable: true,
            tabs: controller.aiChatModelsList.map((aiChatModel) {
              return Tab(text: aiChatModel.name);
            }).toList(),
          ),
        ),
       body: TabBarView(
          children: controller.aiChatModelsList.map((aiChatModel) {
            int index = controller.aiChatModelsList.indexOf(aiChatModel);
            FirebaseCharecter character = controller.firebaseCharactersList[index];
            
            // Passing arguments to the GfChatView
            return NewGfChatView(arguments: [aiChatModel, character]);
          }).toList(),
        ),
      
      ),
    );
  }

  // Widget buildChatView(AIChatModel aiChatModel) {
  //   FirebaseCharecter character = controller.firebaseCharactersList
  //       .firstWhere((char) => char.title == aiChatModel.name);
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text('Chat View for ${aiChatModel.name}'),
  //         // Add more widgets to display character details or chat interface
  //       ],
  //     ),
  //   );
  // }
}
