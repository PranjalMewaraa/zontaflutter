class ArrayResponse {
  final String event;
  final Map<String, dynamic>? metadata;
  final bool success;
  final String? error;

  ArrayResponse({
    required this.event,
    this.metadata,
    this.success = true,
    this.error,
  });

  factory ArrayResponse.fromJson(Map<String, dynamic> json) {
    return ArrayResponse(
      event: json['event'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      success: json['error'] == null,
      error: json['metadata']?['error']?.toString(),
    );
  }
}
