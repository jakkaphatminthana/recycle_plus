class EmailModel {
  late String email;
  late String password;
  late String name;
}

class SponserEmailModel {
  late String email;
  late String password;
  late String otp;
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
    this.id,
    this.email,
    this.name,
    this.image,
    this.address,
    this.role,
    this.verify,
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
      'verify': verify,
    };
  }
}

//==============================================================================================
//TODO : แบบแสดงทั้งหมด ในแบบของฉัน
class UserModelV2 {
  final String id;
  final String email;
  final String name;
  final String image;
  final String address;
  final String role;
  final bool verify;

  UserModelV2({
    required this.id,
    required this.email,
    required this.name,
    required this.image,
    required this.address,
    required this.role,
    required this.verify,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'image': image,
        'address': address,
        'role': role,
        'verify': verify,
      };

  static UserModelV2 fromJson(Map<String, dynamic> json) => UserModelV2(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    image: json['image'],
    address: json['address'],
    role: json['role'],
    verify: json['verify'],
  );
}
