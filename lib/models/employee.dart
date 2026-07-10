class Employee {
  final int id;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String email;
  final String phone;
  final String imageUrl;
  final String jobTitle;
  final String department;
  final String city;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.jobTitle,
    required this.department,
    required this.city,
  });

  String get fullName => '$firstName $lastName';

  factory Employee.fromJson(Map<String, dynamic> json) {
    final company = json['company'] ?? {};
    final address = json['address'] ?? {};

    return Employee(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      imageUrl: json['image'] ?? '',
      jobTitle: company['title'] ?? 'N/A',
      department: company['department'] ?? 'N/A',
      city: address['city'] ?? 'N/A',
    );
  }
}