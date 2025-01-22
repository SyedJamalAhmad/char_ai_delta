import 'package:get/get.dart';

import '../controllers/intro_screens_controller.dart';

class IntroScreensBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(IntroScreensController());
    // Get.put(NavCTL());
    // Get.put(HomeViewCTL());
    // Get.put(GfChatViewController());
    // Get.put(CreateAvatarCTL());
    // Get.put(SettingsCTL());
  }
}
