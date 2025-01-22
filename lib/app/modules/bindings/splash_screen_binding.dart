import 'package:character_ai_delta/app/modules/controllers/splash_screen_ctl.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
