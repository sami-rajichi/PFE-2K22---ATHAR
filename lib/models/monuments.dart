
class Monument {
  final String? name;
  final String? info;
  final String? subtitle1;
  final String? subtitle2;
  final String? subtitle3;
  final String? subtitle1Value;
  final String? subtitle2Value;
  final String? subtitle3Value;
  final String? location;
  final String? image;
  final String? country;
  final String? url;
  static List<Monument> monuments = [];

  Monument({
    this.name, 
    this.location, 
    this.image, 
    this.country, 
    this.subtitle1, this.subtitle2, this.subtitle3,
    this.url, 
    this.subtitle1Value, 
    this.subtitle2Value, this.subtitle3Value, 
    this.info
    });

    static Monument fromJson(Map<String, dynamic> json) => Monument(
      name: json['name'],
      info: json['info'],
      location: json['location'],
      image: json['image'],
      subtitle1: json['subtitle1'],
      subtitle2: json['subtitle2'],
      subtitle3: json['subtitle3'],
      subtitle1Value: json['subtitle1-value'],
      subtitle2Value: json['subtitle2-value'],
      subtitle3Value: json['subtitle3-value'],
      url: json['url']
    );
}