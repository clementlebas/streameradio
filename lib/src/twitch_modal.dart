import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_twitch/flutter_twitch.dart';
import 'package:flutter_twitch_auth/src/twitch_auth_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../globals.dart' as globals;

enum ModalResponseType { code, user }

class TwitchModalContent extends StatefulWidget {
  final ModalResponseType responseType;
  const TwitchModalContent(this.responseType, {Key? key}) : super(key: key);

  @override
  _TwitchModalContentState createState() => _TwitchModalContentState();
}

class _TwitchModalContentState extends State<TwitchModalContent> {
  final CookieManager cookieManager = CookieManager();
  final FlutterTwitchAuth twitchAuthController = FlutterTwitchAuth.instance;
  String url = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    url = "https://id.twitch.tv/oauth2/authorize"
        "?response_type=${twitchAuthController.responseType}"
        "&client_id=${twitchAuthController.TWITCH_CLIENT_ID}"
        "&redirect_uri=${twitchAuthController.TWITCH_REDIRECT_URI}"
        "&scope=${twitchAuthController.scope}";
    cookieManager.clearCookies();
  }

  void _userAuth(String code) async {
    setState(() {
      isLoading = true;
    });
    var users = await FlutterTwitch.users.getUsersByToken(code);
    setState(() {
      isLoading = false;
      Navigator.of(context).pop(users.data.first);
    });
    log('code $code');
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted, // to enable JS
            onPageFinished: (String url) {
              log('onPageFinished url $url');
              if (url.contains("#access_token=")) {
                var split = url.split("#access_token=");
                split = split[split.length - 1].split("&");
                var authCode = split[0];
                log('authCode' + authCode);
                globals.codeAuth = authCode;

                switch (widget.responseType) {
                  case ModalResponseType.user:
                    _userAuth(authCode);
                    break;
                  case ModalResponseType.code:
                    Navigator.of(context).pop(authCode);
                    break;
                }
              }
            },
          );
    // return AlertDialog(
    //   backgroundColor: Colors.transparent,
    //   contentPadding: const EdgeInsets.all(0),
    //   content: ClipRRect(
    //     borderRadius: BorderRadius.circular(8),
    //     child: Container(
    //       color: Theme.of(context).dialogBackgroundColor,
    //       width: double.infinity,
    //       height: MediaQuery.of(context).size.height * .8,
    //       child: Column(
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             children: [
    //               IconButton(
    //                 icon: const Icon(Icons.close_rounded),
    //                 onPressed: () {
    //                   Navigator.of(context).pop(null);
    //                 },
    //               )
    //             ],
    //           ),
    //           Expanded(
    //             child: isLoading
    //                 ? const Center(
    //                     child: CircularProgressIndicator(),
    //                   )
    //                 : WebView(
    //                     initialUrl: url,
    //                     javascriptMode: JavascriptMode.unrestricted,
    //                     onPageFinished: (String url) {
    //                       log(url);
    //                       if (url.contains("?code=")) {
    //                         var split = url.split("?code=");
    //                         split = split[split.length - 1].split("&");
    //                         switch (widget.responseType) {
    //                           case ModalResponseType.user:
    //                             _userAuth(split[0]);
    //                             break;
    //                           case ModalResponseType.code:
    //                             Navigator.of(context).pop(split[0]);
    //                             break;
    //                         }
    //                       }
    //                     },
    //                   ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
