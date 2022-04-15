// import 'dart:_http';
import 'dart:convert';
import 'dart:io';

import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_twitch/flutter_twitch.dart';
import 'package:flutter_twitch_auth/flutter_twitch_auth.dart';
import 'package:flutter_twitch_auth/globals.dart' as globals;
import './streamer.dart';
import 'fetch.dart';
import 'modal_bottom_sheet.dart';

void main() {
  FlutterTwitchAuth.initialize(
    twitchClientId: globals.clientId,
    twitchClientSecret: globals.clientSecret,
    twitchRedirectUri: globals.redirectUri,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Twitch Auth Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? user;

  void _handleTwitchSignIn() async {
    user = await FlutterTwitchAuth.authToUser(context);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: user == null ? const Text("Streameradio") : TwitchUser(user!),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 240,
              child: user == null ? twitchButton() : streamRadio(user!),
            ),
          ],
        ),
      ),
    );
  }

  Widget twitchButton() {
    return ElevatedButton(
      onPressed: () => _handleTwitchSignIn(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/twitch.png',
            width: 26,
            height: 26,
          ),
          const Expanded(
            child: Text(
              "Sign in with Twitch",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xff9146ff),
        ),
        elevation: MaterialStateProperty.all<double>(3),
      ),
    );
  }

  Widget streamRadio(user) {
    globals.userId = user.id;

    // ModalBottomSheet(userId: user.id!);

    return SizedBox(
        width: 200.0,
        height: 300.0,
        child: FutureBuilder(
          future: fetchFollowedStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final streamerList = snapshot.data as List<Streamer>;
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Modal Bottom Sheet',
                    style: TextStyle(color: Colors.white),
                  ),
                  centerTitle: true,
                ),
                body: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "MODAL BOTTOM SHEET EXAMPLE",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    for (var item in streamerList)
                                      // const formatedImage = item.thumbnailUrl?.replaceAll('{width}', '15');
                                      ListTile(
                                        leading: Image(
                                          image: NetworkImage(item.thumbnailUrl!
                                              .replaceAll('{width}', '30')
                                              .replaceAll('{height}', '30')),
                                        ),
                                        title: new Text(item.userName!),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                  ],
                                );
                              });
                        },
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 15, bottom: 15),
                        color: Colors.pink,
                        child: Text(
                          'Click Me',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              // handle error here
              return Text('${snapshot.error}');
            } else {
              return CircularProgressIndicator(); // displays while loading data
            }
          },
        ));
  }
}

class TwitchUser extends StatefulWidget {
  final User user;
  const TwitchUser(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  _TwitchUserState createState() => _TwitchUserState();
}

class _TwitchUserState extends State<TwitchUser> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    globals.userId = user.id;
    log('login ${user.login}');
    log('id ${user.id}');
    log('id ${user.displayName}');
    log('description ${user.description!}');
    log('email ${user.email}');
    log('broadcasterType ${user.broadcasterType!}');
    log('viewCount ${user.viewCount.toString()}');
  }

  // Widget listUserChannels() {
  //   return ListTile()
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 45,
              height: 45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      user.profileImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            user.displayName,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
