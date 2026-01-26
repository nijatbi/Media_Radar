import 'package:media_radar/models/Stream.dart';

class User{
  final String userName;
  final String name;
  final String surname;
  final List<MediaStream>? streams;
  User({
    required this.userName,
    required this.name,
    required this.surname,
    this.streams
});
  factory User.fromJson(Map<String,dynamic> json){
    return User(
      userName: json['username'] ?? '',
      surname: json['surname'] ?? '',
      name: json['name'] ?? '',
      streams: json['streams'] != null
          ? List<MediaStream>.from(
        json['streams'].map((x) => MediaStream.fromJson(x)),
      )
          : [],

    );
  }
  @override
  String toString() {
    return ' ${userName} ${streams}';
  }
}