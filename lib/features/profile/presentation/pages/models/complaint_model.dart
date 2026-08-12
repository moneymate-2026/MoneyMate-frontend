class ComplaintModel {
  final String id;
  final String title;
  final String description;
  final String status; // Pending, Resolved, Rejected
  final String? adminResponse;
  final DateTime createdAt;

  ComplaintModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.adminResponse,
    required this.createdAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json["Id"].toString(),
      title: json["Title"] ?? "",
      description: json["Description"] ?? "",
      status: json["Status"] ?? "Pending",
      adminResponse: json["AdminResponse"],
      createdAt: DateTime.tryParse(json["CreatedAt"] ?? "") ?? DateTime.now(),
    );
  }
}