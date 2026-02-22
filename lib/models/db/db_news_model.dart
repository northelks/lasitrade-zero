import 'package:postgres/postgres.dart';

class DBNewsModel {
  final String newsId;
  final int uic;
  final String text;
  final String provider;
  final String url;
  final DateTime timeAt;

  DBNewsModel({
    required this.newsId,
    required this.uic,
    required this.text,
    required this.provider,
    required this.url,
    required this.timeAt,
  });

  factory DBNewsModel.fromJson(Map<String, dynamic> json) {
    return DBNewsModel(
      newsId: json['news_id'],
      uic: json['uic'],
      text: json['text'],
      provider: json['provider'],
      url: json['url'],
      timeAt: DateTime.parse(json['time_at']).toLocal(),
    );
  }

  factory DBNewsModel.fromRowResult(ResultRow row) {
    return DBNewsModel(
      newsId: row.elementAt(0) as String,
      uic: row.elementAt(1) as int,
      text: row.elementAt(2) as String,
      provider: row.elementAt(3) as String,
      url: row.elementAt(4) as String,
      timeAt: (row.elementAt(5) as DateTime).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'news_id': newsId,
      'uic': uic,
      'text': text,
      'provider': provider,
      'url': url,
      'time_at': timeAt.toUtc().toIso8601String(),
    };
  }
}
