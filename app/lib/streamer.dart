class StreamerList {
  final List<Streamer>? data;

  StreamerList({this.data});

  factory StreamerList.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    List<Streamer> dataList = list.map((i) => Streamer.fromJson(i)).toList();

    return StreamerList(data: dataList);
  }
}

class Streamer {
  String? id;
  String? userId;
  String? userLogin;
  String? userName;
  String? gameId;
  String? gameName;
  String? type;
  String? title;
  int? viewerCount;
  String? startedAt;
  String? language;
  String? thumbnailUrl;
  bool? isMature;

  Streamer(
      {this.id,
      this.userId,
      this.userLogin,
      this.userName,
      this.gameId,
      this.gameName,
      this.type,
      this.title,
      this.viewerCount,
      this.startedAt,
      this.language,
      this.thumbnailUrl,
      this.isMature});

  factory Streamer.fromJson(Map<String, dynamic> parsedJson) {
    return Streamer(
        id: parsedJson['id'],
        userId: parsedJson['user_id'],
        userLogin: parsedJson['user_login'],
        userName: parsedJson['user_name'],
        gameId: parsedJson['game_id'],
        gameName: parsedJson['game_name'],
        type: parsedJson['type'],
        title: parsedJson['title'],
        viewerCount: parsedJson['viewer_count'],
        startedAt: parsedJson['started_at'],
        language: parsedJson['language'],
        thumbnailUrl: parsedJson['thumbnail_url'],
        isMature: parsedJson['is_mature']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_login'] = userLogin;
    data['user_name'] = userName;
    data['game_id'] = gameId;
    data['game_name'] = gameName;
    data['type'] = type;
    data['title'] = title;
    data['viewer_count'] = viewerCount;
    data['started_at'] = startedAt;
    data['language'] = language;
    data['thumbnail_url'] = thumbnailUrl;
    data['is_mature'] = isMature;
    return data;
  }
}
