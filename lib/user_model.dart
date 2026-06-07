// ============================================================
// user_model.dart – User Data Model
// Maps to the `users` table in SQLite
// ============================================================

class User {
  final int?   id;
  final String username;
  final String email;
  final String password; // TODO: hash with bcrypt in production

  const User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'username': username,
        'email':    email,
        'password': password,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        id:       map['id']       as int?,
        username: map['username'] as String,
        email:    map['email']    as String,
        password: map['password'] as String,
      );
}
