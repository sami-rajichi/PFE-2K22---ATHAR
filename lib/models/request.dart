
class UserRequest {
  final String? email;
  final String? issueImage;
  final String? issueType;
  final String? issue;
  final double? verified;

  UserRequest({
    this.email, 
    this.issueImage,
    this.issueType, 
    this.issue, 
    this.verified, 
    });

    static UserRequest fromJson(Map<String, dynamic> json) => UserRequest(
      email: json['email'],
      issue: json['issue'],
      issueImage: json['issue_image'],
      issueType: json['issue_type'],
      verified: json['verified'],
    );
}