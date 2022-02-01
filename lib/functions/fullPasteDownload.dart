import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pandasaver/functions/admobService.dart';
import 'package:pandasaver/functions/service.dart';

import 'package:pandasaver/screens/homeScreen.dart';
import 'package:pandasaver/shared/scaffoldMessenger.dart';

fullPasteDownload(context) async {
  AppLocalizations tr = AppLocalizations.of(context)!;
  validURL = Uri.parse(url).isAbsolute;
  matchTikTokURL = false;
  updateLoadingStateToTrue();
  for (var i in matches) {
    if (url.contains(i)) {
      matchTikTokURL = true;
    }
  }
  if (validURL && matchTikTokURL) {
    await getVideo(url);
    if (cover != 'failed') {
      AdmobService.createRewardedAd(context, true);
    }
  } else {
    scaffoldMessenger(context, tr.enterValidUrl);
    updateLoadingStateToFalse();
  }
}
