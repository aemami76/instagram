class MyUser {
  String id;
  String username;
  String email;
  String bio;
  String picUrl;
  List follower = [];
  List following = [];

  MyUser(
      {required this.id,
      required this.username,
      required this.email,
      required this.bio,
      required this.picUrl,
      required this.follower,
      required this.following});

  static MyUser? instance;

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'bio': bio,
        'picUrl': picUrl,
        'follower': follower,
        'following': following,
      };

  MyUser.fromJson(Map<dynamic, dynamic> map)
      : id = map['uid'],
        username = map['username'],
        email = map['email'],
        bio = map['bio'],
        picUrl = map['photoUrl'],
        follower = map['followers'],
        following = map['following'];
}

class MyPost {
  String id;
  String username;
  String email;
  String desc;
  DateTime dateTime;
  String postId;
  String postUrl;
  String profileImage;
  List like;

  MyPost(
      {required this.id,
      required this.username,
      required this.email,
      required this.desc,
      required this.dateTime,
      required this.postId,
      required this.postUrl,
      required this.profileImage,
      required this.like});

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'desc': desc,
        'profileImage': profileImage,
        'postId': postId,
        'postUrl': postUrl,
        'dateTime': dateTime,
        'like': like,
      };
}
