// ignore_for_file: file_names

import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pandasaver/functions/download.dart';
import 'package:pandasaver/functions/service.dart';
import 'package:pandasaver/screens/videoPlayer.dart';
import 'package:pandasaver/shared/consts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DownloadingScreen extends StatefulWidget {
  const DownloadingScreen({Key? key}) : super(key: key);

  @override
  _DownloadingScreenState createState() => _DownloadingScreenState();
}

class _DownloadingScreenState extends State<DownloadingScreen> {
  final ReceivePort _port = ReceivePort();
  String downloadID = '';
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;
  bool downloadStarted = false;

  @override
  void initState() {
    super.initState();
    downloadStarted = false;
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {
        downloadID = data[0];
        status = data[1];
        progress = data[2];
        if (progress == 100) {
          getTasks();
        }
        // print('updated');
      });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    // print('disposed');
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
    // print('sent');
  }

  @override
  Widget build(BuildContext contex) {
    double width = MediaQuery.of(contex).size.width;
    AppLocalizations tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SizedBox(
              width: width - 90,
              child: !downloadStarted
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            cover,
                            width: width,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    download(video, 'mp4');
                                    downloadStarted = true;
                                  });
                                },
                                splashColor: primaryColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  decoration: const BoxDecoration(
                                      color: blueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                    child: Text(
                                      tr.mp4,
                                      style: const TextStyle(
                                          color: Colors.white, fontFamily: 'R'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    download(music, 'mp3');
                                    downloadStarted = true;
                                  });
                                },
                                splashColor: primaryColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  decoration: const BoxDecoration(
                                      color: blueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                    child: Text(
                                      tr.mp3,
                                      style: const TextStyle(
                                          color: Colors.white, fontFamily: 'R'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Center(
                      child: InkWell(
                      customBorder: const CircleBorder(
                          side: BorderSide(color: primaryColor)),
                      onTap: () {
                        setState(() {
                          if (status == DownloadTaskStatus.complete) {
                            getTasks();
                            selectedVideoPathIndex = tasks.length - 1;
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => VideoPlayerScreen()));
                          }
                        });
                      },
                      child: CircularPercentIndicator(
                        radius: 220.0,
                        lineWidth: 13.0,
                        percent: progress >= 0 ? progress / 100.toDouble() : 0,
                        // animation: true,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: progressColor,
                        center: Center(
                          child: progress == 100 &&
                                  status == DownloadTaskStatus.complete
                              ? const Text('OPEN',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontFamily: 'M',
                                      fontSize: 24))
                              : status == DownloadTaskStatus.failed
                                  ? const Text(
                                      'Failed',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: 'M',
                                          fontSize: 24),
                                    )
                                  : Text(
                                      '$progress %',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'M',
                                          fontSize: 24),
                                    ),
                        ),
                      ),
                    ))),
        ),
      ),
    );
  }
}
