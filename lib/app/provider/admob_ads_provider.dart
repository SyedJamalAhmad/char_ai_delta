import 'package:character_ai_delta/app/utills/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app_lifecycle_reactor.dart';
import 'app_open_admanager.dart';

class AdMobAdsProvider {
  AdMobAdsProvider._privateConstructor();

  static final AdMobAdsProvider instance =
      AdMobAdsProvider._privateConstructor();

  InterstitialAd? _interstitialAd;

  int _numInterstitialLoadAttempts = 0;

  AppOpenAd? appOpenAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;

  // RewardedInterstitialAd? _rewardedInterstitialAdGame;
  // int _numRewardedInterstitialLoadAttemptsGame = 0;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  RxBool isAdEnable = true.obs;
  bool isInitialized = false;

  // String get interstitialAdUnitId => 'your_interstitial_ad_unit_id_here';
  String get interstitialAdUnitId =>
      'ca-app-pub-3940256099942544/1033173712'; // TEST ID

  int maxFailedLoadAttempts = 3;
  int adShowDelay = 30;
  DateTime? _lastInterstitialShownTime;
  Future<void> initialize() async {
    try {
      RequestConfiguration(testDeviceIds: ["48EB03B28964CF26EC2FB322A74E47DD"]);
      _lastInterstitialShownTime =
          DateTime.now().subtract(Duration(seconds: 50));
      _createInterstitialAd();
      createRewardedAd();
      // initBanner();
      appOpenLoad();
    } catch (e, s) {
      print('Error in initialize(): $e\n$s');
    }
  }

  void _createInterstitialAd() {
    try {
      InterstitialAd.load(
        adUnitId: AppStrings.ADMOB_INTERSTITIAL,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ),
      );
    } catch (e, s) {
      print('Error in _createInterstitialAd(): $e\n$s');
    }
  }

  void showInterstitialAd() {
    try {
      Duration timeSinceLastShown = DateTime.now()
          .difference(_lastInterstitialShownTime ?? DateTime.now());

      if (timeSinceLastShown.inSeconds < adShowDelay) {
        int remainingTime = adShowDelay - timeSinceLastShown.inSeconds;
        print(
            'Interstitial ad not ready yet. $remainingTime seconds remaining.');
        return;
      }

      if (_interstitialAd == null) {
        print('Warning: No interstitial ad loaded.');
        return;
      }

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) => print('Interstitial shown.'),
        onAdDismissedFullScreenContent: (ad) {
          print('Interstitial dismissed.');
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Interstitial failed to show: $error');
          ad.dispose();
          _createInterstitialAd();
        },
      );

      _interstitialAd!.show();
      _interstitialAd = null;
      _lastInterstitialShownTime = DateTime.now();
    } catch (e, s) {
      print('Error in showInterstitialAd(): $e\n$s');
    }
  }

//? ----------------------------------AppOPEN--------------------------------
  late AppLifecycleReactor _appLifecycleReactor;
  late AppOpenAdManager appOpenAdManager;
  void appOpenLoad() {
    if (AppOpenAdManager().appOpenAd == null) {
    } else {
      appOpenAdManager = AppOpenAdManager()..loadAppOpenAd();
      _appLifecycleReactor =
          AppLifecycleReactor(appOpenAdManager: appOpenAdManager);

      _appLifecycleReactor.listenToAppStateChanges();
      print("AppOpen Load from HomeCTL");
    }
  }

  void showAppOpen() {
    appOpenAdManager.showAdIfAvailable();
  }

//?-----------------------------------End App Open--------------------------

