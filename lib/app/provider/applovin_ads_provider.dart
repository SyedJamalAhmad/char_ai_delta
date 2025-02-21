import 'dart:io';
import 'dart:math';

import 'package:applovin_max/applovin_max.dart';
import 'package:character_ai_delta/app/utills/app_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLovinProvider {
  AppLovinProvider._privateConstructor();

  static final AppLovinProvider instance =
      AppLovinProvider._privateConstructor();

  final String _sdk_key = AppStrings.MAX_SDK;

  final String _interstitial_ad_unit_id = AppStrings.MAX_INTER_ID;
  // final String _rewarded_ad_unit_id = "ANDROID_REWARDED_AD_UNIT_ID";
  final String _banner_ad_unit_id = AppStrings.MAX_BANNER_ID;
  // final String _mrec_ad_unit_id = AppStrings.MAX_MREC_ID;

  // Create states
  RxBool isInitialized = false.obs;
  var interstitialLoadState = AdLoadState.notLoaded;
  var interstitialRetryAttempt = 0;
  var rewardedAdLoadState = AdLoadState.notLoaded;
  var rewardedAdRetryAttempt = 0;
  var isProgrammaticBannerCreated = false;
  var isProgrammaticBannerShowing = false;
  var isWidgetBannerShowing = false;
  var isProgrammaticMRecCreated = false;
  var isProgrammaticMRecShowing = false;
  var isWidgetMRecShowing = false;

  RxBool isAdsEnabled = true.obs;

  void init() {
    if (kReleaseMode) {
      initializePlugin();
    }

    // if (Platform.isIOS) {
    //   isAdsEnabled.value = false;
    // } else {
    //   isAdsEnabled.value = true;
    // }
  }

  Future<void> initializePlugin() async {
    print("Initializing SDK...");
    print("isAdsEnabled: ${isAdsEnabled.value}");
    if (!isAdsEnabled.value) return;
    MaxConfiguration? configuration = await AppLovinMAX.initialize(_sdk_key);
    if (configuration != null) {
      isInitialized.value = true;

      print("SDK Initialized: $configuration");
      AppLovinMAX.setVerboseLogging(true);

      attachAdListeners();
      AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
      AppLovinMAX.loadRewardedAd(AppStrings.MAX_Reward_ID);
      //  AppLovinMAX.createMRec(AppStrings.MAX_MREC_ID, AdViewPosition.centered);
      // AppLovinMAX.createBanner(
      //     AppStrings.MAX_BANNER_ID, AdViewPosition.bottomCenter);
    } else {
      print("SDK null");
    }
  }

  void attachAdListeners() {
    /// Interstitial Ad Listeners
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        interstitialLoadState = AdLoadState.loaded;

        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialAdReady(_interstitial_ad_unit_id) will now return 'true'
        print('Interstitial ad loaded from ' + ad.networkName);

        // Reset retry attempt
        interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        interstitialLoadState = AdLoadState.notLoaded;

        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        interstitialRetryAttempt = interstitialRetryAttempt + 1;

        int retryDelay = pow(2, min(6, interstitialRetryAttempt)).toInt();
        print('Interstitial ad failed to load with code ' +
            error.code.toString() +
            ' - retrying in ' +
            retryDelay.toString() +
            's');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        });
      },
      onAdDisplayedCallback: (ad) {
        print('Interstitial ad displayed');
        // AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        //   Future.delayed(Duration(milliseconds: 2 * 1000), () {
        // print('Interstitial ad reloading after display');

        //   AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        // });
      },
      onAdDisplayFailedCallback: (ad, error) {
        interstitialLoadState = AdLoadState.notLoaded;
        print('Interstitial ad failed to display with code ' +
            error.code.toString() +
            ' and message ' +
            error.message);
      },
      onAdClickedCallback: (ad) {
        print('Interstitial ad clicked');
      },
      onAdHiddenCallback: (ad) {
        interstitialLoadState = AdLoadState.notLoaded;
        Future.delayed(Duration(milliseconds: 2 * 1000), () {
          print('Interstitial ad reloading after display');

          AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        });
        print('Interstitial ad hidden');
      },
    ));

    /// Banner Ad Listeners
    AppLovinMAX.setBannerListener(AdViewAdListener(onAdLoadedCallback: (ad) {
      print('Banner ad loaded from ' + ad.networkName);
      AppLovinMAX.showBanner(AppStrings.MAX_BANNER_ID);
    }, onAdLoadFailedCallback: (adUnitId, error) {
      print('Banner ad failed to load with error code ' +
          error.code.toString() +
          ' and message: ' +
          error.message);
    }, onAdClickedCallback: (ad) {
      print('Banner ad clicked');
    }, onAdExpandedCallback: (ad) {
      print('Banner ad expanded');
    }, onAdCollapsedCallback: (ad) {
      print('Banner ad collapsed');
    }));

    /// MREC Ad Listeners
    AppLovinMAX.setMRecListener(AdViewAdListener(onAdLoadedCallback: (ad) {
      print('MREC ad loaded from ' + ad.networkName);
    }, onAdLoadFailedCallback: (adUnitId, error) {
      print('MREC ad failed to load with error code ' +
          error.code.toString() +
          ' and message: ' +
          error.message);
    }, onAdClickedCallback: (ad) {
      print('MREC ad clicked');
    }, onAdExpandedCallback: (ad) {
      print('MREC ad expanded');
    }, onAdCollapsedCallback: (ad) {
      print('MREC ad collapsed');
    }));
  }

  void showInterstitial(Function onInterAdWatched, bool showDialogue) async {
    if (!isAdsEnabled.value) return;
    // if(Platform.isIOS && isInitialized.value){
    //   print(object)
    //   return;
    // }
    // interCounter++;
    // if(interCounter<4){
    //   return;
    // }
    // interCounter = 1;

    print("Interstitial ad is show is called");
    bool isInterstitialReady =
        await AppLovinMAX.isInterstitialReady(_interstitial_ad_unit_id) ??
            false;
    print("InterstitialAd Ready: $isInterstitialReady");
    // if (isInitialized.value && isInterstitialReady!) {

    // print("Interstitial ad ready to show");

    // }

    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        interstitialLoadState = AdLoadState.loaded;

        // Interstitial ad is ready to be shown. AppLovinMAX.isInterstitialAdReady(_interstitial_ad_unit_id) will now return 'true'
        print('Interstitial ad loaded from ' + ad.networkName);

        // Reset retry attempt
        interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        interstitialLoadState = AdLoadState.notLoaded;

        // Interstitial ad failed to load
        // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)
        interstitialRetryAttempt = interstitialRetryAttempt + 1;

        int retryDelay = pow(2, min(6, interstitialRetryAttempt)).toInt();
        print('Interstitial ad failed to load with code ' +
            error.code.toString() +
            ' - retrying in ' +
            retryDelay.toString() +
            's');

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        });
      },
      onAdDisplayedCallback: (ad) {
        print('Interstitial ad displayed');
        // AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        //   Future.delayed(Duration(milliseconds: 2 * 1000), () {
        // print('Interstitial ad reloading after display');

        //   AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        // });
      },
      onAdDisplayFailedCallback: (ad, error) {
        interstitialLoadState = AdLoadState.notLoaded;
        print('Interstitial ad failed to display with code ' +
            error.code.toString() +
            ' and message ' +
            error.message);
      },
      onAdClickedCallback: (ad) {
        print('Interstitial ad clicked');
      },
      onAdHiddenCallback: (ad) {
        interstitialLoadState = AdLoadState.notLoaded;
        Future.delayed(Duration(milliseconds: 2 * 1000), () {
          print('Interstitial ad reloading after display');

          AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
        });
        print('Interstitial ad hidden');
        onInterAdWatched();
      },
    ));
    if (isInterstitialReady) {
      AppLovinMAX.showInterstitial(_interstitial_ad_unit_id);
    } else {
      // ShowNo Ad Available Diologue
      if (showDialogue) {
        showNoAdAvailableDialog(Get.context!);
      }
      AppLovinMAX.loadInterstitial(_interstitial_ad_unit_id);
    }
  }

  void showNoAdAvailableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Ad Available'),
          content:
              Text('No ad is available at the moment. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Navigator.of(context).pop();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  //reward AD

  void showRewardedAd(Function onRewardedAdWatched, bool showDialogue) async {
    if (!isAdsEnabled.value) return;
    bool isReady =
        await AppLovinMAX.isRewardedAdReady(AppStrings.MAX_Reward_ID) ?? false;

    if (isReady) {
      AppLovinMAX.showRewardedAd(AppStrings.MAX_Reward_ID);
    } else {
      print('Loading rewarded ad...');
      rewardedAdLoadState = AdLoadState.loading;
      AppLovinMAX.loadRewardedAd(AppStrings.MAX_Reward_ID);

      if (isReady) {
        AppLovinMAX.showInterstitial(_interstitial_ad_unit_id);
      } else {
        // ShowNo Ad Available Diologue
        if (showDialogue) {
          showNoAdAvailableDialog(Get.context!);
        }
      }
    }

    AppLovinMAX.setRewardedAdListener(RewardedAdListener(
      onAdLoadedCallback: (ad) {
        rewardedAdLoadState = AdLoadState.loaded;
        print('Rewarded ad loaded from ${ad.networkName}');
        rewardedAdRetryAttempt = 0;
      },
      onAdDisplayedCallback: (ad) {
        print('Rewarded ad displayed');
      },
      onAdHiddenCallback: (ad) {
        rewardedAdLoadState = AdLoadState.notLoaded;
        print('Rewarded ad hidden');
        // Invoke the onRewardedAdWatched function when the rewarded ad is hidden
        onRewardedAdWatched();
        // temp();
      },
      onAdLoadFailedCallback: (String adUnitId, MaxError error) {},
      onAdDisplayFailedCallback: (MaxAd ad, MaxError error) {},
      onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {},
      onAdClickedCallback: (MaxAd ad) {},
    ));
  }

  temp() {
    print("Rewarded Temp");
  }

  Widget ShowBannerWidget() {
    return Container(
      // height: 60,
      // color: Colors.amber,
      child: Align(
        alignment: Alignment.center,
        child: MaxAdView(
            adUnitId: AppStrings.MAX_BANNER_ID,
            adFormat: AdFormat.banner,
            listener: AdViewAdListener(onAdLoadedCallback: (ad) {
              print('Banner widget ad loaded from ' + ad.networkName);
            }, onAdLoadFailedCallback: (adUnitId, error) {
              print('Banner widget ad failed to load with error code ' +
                  error.code.toString() +
                  ' and message: ' +
                  error.message);
            }, onAdClickedCallback: (ad) {
              print('Banner widget ad clicked');
            }, onAdExpandedCallback: (ad) {
              print('Banner widget ad expanded');
            }, onAdCollapsedCallback: (ad) {
              print('Banner widget ad collapsed');
            })),
      ),
    );
  }

  Widget showMrecWidget() {
    return Container(
      // height: 60,
      // color: Colors.amber,
      child: Align(
        alignment: Alignment.center,
        child: MaxAdView(
            adUnitId: AppStrings.MAX_MREC_ID,
            adFormat: AdFormat.mrec,
            listener: AdViewAdListener(onAdLoadedCallback: (ad) {
              print('Banner widget ad loaded from ' + ad.networkName);
            }, onAdLoadFailedCallback: (adUnitId, error) {
              print('Banner widget ad failed to load with error code ' +
                  error.code.toString() +
                  ' and message: ' +
                  error.message);
            }, onAdClickedCallback: (ad) {
              print('Banner widget ad clicked');
            }, onAdExpandedCallback: (ad) {
              print('Banner widget ad expanded');
            }, onAdCollapsedCallback: (ad) {
              print('Banner widget ad collapsed');
            })),
      ),
    );
  }
}

enum AdLoadState { notLoaded, loading, loaded }
