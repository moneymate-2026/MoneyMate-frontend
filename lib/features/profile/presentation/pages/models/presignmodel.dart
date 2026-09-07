class PresignResponse {
  final String uploadUrl;
  final String publicUrl;
  final DateTime expiresAt;

  PresignResponse({
    required this.uploadUrl,
    required this.publicUrl,
    required this.expiresAt,
  });

  factory PresignResponse.fromJson(Map<String, dynamic> json) {
    return PresignResponse(
      uploadUrl: json['UploadURL'] as String,
      publicUrl: json['PublicURL'] as String,
      expiresAt: DateTime.parse(json['ExpiresAt'] as String),
    );
  }
}