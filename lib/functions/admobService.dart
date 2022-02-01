// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pandasaver/screens/downloadingScreen.dart';
import 'package:pandasaver/screens/homeScreen.dart';

RewardedAd? rewardedAd;
bool? adCompleted;

class AdmobService {
  static String get rewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-8391030397391371/1415621508'
      : 'ca-app-pub-8391030397391371/1858442810';

  static Initialize() {
    MobileAds.instance.initialize();
  }

  static createRewardedAd(context, show) {
    if (rewardedAd != null && show) {
      showRewardedAd(context);
      print('showing first');
    } else {
      RewardedAd.load(
          //TODO real id
          adUnitId: RewardedAd.testAdUnitId,
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              print('$ad has loaded');
              rewardedAd = ad;
              if (show) {
                showRewardedAd(context);
              }
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('RewardedAd failed to load: $error');
            },
          ));
    }
  }

  static showRewardedAd(context) async {
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdShowedFullScreenContent.');
        updateLoadingStateToFalse();
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        updateLoadingStateToFalse();
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        updateLoadingStateToFalse();
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => print('$ad impression occurred.'),
    );
    rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      Navigator.push(context,
          CupertinoPageRoute(builder: (context) => const DownloadingScreen()));
      createRewardedAd(context, false);
      updateLoadingStateToFalse();
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-8391030397391371/4544417537'
      : 'ca-app-pub-8391030397391371/1562853365';
//TODO real id
  static final BannerAd bannerAd = BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.largeBanner,
    request: AdRequest(),
    listener: BannerAdListener(
      onAdFailedToLoad: (Ad ad, LoadAdError error) => ad.dispose(),
      onAdClosed: (Ad ad) => ad.dispose(),
    ),
  );
}
