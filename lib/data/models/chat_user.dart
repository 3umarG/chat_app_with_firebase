class ChatUser {
  final String? id;
  final String? name;
  final String? image;
  final String? about;
  final String? createdAt;
  final bool? isOnline;
  final String? lastActive;
  final String? email;
  final String? pushToken;

  ChatUser({
    required this.id,
    required this.name,
    required this.image,
    required this.about,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.email,
    required this.pushToken,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        about: json['about'],
        createdAt: json['createdAt'],
        isOnline: json['isOnline'],
        lastActive: json['lastActive'],
        email: json['email'],
        pushToken: json['pushToken'],
      );
}
