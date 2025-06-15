class FeedComments{
  final int id;
  final String userName;
  final String comment;
  final int feedId;

  FeedComments({
    required this.id,
    required this.userName,
    required this.comment,
    required this.feedId,
  });

  // Convert from JSON
  factory FeedComments.fromJson(Map<String, dynamic> json) {
    return FeedComments(
      id: json['id'],
      userName: json['username'],
      comment: json['comment'],
      feedId: json['feed_id'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': userName,
      'comment': comment,
      'feed_id': feedId,
    };
  }
}
