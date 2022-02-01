import 'dart:async';

import 'package:pandasaver/functions/fullPasteDownload.dart';
import 'package:pandasaver/screens/homeScreen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class RecieveSharing {
  static late StreamSubscription shared;
  static recieveAllSharing(context) {
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    shared = ReceiveSharingIntent.getTextStream().listen(
      (String value) {
        isLoading = true;
        url = value;
        fullPasteDownload(context);
        ReceiveSharingIntent.reset();
      },
      onError: (err) {
        print("getLinkStream error: $err");
      },
    );
    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null) {
        isLoading = true;
        url = value;
        fullPasteDownload(context);
        ReceiveSharingIntent.reset();
      }
    });
  }

  static dispose() {
    shared.cancel();
  }
}
