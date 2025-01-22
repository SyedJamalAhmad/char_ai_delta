import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class SettingsCTL extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  ShareApp() {
    Share.share(
        "Consider downloading this exceptional app, available on the Google Play Store at the following link: https://play.google.com/store/apps/details?id=character.avatar.ai.app.novax");
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
