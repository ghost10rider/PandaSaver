import 'package:connectivity_plus/connectivity_plus.dart';

bool connected = true;
checkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.wifi ||
      connectivityResult == ConnectivityResult.mobile) {
    connected = true;
  } else {
    connected = false;
  }
}
