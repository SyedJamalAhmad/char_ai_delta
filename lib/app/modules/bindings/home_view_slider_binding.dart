import 'package:character_ai_delta/app/modules/controllers/home_view_slider_ctl.dart';
import 'package:get/get.dart';

class HomeViewSliderBinding extends Bindings {
  @override
  void dependencies() {
     Get.put(HomeViewSliderCtl());
  }
}
