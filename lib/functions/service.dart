import 'dart:convert';
import 'package:http/http.dart' as http;

String api = 'https://api-19.pandasaver.net:2096/index?url=';
late String music;
late String cover;
late String video;

Future<void> getVideo(String url) async {
  var response = await http.get(Uri.parse(api + url));
  if (response.statusCode == 200) {
    music = json.decode(response.body)['music'][0];
    cover = json.decode(response.body)['cover'][0];
    video = json.decode(response.body)['video'][0];
  } else {
    cover = 'failed';
  }
}
