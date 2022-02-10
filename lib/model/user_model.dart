class UserModel {
  final String uid;
  final String username;
  final String email;
  final String imageUrl;

  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.imageUrl,
  });

  UserModel.fromJson(Map<String, dynamic> data)
      : uid = data['uid'].toString(),
        username = data['username'].toString(),
        email = data['email'].toString(),
        imageUrl = data['imageUrl'].toString();

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "imageUrl": imageUrl,
    };
  }
}
