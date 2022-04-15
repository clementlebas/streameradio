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
