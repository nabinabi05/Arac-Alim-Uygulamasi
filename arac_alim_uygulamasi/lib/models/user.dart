class User {
  int? id;
  String name;
  String email;

  User({this.id, required this.name, required this.email});

  factory User.fromMap(Map<String, dynamic> m) =>
    User(id: m['id'], name: m['name'], email: m['email']);

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'email': email,
  };
}
