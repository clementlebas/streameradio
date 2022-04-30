import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  static const url =
      'https://video-weaver.fra05.hls.ttvnw.net/v1/playlist/Cp4EmnDEwliYc9faCfa30RItOGnFqiwOwuDezd1sSNth9vRhdlic1-H6h5U8QKFISJlXyvgEU8BB87bOEKq-A4bEMEWI3odp7jfs0LcQkqAA8uf5njJvFHe5tWI6y-klKynDrQBRy6UTEWGMkJz3fsbsW358HwVLg4_CihtVn8PmD78aCpedh27ls_FeJxskoXhqNLK4bJKLFlL7GgJEhA4ueYudQnLfHpAcoyjmLCj1vN-_H5nvtBsNtm8PtHeRMT4YzzAkKKTvVR_UEZCfM_SnSdh7PlXZJRNhzWTT6pMsGNCTD_lCpJMxDkthy6cfWuWpfnfT06MD-KZS0_5H44JeKPY_uEFnsHeS4s0LyiYvULNV2CWksNLu1jhBoGclWMSRWeYPLUrf0FCQxqUP0i6nji5_ISokBzUXpvY0HEEx_qtxvoLA-why05xegB07evT2Ytglg42-EEenk5FWVLql5F3cQrIBxzyWnRGw5_igg3Q-BjWjfu3TZKKabwO3p9us23U-3qAlBma0_DQB4J3706WIGy21wu7XyX-HrmY4an8xI34uxf3iRwRQZMqMp6lHnbzgjfd9_Lf-JNgGODSWUD4OrQvn8j6Ajg21KCeMCAf1e9B-9CUl4xE84cxKVRDSQw8JHuQWt6B66XTLAoTsEvia2zXFWLF9t15nJWdva0zNSuuuSlZLmKg5gz6_quB_oFC74qhwF1rhn8MbdH0aDIubMbCqkM2VEzv8ICABKglldS13ZXN0LTIwzQM.m3u8';

  late AudioPlayer _audioPlayer;
  PageManager() {
    _init();
  }

  void _init() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(url);

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void setChannel(url) async {
    await _audioPlayer.setUrl(url);
    log('setChannel' + url);
    _init();
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
