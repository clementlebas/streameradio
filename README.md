# flutter_twitch_auth

[pub package](https://pub.dartlang.org/packages/flutter_twitch_auth)

This package will provide a modal login with Twitch, you can get the "code" provided by the Twitch API to create your own authentication flow or get a user object once authentication is complete.

Created by Claudio Oliveira (https://twitter.com/cldlvr)

[Buy me a coffee ☕](https://www.buymeacoffee.com/claudiooliveira)

<img src="https://github.com/claudiooliveira/flutter_twitch_auth/blob/main/live_example.gif?raw=true" alt="Live Example" width="300"/>

### Add dependency

```yaml
dependencies:
  flutter_twitch_auth: ^0.0.1 #latest version
```

### Easy to use

```dart

// Initialize authentication with your app on the Twitch API

void main() {

  FlutterTwitchAuth.initialize(
    twitchClientId: "<YOUR_CLIENT_ID>",
    twitchClientSecret: "<YOUR_CLIENT_SECRET>",
    twitchRedirectUri: "<YOUR_REDIRECT_URI>",
  );

  runApp(MyApp());
}

...

//Show modal and get logged user data
void _handleTwitchSignIn() async {
  User? user = await FlutterTwitchAuth.authToUser(context);
}

//Or get the user code and use it with the Twitch API (or Flutter Twitch Package) to create your own login flow.
void _handleTwitchSignIn() async {
  String? code = await FlutterTwitchAuth.authToCode(context);
}
...

```