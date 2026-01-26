import 'package:flutter/material.dart';
class Keyword{
  final int  id;
  final String value;
  Keyword({
    required this.id,
    required this.value
});

  factory Keyword.fromJson(Map<String,dynamic>json){
    return Keyword(
      id:json["id"] ?? 0,
      value: json["value"] ?? ''
    );
  }
}