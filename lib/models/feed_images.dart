class FeedImages{
  final int id;
  final String imagePath;
  final int feedId;

  FeedImages({
    required this.id,
    required this.imagePath,
    required this.feedId
  });

  // Convert from JSON
  factory FeedImages.fromJson(Map<String, dynamic> json) {
    return FeedImages(
      id: json['id'],
      imagePath: json['image_path'],
      feedId: json['feed_id'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'feed_id': feedId,
    };
  }

}

