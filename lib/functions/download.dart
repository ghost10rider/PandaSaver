// ignore_for_file: file_names, unused_local_variable

import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:pandasaver/functions/admobService.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

late String _localPath;

void download(durl, type) async {
  bool granted = await Permission.storage.status.isGranted;
  if (granted) {
    await _prepareSaveDir();
    await FlutterDownloader.cancelAll();
    String? id = await FlutterDownloader.enqueue(
      url: durl,
      savedDir: _localPath,
      fileName: 'pandaSaver${DateTime.now().millisecondsSinceEpoch}.$type',
      saveInPublicStorage: false,
      showNotification: true,
      openFileFromNotification: true,
    );

    adCompleted = false;
  } else {
    await Permission.storage.request();
    bool granted = await Permission.storage.status.isGranted;
    if (granted) {
      download(durl, type);
    }
  }
}

late List tasks = [];
getTasks() async {
  tasks = (await FlutterDownloader.loadTasksWithRawQuery(
      query: 'SELECT * FROM task WHERE status=3'))!;
}

checkPermission() async {
  bool granted = await Permission.storage.status.isGranted;
  if (!granted) {
    Permission.storage.request();
  }
}

Future<void> _prepareSaveDir() async {
  var path = (await _findLocalPath())!;
  _localPath = '$path/Panda Saver';
  final savedDir = Directory(_localPath);
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
    savedDir.create();
  }
}

Future<String?> _findLocalPath() async {
  String? externalStorageDirPath;
  if (Platform.isAndroid) {
    try {
      // final directory = await getDownloadsDirectory();
      // externalStorageDirPath = directory!.path;
      // print('real path: ' + externalStorageDirPath);
      // print('android real path');
      // if (directory.path.isEmpty) {
      externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      print('android movies path');
      // }
    } catch (e) {
      externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      print('android downloads path');
    }
  } else if (Platform.isIOS) {
    externalStorageDirPath =
        (await getApplicationDocumentsDirectory()).absolute.path;
  }
  return externalStorageDirPath;
}
