class User {
  late String username;
  late String email;
  late String password;

  User({
    required this.username,
    required this.email,
    required this.password,

  });

  @override
  String toString() =>
      'Utilisateur(username: $username, email: $email, password: $password)';

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'] ?? json['username'],
        email = json['email'] ?? json['email'],
        password = json['password'] ?? json['password'];
}