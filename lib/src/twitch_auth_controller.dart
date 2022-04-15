import 'package:flutter/material.dart';
import 'package:flutter_twitch/flutter_twitch.dart';
import 'package:flutter_twitch_auth/src/twitch_modal.dart';

enum ResponseType { code, token }

class FlutterTwitchAuth {
  static FlutterTwitchAuth? _instance;
  // ignore: non_constant_identifier_names
  String TWITCH_CLIENT_ID = "";
  // ignore: non_constant_identifier_names
  String TWITCH_CLIENT_SECRET = "";
  // ignore: non_constant_identifier_names
  String TWITCH_REDIRECT_URI = "";

  ResponseType twitchResponseType = ResponseType.token;
  String scope = "user:read:follows";

  static initFromFlutterTwitch(
    FlutterTwitch flutterTwitchInstance, {
    ResponseType? twitchResponseType,
  }) {
    _instance = _instance == null ? FlutterTwitchAuth() : _instance!;
    _instance?.TWITCH_CLIENT_ID = flutterTwitchInstance.TWITCH_CLIENT_ID;
    _instance?.TWITCH_CLIENT_SECRET =
        flutterTwitchInstance.TWITCH_CLIENT_SECRET;
    _instance?.TWITCH_REDIRECT_URI = flutterTwitchInstance.TWITCH_REDIRECT_URI;
    if (twitchResponseType != null) {
      _instance?.twitchResponseType = twitchResponseType;
    }
    _instance?.scope = flutterTwitchInstance.scope;
  }

  static initialize({
    required String twitchClientId,
    required String twitchClientSecret,
    required String twitchRedirectUri,
    ResponseType? twitchResponseType,
    String? scope,
  }) {
    _instance = _instance == null ? FlutterTwitchAuth() : _instance!;
    _instance?.TWITCH_CLIENT_ID = twitchClientId;
    _instance?.TWITCH_CLIENT_SECRET = twitchClientSecret;
    _instance?.TWITCH_REDIRECT_URI = twitchRedirectUri;
    if (twitchResponseType != null) {
      _instance?.twitchResponseType = twitchResponseType;
    }
    if (scope != null) {
      _instance?.scope = scope;
    }
    FlutterTwitch.initialize(
      twitchClientId: twitchClientId,
      twitchClientSecret: twitchClientSecret,
      twitchRedirectUri: twitchRedirectUri,
    );
  }

  static FlutterTwitchAuth get instance => _instance!;

  static Future<String?> authToCode(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => const TwitchModalContent(ModalResponseType.code),
    );
  }

  static Future<User?> authToUser(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => const TwitchModalContent(ModalResponseType.user),
    );
  }

  String get responseType {
    String responseType = "code";
    switch (_instance!.twitchResponseType) {
      case ResponseType.code:
        responseType = "code";
        break;
      case ResponseType.token:
        responseType = "token";
        break;
    }
    return responseType;
  }
}
