import 'package:chat_app/model/my_user.dart';

class Room {
  String roomId;
  String title;
  String description;
  String categoryId;
  List<dynamic> participants;

  static const String collectionName = 'rooms';

  Room({
    required this.roomId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.participants,
  });

  Room.fromJson(Map<String, dynamic> json)
      : this(
          roomId: json['room_id'] as String,
          title: json['title'] as String,
          description: json['description'] as String,
          categoryId: json['category_id'] as String,
          participants: (json['participants'] as List<dynamic>?) ?? [],
        );

  Map<String, dynamic> toJson() {
    return {
      "room_id": roomId,
      "title": title,
      "description": description,
      "category_id": categoryId,
      "participants": participants,
    };
  }
}
