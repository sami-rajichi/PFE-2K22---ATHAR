class Users {
  final String? name;
  final String? email;
  final String? password;
  final String? gender;
  final String? image;
  final String? uid;
  final String? providerId;
  final String? accessToken;
  final String? idToken;

  Users(
    {
    this.email,
    this.password, 
    this.gender, 
    this.name, 
    this.image, 
    this.uid,
    this.providerId, 
    this.accessToken, 
    this.idToken, 
    });

    static Users fromJson(
      Map<String, dynamic> json) => Users(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'],
      image: json['image'],
      uid: json['uid'],
      providerId: json['providerId'],
      accessToken: json['accessToken'],
      idToken: json['idToken']
    );
}