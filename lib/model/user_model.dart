class UserModel {
  final String uid;
  final String username;
  final String email;
  final String imageUrl;
  final int posts;

  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.posts,
  });

  UserModel.fromJson(Map<String, dynamic> data)
      : uid = data['uid'].toString(),
        username = data['username'].toString(),
        email = data['email'].toString(),
        imageUrl = data['imageUrl'].toString(),
        posts = data['posts'];

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "imageUrl": imageUrl,
      "posts": posts,
    };
  }
}
