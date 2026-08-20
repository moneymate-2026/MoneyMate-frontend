class ReportModel {
  final String id;
  final String title;
  final String description;
  final String status; // Pending, Resolved, Rejected
  final String? adminResponse;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.adminResponse,
    required this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json["Id"].toString(),
      title: json["Title"] ?? "",
      description: json["Description"] ?? "",
      status: json["Status"] ?? "Pending",
      adminResponse: json["AdminResponse"],
      createdAt: DateTime.tryParse(json["CreatedAt"] ?? "") ?? DateTime.now(),
    );
  }
}