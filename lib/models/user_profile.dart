class UserProfile {
  final String firstName;
  final String lastName;
  final int age;
  final String sex;
  final double height;
  final double weight;
  final String phone;
  final String address;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.sex,
    required this.height,
    required this.weight,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toMap() => {
    'firstName': firstName,
    'lastName': lastName,
    'age': age,
    'sex': sex,
    'height': height,
    'weight': weight,
    'phone': phone,
    'address': address,
  };

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      age: map['age'] ?? 0,
      sex: map['sex'] ?? '',
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
    );
  }
}
