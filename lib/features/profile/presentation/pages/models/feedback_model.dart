class Feedbackmodel {
  final int rating;
  final String description;

  Feedbackmodel({
    required this.rating,
    required this.description,
  });

  factory Feedbackmodel.fromJson(Map<String, dynamic> json) {
    return Feedbackmodel(
      rating: json["rating"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "rating": rating,
      "description": description,
    };
  }
}