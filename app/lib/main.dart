// import 'dart:_http';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_twitch/flutter_twitch.dart';
import 'package:flutter_twitch_auth/flutter_twitch_auth.dart';
import 'package:flutter_twitch_auth/globals.dart' as globals;
import './streamer.dart';
import 'fetch.dart';
import 'page_manager.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

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
  late final PageManager _pageManager;

  @override
  void initState() {
    super.initState();
    _pageManager = PageManager();
  }

  void _handleTwitchSignIn() async {
    user = await FlutterTwitchAuth.authToUser(context);

    setState(() {});
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
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
              // width: null,
              child: user == null ? twitchButton() : streamRadio(user!),
            ),
          ],
        ),
      ),
    );
  }

  Widget twitchButton() {
    return SizedBox(
        width: 280,
        child: ElevatedButton(
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
        ));
  }

  Widget streamRadio(user) {
    globals.userId = user.id;

    return SizedBox(
      height: 700,
      child: Column(children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Spacer(),
              ValueListenableBuilder<ProgressBarState>(
                valueListenable: _pageManager.progressNotifier,
                builder: (_, value, __) {
                  return ProgressBar(
                    progress: value.current,
                    buffered: value.buffered,
                    total: value.total,
                    onSeek: _pageManager.seek,
                  );
                },
              ),
              ValueListenableBuilder<ButtonState>(
                valueListenable: _pageManager.buttonNotifier,
                builder: (_, value, __) {
                  switch (value) {
                    case ButtonState.loading:
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        width: 32.0,
                        height: 32.0,
                        child: const CircularProgressIndicator(),
                      );
                    case ButtonState.paused:
                      return IconButton(
                        icon: const Icon(Icons.play_arrow),
                        iconSize: 32.0,
                        onPressed: _pageManager.play,
                      );
                    case ButtonState.playing:
                      return IconButton(
                        icon: const Icon(Icons.pause),
                        iconSize: 32.0,
                        onPressed: _pageManager.pause,
                      );
                  }
                },
              ),
            ],
          ),
        )),
        Container(height: 50, color: Colors.grey),
        SizedBox(
            width: 300.0,
            height: 300.0,
            child: FutureBuilder(
              future: fetchFollowedStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final streamerList = snapshot.data as List<Streamer>;

                  return Scaffold(
                    body: Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                    height: 200, // Some height
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        for (var item in streamerList)
                                          ListTile(
                                            leading: Image(
                                              image: NetworkImage(item
                                                  .thumbnailUrl!
                                                  .replaceAll('{width}', '30')
                                                  .replaceAll(
                                                      '{height}', '30')),
                                            ),
                                            title: Text(item.userName!),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                      ],
                                    ));
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.black87,
                          primary: Colors.purple,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        ),
                        child: const Text(
                          '⇈ FOLLOWED CHANNELS ⇈',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  // handle error here
                  return Text('${snapshot.error}');
                } else {
                  return const CircularProgressIndicator(); // displays while loading data
                }
              },
            ))
      ]),
    );
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
