// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:pandasaver/functions/download.dart';
// import 'package:pandasaver/shared/consts.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController videoController;
//   late Future<void> initializeVideoPlayer;
//   @override
//   void initState() {
//     videoController = VideoPlayerController.file(File(
//         '${tasks[selectedVideoPathIndex].savedDir}/${tasks[selectedVideoPathIndex].filename}'));
//     initializeVideoPlayer = videoController.initialize();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     videoController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: initializeVideoPlayer,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Column(
//             children: [
//               Expanded(
//                 child: AspectRatio(
//                   aspectRatio: videoController.value.aspectRatio,
//                   child: VideoPlayer(videoController),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(color: bgColor.withOpacity(.5)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           if (selectedVideoPathIndex != 0) {
//                             selectedVideoPathIndex--;
//                           }
//                           videoController = VideoPlayerController.file(File(
//                               '${tasks[selectedVideoPathIndex].savedDir}/${tasks[selectedVideoPathIndex].filename}'));
//                           initializeVideoPlayer = videoController.initialize();
//                         });
//                       },
//                       child: Icon(Icons.skip_previous_rounded),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           if (videoController.value.isPlaying) {
//                             videoController.pause();
//                           } else {
//                             videoController.play();
//                           }
//                         });
//                       },
//                       child: Icon(
//                         videoController.value.isPlaying
//                             ? Icons.pause_rounded
//                             : Icons.play_arrow_rounded,
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           if (selectedVideoPathIndex != tasks.length) {
//                             selectedVideoPathIndex++;
//                           }
//                           videoController = VideoPlayerController.file(File(
//                               '${tasks[selectedVideoPathIndex].savedDir}/${tasks[selectedVideoPathIndex].filename}'));
//                           initializeVideoPlayer = videoController.initialize();
//                         });
//                       },
//                       child: Icon(Icons.skip_next_rounded),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return const Center(
//             child: CircularProgressIndicator.adaptive(),
//           );
//         }
//       },
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pandasaver/functions/download.dart';
import 'package:pandasaver/shared/VideoControls.dart';
import 'package:video_player/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';

late int selectedVideoPathIndex;

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

late FlickManager flickManager;
late Function updateVideo;

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(File(
          '${tasks[selectedVideoPathIndex].savedDir}/${tasks[selectedVideoPathIndex].filename}')),
    );
    print(
        '${tasks[selectedVideoPathIndex].savedDir}/${tasks[selectedVideoPathIndex].filename}');
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    updateVideo = () {
      setState(() {
        flickManager.handleChangeVideo(
          VideoPlayerController.file(File(
              '${tasks[selectedVideoPathIndex].savedDir}/${tasks[selectedVideoPathIndex].filename}')),
        );
        print(
            '${tasks[selectedVideoPathIndex].savedDir}/${tasks[selectedVideoPathIndex].filename}');
      });
    };
    return Container(
      child: FlickVideoPlayer(
        flickManager: flickManager,
        flickVideoWithControls: FlickVideoWithControls(
          controls: VideoControls(),
        ),
      ),
    );
  }
}
