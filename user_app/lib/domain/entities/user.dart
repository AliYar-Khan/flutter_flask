class User {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String address;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "address": address
    };
  }
}
