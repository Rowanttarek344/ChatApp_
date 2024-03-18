class Message {
  static const String collectionName = 'message';

  String id;
  String roomId;
  String content;
  String senderId;
  String senderName;
  int dateTime;

  Message(
      {this.id = '',
      required this.roomId,
      required this.content,
      required this.senderId,
      required this.senderName,
      required this.dateTime});

  Message.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'] as String,
            roomId: json['room_id'] as String,
            content: json['content'] as String,
            senderId: json['sender_id'] as String,
            senderName: json['sender_name'] as String,
            dateTime: json['date_time'] as int);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "room_id": roomId,
      "content": content,
      "sender_id": senderId,
      "sender_name": senderName,
      "date_time": dateTime
    };
  }
}
