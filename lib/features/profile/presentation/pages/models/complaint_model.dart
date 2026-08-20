class Complaintmodel {
  final String title;
  final String description;

  Complaintmodel({
    required this.title,
    required this.description,
  });

  factory Complaintmodel.fromJson(Map<String, dynamic> json) {
    return Complaintmodel(
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
      };
}