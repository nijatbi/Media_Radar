
import 'package:media_radar/models/Keyword.dart';

class MediaStream{
    final int?  owner_id;
    final int? id;
    final bool is_active;
    final String name;
    final List<Keyword> keywords;
    MediaStream({
       this.owner_id,
       this.id,
      required this.is_active,
      required this.name,
      required this.keywords
});
factory MediaStream.fromJson(Map<String,dynamic> json){
  return MediaStream(
    id: json['id'],
    owner_id: json['owner_id'] ,
    is_active: json['is_active'] ?? false,
    name: json['name'] ?? '',
    keywords: json['keywords'] != null
        ? List<Keyword>.from(
      json['keywords'].map((x) => Keyword.fromJson(x)),
    )
        : [],

  );
}
@override
  String toString() {
    return '${name}';
  }
}