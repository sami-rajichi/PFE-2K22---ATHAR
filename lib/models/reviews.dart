
class Review {
  final String? name;
  final String? review;
  final String? image;
  final double? rate;

  Review({
    this.name, 
    this.image,  
    this.review,
    this.rate
    });

    static Review fromJson(Map<String, dynamic> json) => Review(
      image: json['image'],
      name: json['name'],
      rate: json['rating'],
      review: json['review'],
    );
}