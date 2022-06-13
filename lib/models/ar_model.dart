class ArModel {
  final String? name;
  final String? object;
  final String? image;

  ArModel({
    this.name, 
    this.image,  
    this.object,
    });

    static ArModel fromJson(Map<String, dynamic> json) => ArModel(
      image: json['image'],
      name: json['name'],
      object: json['models'],
    );
}