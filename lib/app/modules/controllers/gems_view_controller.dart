import 'dart:developer';
import 'package:character_ai_delta/app/modules/controllers/home_view_ctl.dart';
import 'package:character_ai_delta/app/utills/gems_rate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GemsViewController extends GetxController {
  //TODO: Implement GemsViewController

  int initialGems = 20;
  RxInt gems = 0.obs;
  bool? firstTime = false;
  HomeViewCTL homectl = Get.find();

  final RxList<Package> packageList = <Package>[].obs;
  RxInt selectedIndex = 0.obs;
  // NavCTL navCTL = Get.find(); // ? Commented by jamal
  final count = 0.obs;
  RxBool notloading = true.obs;
  // final user = FirebaseAuth.instance.currentUser; // ? Commented by jamal
  RxString less_coins_heading = "10 Gems Package".obs;
  RxString less_coins_price = "Rs 120.99".obs;
  RxString less_coins_sub_heading = "This package will give 10 Gems".obs;

  RxString high_coins_heading = "100 Gems Package".obs;
  RxString high_coins_price = "Rs 1200.99".obs;
  RxString high_coins_sub_heading = "This package will give 100 Gems".obs;

  int hackCount = 0;
  // final RevenueCatService revenueCatService = RevenueCatService(); // ? Commented by jamal
  @override
  Future<void> onInit() async {
    super.onInit();
    await printGems();
    // packageList.value = await _revenueCatService.getProducts();
  }

  printGems() async {
    // ? Commented by jamal start
    // revenueCatService.initialize('').then((value) async {
    //   final packageList = await revenueCatService.getProducts();
    // });// ? Commented by jamal end
    log("Products Length: ${packageList}");
  }

//   Future<void> purchaseSubscription(Package package) async {
//     if (user!=null) {
//       print("Sign IN");
//   notloading.value = false;
//   // await _revenueCatService.purchaseSubscriptionWithProduct(package);
//   await revenueCatService.purchaseSubscription(package).then((value) {
//     Get.back();
//     print("back to home");
//   });
// }else{
//   Get.toNamed(Routes.GOOGLE_AUTH);
//   print("not Sign IN");
// }
//   }
  Future<void> purchaseSubscription(Package package) async {
    // ? Commented by jamal start
    // await revenueCatService.purchaseSubscription(package).then((value) {
    //   Get.back();
    //   print("back to home");
    // }); // ? Commented by jamal end
  }

  increase_inter_gems() {
    homectl.increaseGEMS(GEMS_RATE.INTER_INCREAES_GEMS_RATE);
  }

  increase_reward_gems() {
    homectl.increaseGEMS(GEMS_RATE.REWARD_INCREAES_GEMS_RATE);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // increaseGEMS(int increase) async {
  //   print("value: $increase");
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   gems.value = gems.value + increase;
  //   await prefs.setInt('gems', gems.value);
  //   print("inters");
  //   getGems();
  // }

  // decreaseGEMS(int decrease) async {
  //   print("value: $decrease");
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   gems.value = gems.value - decrease;
  //   if (gems.value < 0) {
  //     gems.value = 0;
  //     await prefs.setInt('gems', gems.value);
  //   } else {
  //     await prefs.setInt('gems', gems.value);
  //   }

  //   print("inters");
  //   getGems();
  // }

  // Future CheckUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   firstTime = prefs.getBool('first_time');

  //   // var _duration = new Duration(seconds: 3);

  //   if (firstTime != null && !firstTime!) {
  //     // Not first time
  //     gems.value = prefs.getInt('gems') ?? initialGems;
  //     print("Not First time");
  //     print("${firstTime}");
  //     //     Timer(Duration(seconds: 3), () {
  //     //       // CheckUser();
  //     //       // AppLovinProvider.instance.init();
  //     //       Get.offNamed(Routes.NAV,arguments: false);
  //     // });
  //   } else {
  //     // First time
  //     prefs.setBool('first_time', false);
  //     print("First time");
  //     print("${firstTime}");
  //     await prefs.setInt('limit', 5);
  //     await prefs.setInt('mathLimit', 3);
  //     await prefs.setInt('gems', initialGems).then((value) {
  //       gems.value = prefs.getInt('gems')!;
  //     });
  //   }
  // }

  // Future<int> getGems() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (kDebugMode) {
  //     gems.value = prefs.getInt('gems') ?? 100;
  //   } else {
  //     gems.value = prefs.getInt('gems') ?? GEMS_RATE.FREE_GEMS;
  //   }
  //   print("GEMS value: ${gems.value}");
  //   return gems.value;
  // }

  void increment() => count.value++;

  void hackMethod() {
    hackCount++;
    if (hackCount == 20) {
      homectl.increaseGEMS(100);
      EasyLoading.showSuccess("Activated");
      hackCount = 0;
    }
  }
}
