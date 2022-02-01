import 'dart:typed_data';

import 'package:pandasaver/functions/download.dart';
import 'package:path/path.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

Future<List<dynamic>> getThumbnails(int index) async {
  bool mp4 = tasks[index].url.contains('mp4');
  String fullName;
  Uint8List? thumbnail;

  fullName = basename('${tasks[index].savedDir}/${tasks[index].filename}');

  if (mp4) {
    thumbnail = await VideoThumbnail.thumbnailData(
      video: '${tasks[index].savedDir}/${tasks[index].filename}',
      imageFormat: ImageFormat.JPEG,
      quality: 25,
    );
  }
  return [thumbnail, fullName];
}
