class PaymentCategoryModel {
  final String id;
  final String name;

  PaymentCategoryModel({
    required this.id,
    required this.name,
  });

  factory PaymentCategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaymentCategoryModel(
      id: json['ID'] ?? '',
      name: json['Name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}