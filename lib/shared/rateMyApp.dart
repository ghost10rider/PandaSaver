import 'package:flutter/scheduler.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 0, // Show rate popup on first day of install.
  minLaunches:
      8, // Show rate popup after 5 launches of app after minDays is passed.
  remindDays: 120,
  googlePlayIdentifier: 'app.pandasaver',
  //TODO appstore id
  appStoreIdentifier: '',
);

checkRateMyApp(context, mounted) {
  SchedulerBinding.instance?.addPostFrameCallback((_) async {
    await rateMyApp.init();
    if (mounted && rateMyApp.shouldOpenDialog) {
      AppLocalizations tr = AppLocalizations.of(context)!;
      rateMyApp.showRateDialog(
        context,
        title: tr.rateAppTitle,
        message: tr.rateAppMessage,
        rateButton: tr.rateAppRatebutton,
        laterButton: tr.rateAppLaterButton,
        noButton: tr.rateAppNoButton,
        onDismissed: () =>
            rateMyApp.callEvent(RateMyAppEventType.noButtonPressed),
      );
    }
  });
}
