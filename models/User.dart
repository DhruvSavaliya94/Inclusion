class User {
  final int id;
  final String name;
  final String email;
  final String contact;
  final DateTime? dateOfBirth;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
    this.dateOfBirth,
  });
}
