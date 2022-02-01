import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pandasaver/functions/admobService.dart';
import 'package:pandasaver/functions/checkConnection.dart';
import 'package:pandasaver/functions/download.dart';
import 'package:pandasaver/functions/fullPasteDownload.dart';
import 'package:pandasaver/functions/recieveSharingIntent.dart';
import 'package:pandasaver/shared/consts.dart';
import 'package:pandasaver/shared/rateMyApp.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

late String url;
late bool validURL;
late bool matchTikTokURL;
late Function updateLoadingStateToFalse;
late Function updateLoadingStateToTrue;
bool isLoading = false;
List<String> matches = [
  'tiktok.com',
  'vm.tiktok.com',
  'vt.tiktok.com',
  't.tiktok.com',
  'm.tiktok.com',
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    checkPermission();
    checkRateMyApp(context, mounted);
    AdmobService.bannerAd.load();
    AdmobService.createRewardedAd(context, false);
    RecieveSharing.recieveAllSharing(context);
  }

  @override
  void dispose() {
    AdmobService.bannerAd.dispose();
    RecieveSharing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context)!;
    updateLoadingStateToFalse = () {
      setState(() {
        isLoading = false;
      });
    };
    updateLoadingStateToTrue = () {
      setState(() {
        isLoading = true;
      });
    };

    getTasks();
    checkConnection();

    return Scaffold(
      backgroundColor: bgColor,
      body: connected
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Image.asset(
                        'assets/images/PandaLogo.png',
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 80),
                    Center(
                        child: Text(
                      tr.header,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontFamily: 'M',
                          letterSpacing: 1),
                    )),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        await FlutterClipboard.paste().then((value) {
                          setState(() {
                            url = value;
                            fullPasteDownload(context);
                          });
                        });
                      },
                      splashColor: primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Center(
                        child: Ink(
                          height: 50,
                          decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: !isLoading
                                  ? Text(
                                      tr.getVideo,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'R'),
                                    )
                                  : CircularProgressIndicator.adaptive(
                                      backgroundColor: bgColor,
                                    )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: AdmobService.bannerAd.size.width.toDouble(),
                      height: AdmobService.bannerAd.size.height.toDouble(),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AdWidget(
                          ad: AdmobService.bannerAd,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: Center(
                  child: Image.asset(
                'assets/images/noConnection.png',
                width: 200,
              ))),
    );
  }
}
