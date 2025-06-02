import 'package:character_ai_delta/app/modules/controllers/nav_view_ctl.dart';
import 'package:character_ai_delta/app/provider/meta_ads_provider.dart';
import 'package:character_ai_delta/app/utills/colors.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utills/size_config.dart';

class NavView extends GetView<NavCTL> {
  const NavView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Obx(() =>
          Container(child: controller.screens[controller.current_index.value])),
      bottomNavigationBar: Obx(() => ConvexAppBar(
            // style: TabStyle.fixed,
            style: TabStyle.react,
            elevation: 5,
            // height: SizeConfig.blockSizeVertical * 5,
            backgroundColor: AppColors.bottomNavColor,
            items: [
              TabItem(icon: Icons.home_outlined, title: "Home"),
              TabItem(icon: Icons.add, title: "Create"),
              TabItem(icon: Icons.settings_suggest_outlined, title: "Settings"),
            ],
            initialActiveIndex: controller.current_index.value,
            onTap: (int i) {
              controller.current_index.value = i;
              if (controller.navAdCounter == 3) {
                if (MetaAdsProvider.instance.isInterstitialAdLoaded) {
                  MetaAdsProvider.instance.showInterstitialAd();
                } else {
                  // AppLovinProvider.instance.showInterstitial(() {}, false);
                }
                controller.navAdCounter = 0;
              } else {
                controller.navAdCounter++;
              }
            },
          )),
    );
  }
}
