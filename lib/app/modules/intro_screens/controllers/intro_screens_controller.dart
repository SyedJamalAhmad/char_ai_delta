import 'package:character_ai_delta/app/provider/applovin_ads_provider.dart';
import 'package:character_ai_delta/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreensController extends GetxController {
  //TODO: Implement IntroScreensController

  final count = 0.obs;
  final prefs = SharedPreferences.getInstance();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void goToHomePage() {
    setFirstTime(true);
    AppLovinProvider.instance.showInterstitial(() {}, false);
  }

  void setFirstTime(bool bool) {
    prefs.then((SharedPreferences pref) {
      pref.setBool('first_time', bool);
      Get.offNamed(Routes.NavView);
    });
  }
}
