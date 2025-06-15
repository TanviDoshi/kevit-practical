import 'feed_comment.dart';
import 'feed_images.dart';

class FeedPost{
  final int id;
  final String username;
  final String caption;
  int likeCount;
  bool isLikedByUser;
  final String? createdAt;
  final List<FeedImages> images;
  final List<FeedComments> comments;

  FeedPost({
    required this.id,
    required this.username,
    required this.caption,
    required this.likeCount,
    required this.isLikedByUser,
    required this.createdAt,
    required this.images,
    required this.comments,
  });

  // Convert from JSON
  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: json['id'],
      username: json['username'],
      caption: json['caption'],
      likeCount: json['like_count'],
      isLikedByUser: json['isLikedByUser'] == 1,
      createdAt: json['created_at'],
      images: (json['images'] as List)
          .map((image) => FeedImages.fromJson(image))
          .toList(),
      comments: (json['comments'] as List)
          .map((comment) => FeedComments.fromJson(comment))
          .toList(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'caption': caption,
      'like_count': likeCount,
      'isLikedByUser': isLikedByUser ? 1 : 0,
      'created_at': createdAt,
      'images': images.map((image) => image.toJson()).toList(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}