// Banner Implementation

  late BannerAd myBanner;
  RxBool isBannerLoaded = false.obs;
  void initBanner() {
    try {
      BannerAdListener listener = BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Banner loaded.');
          isBannerLoaded.value = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Banner failed to load: $error');
        },
      );

      myBanner = BannerAd(
        adUnitId: AppStrings.ADMOB_BANNER,
        size: AdSize.mediumRectangle,
        request: AdRequest(),
        listener: listener,
      );

      myBanner.load();
    } catch (e, s) {
      print('Error in initBanner(): $e\n$s');
    }
  }

  //? Native Ad Implementation
  NativeAd? _nativeAd;
  RxBool nativeAdIsLoaded = false.obs;

  // initNative() {
  //   _nativeAd = NativeAd(
  //     adUnitId: AppStrings.ADMOB_NATIVE,
  //     request: AdRequest(),
  //     factoryId: 'adFactoryExample',
  //     listener: NativeAdListener(
  //       onAdLoaded: (Ad ad) {
  //         print('$NativeAd loaded.');

  //         nativeAdIsLoaded.value = true;
  //       },
  //       onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //         print('$NativeAd failedToLoad: $error');
  //         ad.dispose();
  //       },
  //       onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
  //       onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
  //     ),
  //   )..load();
  // }

  //?Reward Inter Implementation

  /// Loads a rewarded ad.
  /// //? commented by jamal start
  // void _createRewardedInterstitialAd() {
  //   RewardedInterstitialAd.load(
  //       adUnitId: AppStrings.ADMOB_REWARDED_Inter,
  //       request: AdRequest(),
  //       rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
  //         onAdLoaded: (RewardedInterstitialAd ad) {
  //           print('$ad loaded.');
  //           _rewardedInterstitialAd = ad;
  //           _numRewardedInterstitialLoadAttempts = 0;
  //         },
  //         onAdFailedToLoad: (LoadAdError error) {
  //           print('RewardedInterstitialAd failed to load: $error');
  //           _rewardedInterstitialAd = null;
  //           _numRewardedInterstitialLoadAttempts += 1;
  //           if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
  //             _createRewardedInterstitialAd();
  //           }
  //         },
  //       ));
  // }
  //? commented by jamal end

  bool isRewardedInterAdLoaded() {
    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return false;
    } else {
      return true;
    }
  }

  showRewardedInter(Function onRewardedFun) {
    print("Show Rewarded Called");

    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        // _createRewardedInterstitialAd();//? commented by jamal
      },
      onAdFailedToShowFullScreenContent:
          (RewardedInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        // _createRewardedInterstitialAd(); //? commented by jamal
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);

    _rewardedInterstitialAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) async {
      onRewardedFun();
      // Reward the user for watching an ad.
    });
  }

  showRewardedInterGame(Function onReward) {
    print("Show Rewarded Called");

    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        // _createRewardedInterstitialAd();//? commented by jamal
      },
      onAdFailedToShowFullScreenContent:
          (RewardedInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        // _createRewardedInterstitialAd();//? commented by jamal
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);

    _rewardedInterstitialAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) async {
      onReward();
      // Reward the user for watching an ad.
    });
  }

  void createRewardedAd() {
    try {
      print("Reward Ad Load Called");
      if (_rewardedAd == null) {
        RewardedAd.load(
          adUnitId: AppStrings.ADMOB_REWARDED,
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              print('Rewarded ad loaded.');
              _rewardedAd = ad;
              _numRewardedLoadAttempts = 0;
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('Rewarded ad failed to load: $error');
              _rewardedAd = null;
              _numRewardedLoadAttempts++;
              if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
                createRewardedAd();
              }
            },
          ),
        );
      }
    } catch (e, s) {
      print('Error in createRewardedAd(): $e\n$s');
    }
  }

  bool isRewardedAdLoaded() {
    if (_rewardedAd == null) {
      return false;
    } else {
      return true;
    }
  }

  ShowRewardedAd(Function onReward) {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');

      Get.back();
      EasyLoading.showError("No Ad Available try again later",
          duration: Duration(seconds: 2));
      showNoAdAvailableDialog();

      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _rewardedAd = null;

        // createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _rewardedAd = null;

        ad.dispose();
        // createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      // Reward the user for watching an ad.
      onReward();
    });
  }

  void showNoAdAvailableDialog() {
    Get.defaultDialog(
      title: "No Ad available",
      content: Text("Please try again later."),
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: Text("OK"),
      ),
    );
  }
}
