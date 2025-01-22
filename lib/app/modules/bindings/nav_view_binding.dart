import 'package:character_ai_delta/app/modules/controllers/create_avatar_ctl.dart';
import 'package:character_ai_delta/app/modules/controllers/home_view_ctl.dart';
import 'package:character_ai_delta/app/modules/controllers/nav_view_ctl.dart';
import 'package:character_ai_delta/app/modules/controllers/settings_ctl.dart';
import 'package:get/get.dart';

class NavViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavCTL());
    Get.put(HomeViewCTL());
    // Get.put(GfChatViewController());
    Get.put(CreateAvatarCTL());
    Get.put(SettingsCTL());
  }
}
