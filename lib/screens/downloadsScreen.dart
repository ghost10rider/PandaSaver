// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/scheduler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:date_format/date_format.dart';
import 'package:pandasaver/functions/download.dart';
import 'package:pandasaver/functions/getThumbnails.dart';
import 'package:pandasaver/screens/videoPlayer.dart';
import 'package:pandasaver/shared/consts.dart';
import 'package:share/share.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  ScrollController listViewController = ScrollController();

  @override
  void initState() {
    super.initState();
    getTasks();
    SchedulerBinding.instance?.addPostFrameCallback((e) {
      if (tasks.isNotEmpty && listViewController.hasClients) {
        final position = listViewController.position.maxScrollExtent;
        listViewController.jumpTo(position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations tr = AppLocalizations.of(context)!;
    getTasks();
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: tasks.isNotEmpty
              ? Column(
                  children: [
                    Image.asset(
                      'assets/images/PandaLogo.png',
                      height: 90,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                        child: Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                          controller: listViewController,
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: tasks.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder(
                                future: getThumbnails(index),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  return snapshot.hasData
                                      ? Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: accentColor2,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    selectedVideoPathIndex =
                                                        index;
                                                    Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                            builder: (context) =>
                                                                VideoPlayerScreen()));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          child: snapshot.data[
                                                                      0] !=
                                                                  null
                                                              ? Image.memory(
                                                                  snapshot
                                                                      .data[0],
                                                                  width: 70,
                                                                  height: 70,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.asset(
                                                                  'assets/images/mp3Icon.png',
                                                                  width: 70,
                                                                ),
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'pandaSaver' +
                                                                snapshot.data[1]
                                                                    .toString()
                                                                    .substring(
                                                                        18,
                                                                        23) +
                                                                snapshot.data[1]
                                                                    .toString()
                                                                    .substring(
                                                                        23, 27),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        9),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            formatDate(
                                                                DateTime.fromMillisecondsSinceEpoch(tasks[
                                                                        index]
                                                                    .timeCreated),
                                                                [
                                                                  dd,
                                                                  '-',
                                                                  mm,
                                                                  '-',
                                                                  yyyy,
                                                                  '\n',
                                                                  hh,
                                                                  ':',
                                                                  nn,
                                                                  ' ',
                                                                  am
                                                                ]),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontSize: 11),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Center(
                                                        child: InkWell(
                                                          onTap: () {
                                                            snapshot.data[1] ==
                                                                    '.mp4'
                                                                ? Share.shareFiles([
                                                                    '${tasks[index].savedDir}/${tasks[index].filename}'
                                                                  ],
                                                                    text:
                                                                        'Downloaded By Panda Saver')
                                                                : Share.shareFiles([
                                                                    '${tasks[index].savedDir}/${tasks[index].filename}'
                                                                  ],
                                                                    text:
                                                                        'Downloaded By Panda Saver');
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            width: 50,
                                                            decoration: BoxDecoration(
                                                                color: bgColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6)),
                                                            child: Icon(
                                                              Icons.adaptive
                                                                  .share_rounded,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      InkWell(
                                                        onTap: () async {
                                                          FlutterDownloader.remove(
                                                              taskId:
                                                                  tasks[index]
                                                                      .taskId,
                                                              shouldDeleteContent:
                                                                  true);
                                                          await getTasks();
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 50,
                                                          decoration: BoxDecoration(
                                                              color: bgColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                          child: const Icon(
                                                            Icons
                                                                .delete_rounded,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : // const Center(
                                      const SizedBox();
                                });
                          }),
                    ))
                  ],
                )
              : Center(
                  child: Text(
                    tr.noDownloads,
                    style: const TextStyle(
                        color: Colors.white, fontFamily: 'M', fontSize: 18),
                  ),
                ),
        ),
      ),
    );
  }
}
