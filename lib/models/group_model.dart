class GroupModel {
  final String groupName;
  final String groupId;
  final String groupPic;
  final String senderId;
  final String lastMessage;
  final List<String> memberUids;
  final DateTime timeSent;
  GroupModel({
    required this.groupName,
    required this.groupId,
    required this.groupPic,
    required this.senderId,
    required this.lastMessage,
    required this.memberUids,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupName': groupName,
      'groupId': groupId,
      'groupPic': groupPic,
      'senderId': senderId,
      'lastMessage': lastMessage,
      'memberUids': memberUids,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupName: map['groupName'] as String,
      groupId: map['groupId'] as String,
      groupPic: map['groupPic'] as String,
      senderId: map['senderId'] as String,
      lastMessage: map['lastMessage'] as String,
      memberUids: List<String>.from((map['memberUids'])),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
    );
  }
}
