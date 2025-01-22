// import 'package:flutter/material.dart';
import 'package:easy_audience_network/easy_audience_network.dart';

class MetaAdsProvider {
  MetaAdsProvider._privateConstructor();

  static final MetaAdsProvider instance = MetaAdsProvider._privateConstructor();
  bool isInterstitialAdLoaded = false;
  bool isRewardedAdLoaded = false;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  void initialize() {
    EasyAudienceNetwork.init(
      // testingId: "b602d594afd2b0b327e07a06f36ca6a7e42546d0",
      testMode: false,
    ).then((_) {
      _loadInterstitialAd();
      _loadRewardedVideoAd();
    });
  }

  void _loadInterstitialAd() {
    final interstitialAd = InterstitialAd("261837793602550_261838930269103");
    interstitialAd.listener = InterstitialAdListener(
      onLoaded: () {
        isInterstitialAdLoaded = true;
        print('interstitial ad loaded');
      },
      onError: (code, message) {
        print('interstitial ad error\ncode = $code\nmessage = $message');
      },
      onDismissed: () {
        // load next ad already
        interstitialAd.destroy();
        isInterstitialAdLoaded = false;
        _loadInterstitialAd();
      },
    );
    interstitialAd.load();
    _interstitialAd = interstitialAd;
  }

  void _loadRewardedVideoAd() {
    final rewardedAd = RewardedAd(RewardedAd.testPlacementId);
    rewardedAd.listener = RewardedAdListener(
      onLoaded: () {
        isRewardedAdLoaded = true;
        print('rewarded ad loaded');
      },
      onError: (code, message) {
        print('rewarded ad error\ncode = $code\nmessage = $message');
      },
      onVideoClosed: () {
        // load next ad already
        rewardedAd.destroy();
        isRewardedAdLoaded = false;
        _loadRewardedVideoAd();
      },
    );
    rewardedAd.load();
    _rewardedAd = rewardedAd;
  }

  showInterstitialAd() {
    final interstitialAd = _interstitialAd;

    if (interstitialAd != null && isInterstitialAdLoaded == true)
      interstitialAd.show();
    else
      print("Interstial Ad not yet loaded!");
  }

  showRewardedAd() {
    final rewardedAd = _rewardedAd;

    if (rewardedAd != null && isRewardedAdLoaded) {
      rewardedAd.show();
    } else {
      print("Rewarded Ad not yet loaded!");
    }
  }
}
