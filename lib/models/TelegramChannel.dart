class TelegramChannel{
  final int id;
  final String name;

  TelegramChannel({required this.id, required this.name});

  factory TelegramChannel.fromJson(Map<String, dynamic> json) {
    return TelegramChannel(
      id: json['channel_id'],
      name: json['channel_name'],
    );
  }
}