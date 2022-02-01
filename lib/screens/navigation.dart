import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pandasaver/functions/recieveSharingIntent.dart';

import 'package:pandasaver/screens/downloadsScreen.dart';
import 'package:pandasaver/screens/homeScreen.dart';
import 'package:pandasaver/shared/consts.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

int navBarIndex = 0;

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context)!;
    return Scaffold(
        body: navBarIndex == 0 ? const HomeScreen() : const DownloadsScreen(),
        bottomNavigationBar: BottomNavigationBar(
            elevation: 2,
            fixedColor: primaryColor,
            backgroundColor: Colors.grey.shade200,
            currentIndex: navBarIndex,
            onTap: (value) {
              setState(() {
                navBarIndex = value;
              });
            },
            iconSize: 30,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  label: tr.navHome,
                  icon: const Center(child: Icon(Icons.home_rounded))),
              BottomNavigationBarItem(
                  label: tr.navDownloads,
                  icon: const Center(child: Icon(Icons.download_rounded))),
            ]));
  }
}
