class Photo {
  final String sid;
  String cnt;
  String? title;
  final String url;
  int myfav;
  String? deviceid;

  Photo({required this.sid, required this.cnt, this.title, required this.url, required this.myfav, this.deviceid});

  // 사진의 정보를 포함하는 인스턴스를 생성하여 반환하는 factory 생성자
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      sid: json['sid'] as String,
      cnt: json['cnt'] as String,
      title: json['title'] as String?,
      url: json['url'] as String,
      myfav: int.tryParse(json['myfav']) ?? 0,
      deviceid: json['deviceid'] as String?,
    );
  }
}