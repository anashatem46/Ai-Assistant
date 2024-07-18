class Message {
  String messageId;
  String chatId;
  Role role;
  StringBuffer message;
  List<String> imagesUrls;
  String messageImage;
  DateTime timeSent;
  bool isImage; // Add this flag to identify if the message is an image
  bool isImageSingle; // Add this flag to identify if the message is an image

  // constructor
  Message({
    required this.messageId,
    required this.chatId,
    required this.role,
    required this.message,
    required this.imagesUrls,
    required this.messageImage,
    required this.timeSent,
    this.isImage = false, // Default value is false
    this.isImageSingle = false, // Default value is false
  });

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'role': role.index,
      'message': message.toString(),
      'imagesUrls': imagesUrls,
      'messageImage': messageImage,
      'timeSent': timeSent.toIso8601String(),
      'isImage': isImage,
      'isImageSingle': isImageSingle,
    };
  }

  // from map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'],
      chatId: map['chatId'],
      role: Role.values[map['role']],
      message: StringBuffer(map['message']),
      imagesUrls: List<String>.from(map['imagesUrls']),
      messageImage: map['messageImage'],
      timeSent: DateTime.parse(map['timeSent']),
      isImage: map['isImage'] ?? false,
      isImageSingle: map['isImageSingle'] ?? false,
    );
  }

  // copyWith
  Message copyWith({
    String? messageId,
    String? chatId,
    Role? role,
    StringBuffer? message,
    List<String>? imagesUrls,
    String? messageImage,
    DateTime? timeSent,
    bool? isImage,
    bool? isImageSingle,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      message: message ?? this.message,
      imagesUrls: imagesUrls ?? this.imagesUrls,
      messageImage: messageImage ?? this.messageImage,
      timeSent: timeSent ?? this.timeSent,
      isImage: isImage ?? this.isImage,
      isImageSingle: isImageSingle ?? this.isImageSingle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message && other.messageId == messageId;
  }

  @override
  int get hashCode {
    return messageId.hashCode;
  }
}

enum Role {
  user,
  assistant,
}
