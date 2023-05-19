class Message {
  final String fromId;
  final String toId;
  final String sentTime;
  final String readTime;
  final String message;
  final MessageType type;

  const Message({
    required this.fromId,
    required this.toId,
    required this.sentTime,
    required this.readTime,
    required this.message,
    required this.type,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        fromId: json['fromId'],
        toId: json['toId'],
        sentTime: json['sentTime'],
        readTime: json['readTime'],
        message: json['message'],
        type: json['type'] == MessageType.image.name
            ? MessageType.image
            : MessageType.text,
      );

  Map<String , dynamic> toJson() {
    return {
      'fromId' : fromId,
      'toId' : toId,
      'sentTime' : sentTime,
      'readTime' : readTime,
      'message' : message,
      'type' : type.name,
    };
  }
}

enum MessageType { image, text }
