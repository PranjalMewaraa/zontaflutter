class ArrayEvent {
  final String tagName;
  final String event;
  final Map<String, dynamic>? metadata;

  ArrayEvent({
    required this.tagName,
    required this.event,
    this.metadata,
  });

  factory ArrayEvent.fromJson(Map<String, dynamic> json) {
    return ArrayEvent(
      tagName: json['tagName'] as String,
      event: json['event'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}
