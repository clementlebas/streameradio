import 'dart:convert';

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_twitch_auth/globals.dart' as globals;
import './streamer.dart';

Future<List<Streamer>> fetchFollowedStream() async {
  var url = Uri.parse(
      'https://api.twitch.tv/helix/streams/followed?user_id=' + globals.userId);

  var response = await http.get(url, headers: {
    'Authorization': 'Bearer ${globals.codeAuth}',
    'Client-Id': globals.clientId,
    'scope': 'user:read:follows'
  });
  var data = response.body;

  StreamerList followedStreamers = StreamerList.fromJson(json.decode(data));

  for (final x in followedStreamers.data!) {
    debugPrint(x.userName);
  }
  log('Response status: ${response.statusCode}');
  log('Response body: ${response.body}');
  return followedStreamers.data!;
}

Future getChannelToken(userLogin) async {
  var url = Uri.parse('http://api.twitch.tv/helix/channels');

  log(globals.codeAuth);
  var response = await http.get(url, headers: {
    'Authorization': 'Bearer ${globals.codeAuth}',
    'Client-Id': globals.clientId,
    'scope': 'user:read:follows'
  });
  var data = response.body;

  log('getChannelToken' + data);
}

Future<String> getPhoto(userId) async {
  var url = Uri.parse('https://api.twitch.tv/helix/users?id=' + userId);

  log(globals.codeAuth);
  var response = await http.get(url, headers: {
    'Authorization': 'Bearer ${globals.codeAuth}',
    'Client-Id': globals.clientId,
    'scope': 'user:read:email'
  });
  var data = response.body;
  Map<String, dynamic> streamerProfile = jsonDecode(data);
  return streamerProfile['data'][0]['profile_image_url'];
}

Future<String> getStreamUrl(userlogin) async {
  var url = Uri.parse(
      'https://pwn.sh/tools/streamapi.py?url=https://www.twitch.tv/' +
          userlogin);

  var response = await http.get(url);
  var data = response.body;
  Map<String, dynamic> urls = jsonDecode(data);
  if (urls['success'] == true) {
    log('urls ${urls['urls']!['audio_only']!}');
    return urls['urls']!['audio_only']!;
  } else {
    return '';
  }
}
