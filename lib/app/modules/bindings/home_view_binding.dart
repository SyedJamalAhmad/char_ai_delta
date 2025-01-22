
import 'package:character_ai_delta/app/modules/controllers/home_view_ctl.dart';
import 'package:get/get.dart';

class HomeViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeViewCTL());
    // Get.put(GfChatViewController());
  }
}
