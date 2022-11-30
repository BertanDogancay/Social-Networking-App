class ChatContactModel {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;
  int unseenMessages;

  ChatContactModel(
      {required this.name,
      required this.profilePic,
      required this.contactId,
      required this.timeSent,
      required this.lastMessage,
      required this.unseenMessages});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
      'unseenMessages': unseenMessages,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
        name: map['name'] ?? '',
        profilePic: map['profilePic'] ?? '',
        contactId: map['contactId'] ?? '',
        timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
        lastMessage: map['lastMessage'] ?? '',
        unseenMessages: map['unseenMessages'] as int);
  }
}
