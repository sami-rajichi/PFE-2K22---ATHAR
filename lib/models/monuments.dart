
class Monument {
  final String? name;
  final String? info;
  final String? location;
  final String? region;
  final String? image;
  final String? country;
  final String? url;
  static List<Monument> monuments = [];

  Monument({
    this.name, 
    this.location, 
    this.region, 
    this.image, 
    this.country, 
    this.url, 
    this.info
    });

    static Monument fromJson(Map<String, dynamic> json) => Monument(
      name: json['name'],
      info: json['info'],
      location: json['location'],
      region: json['region'],
      image: json['image'],
      url: json['url']
    );
}