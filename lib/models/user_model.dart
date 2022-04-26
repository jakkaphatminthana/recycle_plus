class EmailModel {
  late String email;
  late String password;
  late String name;
}

class UserModel {
  String? id;
  String? email;
  String? name;
  String? image;
  String? address;
  String? role;
  bool? verify;

  UserModel({
    String? id,
    String? email,
    String? name,
    String? image,
    String? address,
    String? role,
    bool? verify,
  });

  factory UserModel.fromMap(Map<String, dynamic>? users) {
    String id = users?['id'];
    String email = users?['email'];
    String name = users?['name'];
    String image = users?['image'];
    String address = users?['address'];
    String role = users?['role'];
    bool verify = users?['verify'];
    return UserModel(
      id: id,
      email: email,
      name: name,
      image: image,
      address: address,
      role: role,
      verify: verify,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'image': image,
      'address': address,
      'role': role,
      'verify':verify,
    };
  }
}
