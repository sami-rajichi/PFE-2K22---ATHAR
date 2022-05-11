class Users {
  final String? name;
  final String? email;
  final String? password;
  final String? gender;
  final String? image;
  final String? uid;

  Users({
    this.email,
    this.password, 
    this.gender, 
    this.uid,
    this.name, 
    this.image, 
    });

    static Users fromJson(
      Map<String, dynamic> json) => Users(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'],
      uid: json['uid'],
      image: json['image'],
    );
}