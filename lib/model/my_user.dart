class MyUser {
  static const String collectionName = 'users';

  String id;
  String firstName;
  String lastName;
  String email;
  String token;

  MyUser(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.token});

  MyUser.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'] as String,
            firstName: json['first_name'] as String,
            lastName: json['last_name'] as String,
            email: json['email'] as String,
            token: json['token'] as String ?? '');

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "token" : token
    };
  }
}
