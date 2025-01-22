import 'package:character_ai_delta/app/modules/controllers/settings_ctl.dart';
import 'package:get/get.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsCTL());
  }
}
