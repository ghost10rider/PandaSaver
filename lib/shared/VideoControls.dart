import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:pandasaver/functions/download.dart';
import 'package:pandasaver/screens/videoPlayer.dart';
import 'package:pandasaver/shared/consts.dart';

class VideoControls extends StatefulWidget {
  VideoControls({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  final double iconSize = 30.0;

  final double fontSize = 12;

  final FlickProgressBarSettings? progressBarSettings =
      FlickProgressBarSettings(
    height: 5,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if ('${tasks[selectedVideoPathIndex].savedDir}/${tasks[selectedVideoPathIndex].filename}'
            .contains('mp3'))
          Positioned.fill(child: Image.asset('assets/images/mp3Icon.png')),
        Positioned.fill(
          child: FlickShowControlsAction(
            child: FlickSeekVideoAction(
              duration: Duration(seconds: 2),
              child: Center(
                child: FlickVideoBuffer(
                  child: FlickAutoHideChild(
                    showIfVideoNotInitialized: false,
                    child:
                        !'${tasks[selectedVideoPathIndex].savedDir}/${tasks[selectedVideoPathIndex].filename}'
                                .contains('mp3')
                            ? FlickPlayToggle(
                                pauseChild: Icon(
                                  Icons.pause_rounded,
                                  color: primaryColor,
                                  size: 30,
                                ),
                                playChild: Icon(
                                  Icons.play_arrow_rounded,
                                  color: primaryColor,
                                  size: 30,
                                ),
                                replayChild: Icon(
                                  Icons.replay_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              )
                            : SizedBox(),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlickVideoProgressBar(
                    flickProgressBarSettings: progressBarSettings,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (selectedVideoPathIndex != 0) {
                            selectedVideoPathIndex--;
                            updateVideo();
                          }
                        },
                        child: Icon(
                          Icons.skip_previous_rounded,
                          size: iconSize,
                        ),
                      ),
                      SizedBox(width: iconSize / 2),
                      FlickPlayToggle(
                        pauseChild: Icon(Icons.pause_rounded, size: iconSize),
                        playChild:
                            Icon(Icons.play_arrow_rounded, size: iconSize),
                        replayChild: Icon(Icons.replay_rounded, size: iconSize),
                      ),
                      SizedBox(width: iconSize / 2),
                      GestureDetector(
                        onTap: () async {
                          if (selectedVideoPathIndex != tasks.length - 1) {
                            selectedVideoPathIndex++;
                            updateVideo();
                          }
                        },
                        child: Icon(
                          Icons.skip_next_rounded,
                          size: iconSize,
                        ),
                      ),
                      SizedBox(width: iconSize / 2),
                      Row(
                        children: <Widget>[
                          FlickCurrentPosition(
                            fontSize: fontSize,
                          ),
                          FlickAutoHideChild(
                            child: Text(
                              ' / ',
                              style: TextStyle(
                                  color: Colors.white, fontSize: fontSize),
                            ),
                          ),
                          FlickTotalDuration(
                            fontSize: fontSize,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      FlickSoundToggle(
                        size: iconSize,
                      ),
                      SizedBox(
                        width: iconSize / 2,
                      ),
                      FlickFullScreenToggle(
                        size: iconSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
