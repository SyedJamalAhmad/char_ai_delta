import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:character_ai_delta/app/data/ai_model.dart';
import 'package:character_ai_delta/app/data/firbase_charecters.dart';
import 'package:character_ai_delta/app/data/firebase_categories.dart';
import 'package:character_ai_delta/app/modules/controllers/home_view_ctl.dart';
import 'package:character_ai_delta/app/provider/applovin_ads_provider.dart';
import 'package:character_ai_delta/app/provider/connection_provider.dart';
import 'package:character_ai_delta/app/provider/meta_ads_provider.dart';
import 'package:character_ai_delta/app/routes/app_pages.dart';
import 'package:character_ai_delta/app/utills/colors.dart';
import 'package:character_ai_delta/app/utills/images.dart';
import 'package:character_ai_delta/app/utills/size_config.dart';
import 'package:character_ai_delta/app/utills/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeCarouselView extends GetView<HomeViewCTL> {
  const HomeCarouselView({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ConnectionProvider>(context, listen: false)
        .setIgnoreConnectionCheck(false);
    return Scaffold(
        // appBar: AppBar(
        // title: Text('Chat Views'),
        // bottom: TabBar(
        //   isScrollable: true,
        //   tabs: controller.aiChatModelsList.map((aiChatModel) {
        //     return Tab(text: aiChatModel.name);
        //   }).toList(),
        // ),
        // ),
        //  body: TabBarView(
        //     children: controller.aiChatModelsList.map((aiChatModel) {
        //       int index = controller.aiChatModelsList.indexOf(aiChatModel);
        //       FirebaseCharecter character = controller.firebaseCharactersList[index];

        //       // Passing arguments to the GfChatView
        //       return NewGfChatView(arguments: [aiChatModel, character]);
        //     }).toList(),
        //   ),
        body: Container(
      color: Colors.white38,
      // padding: EdgeInsets.all(SizeConfig.blockSizeVertical),
      child: StreamBuilder<QuerySnapshot>(
          stream: controller.categoriesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error fetching categories'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final newCategory =
                snapshot.data!.docs.where((doc) => doc.id == "New").first;

            List<FirebaseCatagory> otherCategoriesList = snapshot.data!.docs
                .map((doc) => FirebaseCatagory.fromJson(
                    doc.data() as Map<String, dynamic>, doc.id))
                .toList();

            otherCategoriesList.sort(((a, b) => a.priority - b.priority));

            return _allCategoriesViews(otherCategoriesList);
            //     Expanded(
            //   child: _allCategoriesViews(otherCategoriesList),
            // );
          }),
    ));
  }

  CarouselSlider _allCategoriesViews(
      List<FirebaseCatagory> otherCategoriesList) {
    List<FirebaseCharecter> listCharacters = [];
    listCharacters =
        otherCategoriesList.expand((category) => category.characters).toList();
    listCharacters.shuffle();
    listCharacters.toSet();

    print("All Characters ${listCharacters} ${otherCategoriesList}");
    return CarouselSlider.builder(
      itemCount: listCharacters.length,
      itemBuilder: (context, index, pageIndex) {
        FirebaseCharecter catagory = listCharacters.elementAt(index);
        return all_characters(catagory);
      },
      options: CarouselOptions(
        height: SizeConfig.screenHeight,
        // enlargeCenterPage: true,
        // autoPlay: true,
        // aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        // enableInfiniteScroll: true,
        // autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 1,
      ),
    );
  }
  //[FirebaseCategory[firebase character][firebase character][firebase character]]

  Widget all_characters(FirebaseCharecter character) {
    int lovedBy = character.lovedBy!;
    return GestureDetector(
      onTap: () {
        AIChatModel aiChatModel = AIChatModel(
            character.title,
            [character.firstMessage],
            character.imageUrl,
            false,
            character.description,
            Routes.GfChatView,
            mainContainerType.avatar,
            character.historyMessages,
            character.category);

        String history = character.historyMessages ?? "";
        print("Firebase History: $history");
        controller.openAvatarChat(aiChatModel, character);

        if (controller.adCounter == 3) {
          controller.adCounter = 1;
          if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
            MetaAdsProvider.instance.showInterstitialAd();
          } else {
            AppLovinProvider.instance.showInterstitial(() {}, false);
          }
        } else {
          controller.adCounter++;
        }
      },
      child: Stack(children: [
        Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          child: Hero(
            tag: character.title,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground_color,
                image: DecorationImage(
                  fit: BoxFit.cover, // Fill the entire container
                  image: CachedNetworkImageProvider(character.imageUrl),
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.black38,
          height: SizeConfig.blockSizeVertical * 13,
          width: SizeConfig.screenWidth,
        ),
        Container(
          padding: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 5,
              right: SizeConfig.blockSizeHorizontal * 5,
              left: SizeConfig.blockSizeHorizontal * 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Platform.isAndroid || Platform.isIOS
              //     ?
              Flexible(
                flex: 1,
                child: Text(
                  character.title,
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
// [[[[[[[[[[[[[[[[[Commented by Jammal Temp]]]]]]]]]]]]]]]]]
              // Platform.isIOS
              //     ? Container()
              //     : Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           GestureDetector(
              //             onTap: () {
              //               Get.toNamed(Routes.GemsView);
              //             },
              //             child: Container(
              //               decoration: BoxDecoration(
              //                 color: AppColors.bottomNavColor,
              //                 border:
              //                     Border.all(color: Colors.white, width: 0.3),
              //                 borderRadius: BorderRadius.circular(8.0),
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.all(10.0),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     SizedBox(
              //                       height: SizeConfig.screenHeight * 0.03,
              //                     ),
              //                     Row(
              //                       children: [
              //                         Image.asset(
              //                           AppImages.gems,
              //                           scale: 30,
              //                         ),
              //                         Obx(
              //                           () => Text(
              //                             " ${controller.gems.value}",
              //                             style: StyleSheet.Intro_Sub_heading2,
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           width: SizeConfig.screenWidth * 0.01,
              //                         )
              //                       ],
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
            ],
          ),
        ),
      ]),
    );
  }

  // CarouselSlider carouselCharacterSlider() {
  //   return CarouselSlider(
  //     options: CarouselOptions(
  //       height: SizeConfig.screenHeight,
  //       // enlargeCenterPage: true,
  //       // autoPlay: true,
  //       // aspectRatio: 16 / 9,
  //       autoPlayCurve: Curves.fastOutSlowIn,
  //       // enableInfiniteScroll: true,
  //       // autoPlayAnimationDuration: Duration(milliseconds: 800),
  //       viewportFraction: 1,
  //     ),
  //     items: [
  //       // Container(
  //       //   child: Image.asset("assets/images/gem.png")
  //       // ),
  //       Stack(children: [
  //         Container(
  //           decoration: BoxDecoration(
  //             // borderRadius: BorderRadius.circular(10),
  //             color: Colors.red,
  //           ),
  //           height: SizeConfig.screenHeight,
  //           width: SizeConfig.screenWidth,
  //           alignment: Alignment.center,
  //           // padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
  //           child: Image.asset("assets/images/gem.png"),
  //         ),
  //         Container(
  //           padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               // Platform.isAndroid || Platform.isIOS
  //               //     ?
  //               Flexible(
  //                 flex: 1,
  //                 child: Text(
  //                   'Character AI',
  //                   style: TextStyle(
  //                     color: Color(0xFFFFFFFF), // #FFF in hexadecimal
  //                     fontFamily:
  //                         'Iceland', // make sure to add the font file to your project
  //                     fontSize: 25.0, // in logical pixels
  //                     fontStyle: FontStyle.normal,
  //                     fontWeight: FontWeight.bold,
  //                     // w400, // normal weight
  //                     height: 1.0, // normal line height
  //                   ),
  //                 ),
  //               ),
  //               horizontalSpace(SizeConfig.blockSizeHorizontal),

  //               Platform.isIOS
  //                   ? Container()
  //                   : Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         GestureDetector(
  //                           onTap: () {
  //                             Get.toNamed(Routes.GemsView);
  //                           },
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                               color: AppColors.bottomNavColor,
  //                               border:
  //                                   Border.all(color: Colors.white, width: 0.3),
  //                               borderRadius: BorderRadius.circular(8.0),
  //                             ),
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(10.0),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   SizedBox(
  //                                     height: SizeConfig.screenHeight * 0.03,
  //                                   ),
  //                                   Row(
  //                                     children: [
  //                                       Image.asset(
  //                                         AppImages.gems,
  //                                         scale: 30,
  //                                       ),
  //                                       Obx(
  //                                         () => Text(
  //                                           " ${controller.gems.value}",
  //                                           style:
  //                                               StyleSheet.Intro_Sub_heading2,
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         width: SizeConfig.screenWidth * 0.01,
  //                                       )
  //                                     ],
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //             ],
  //           ),
  //         ),
  //       ]),
  //     ],
  //   );
  // }
}
