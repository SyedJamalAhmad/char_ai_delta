import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:character_ai_delta/app/provider/admob_ads_provider.dart';
import 'package:character_ai_delta/app/utills/app_strings.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_pages.dart';

class SplashController extends GetxController {
  //TODO: Implement HomeControlle
  bool isFirstTime = true;

  final prefs = SharedPreferences.getInstance();

  var tabIndex = 0.obs;
  Rx<int> percent = 0.obs;
  Rx<bool> isLoaded = false.obs;
  @override
  void onInit() async {
     AdMobAdsProvider.instance.initialize(); //? commented by jamal
    // AppLovinProvider.instance.init();
    print('2 Fetched open: ${AppStrings.OPENAI_TOKEN}');

    RemoteConfigFunction();

    super.onInit();
    Timer? timer;
    timer = Timer.periodic(Duration(milliseconds: 500), (_) {
      int n = Random().nextInt(10) + 5;
      percent.value += n;
      if (percent.value >= 100) {
        percent.value = 100;
        // Get.offNamed(Routes.INTRO_SCREENS);
        checkFirstTime();
        // isLoaded.value = true;

        timer!.cancel();
      }
    });

    // prefs.then((SharedPreferences pref) {
    //   isFirstTime = pref.getBool('first_time') ?? true;

    //   print("Is First Time from Init: $isFirstTime");
    // });
  }

  @override
  void onReady() {
    super.onReady();
  }

  RemoteConfigFunction() {
    // checkplatform();
    GetRemoteConfig().then((value) {
      SetRemoteConfig();
    });
    //  print('2 Fetched open: ${AppStrings.OPENAI_TOKEN}');
  }

  final remoteConfig = FirebaseRemoteConfig.instance;

  Future SetRemoteConfig() async {
    print('Fetched open: ${remoteConfig.getString('OpenAiToken')}');
    print('Fetched open: ${remoteConfig.getString('HotpotApi')}');
    // print('Fetched open: ${remoteConfig.getString('isHotpotActive')}');

    AppStrings.OPENAI_TOKEN = remoteConfig.getString('OpenAiToken');
    AppStrings.HOTPOT_API = remoteConfig.getString('HotpotApi');
    // AppStrings.GOOGLE_SHOPPING_APIKEY = remoteConfig.getString('GoogleShoppingAPI');
    // AppStrings.SHOW_HOTPOT_API_IMAGES = remoteConfig.getBool('isHotpotActive');
    // AppStrings.ACTIVE_BARD = remoteConfig.getBool('activeBardForShopping');
    // AppStrings.SHOW_HOTPOT_API_IMAGES = true;
  }

  Future GetRemoteConfig() async {
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 1),
      ));

      await remoteConfig.setDefaults(const {
        // "example_param_1": 42,
        // "example_param_2": 3.14159,
        // "example_param_3": true,
        "OpenAiToken": "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",
        "HotpotApi": "k6sv13mQAF9U2Eq2HRFFuNOj0vDZYqtx3UVIBB6cSOPxrm1TUT",
        // "GoogleShoppingAPI": "886ff05605mshbebba3b2ff469aap1fb826jsn0b627542f3e9",
        // "isHotpotActive": false,
        // "activeBardForShopping": true,
      });

      await remoteConfig.fetchAndActivate();
    } on Exception catch (e) {
      // TODO
      print("Remote Config error: $e");
    }
  }

  // checkplatform() {
  //   if (Platform.isAndroid) {
  //     // Android-specific code
  //     print("platform: ${PlatFormType.Andriod}");
  //     AppStrings.PLATFORMTYP = (PlatFormType.Andriod).toString();
  //     print("platform: ${AppStrings.PLATFORMTYP}");
  //   } else if (Platform.isIOS) {
  //     // iOS-specific code
  //   }
  // }

  @override
  void onClose() {}

  void setFirstTime(bool bool) {
    prefs.then((SharedPreferences pref) {
      pref.setBool('first_time', bool);
      print("Is First Time: $isFirstTime");
    });
  }

  void checkFirstTime() {
    prefs.then((SharedPreferences pref) {
      isFirstTime = pref.getBool('first_time') ?? true;

      print("Is First Time from Init: $isFirstTime");
      if (isFirstTime) {
        Get.offNamed(Routes.HomeCarouselView);
      } else {
        Get.offNamed(Routes.HomeCarouselView);
      }
    });
  }
}
