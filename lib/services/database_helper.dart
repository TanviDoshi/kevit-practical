import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/feed_comment.dart';
import '../models/feed_images.dart';
import '../models/feed_post.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('social_feed.db');

    await insertFeedPostList(); // Insert initial data if needed
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path,
        version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS feed_post (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      caption TEXT,
      like_count INTEGER NOT NULL DEFAULT 0,
      isLikedByUser INTEGER DEFAULT 0,
      created_at TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS feed_images (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      image_path TEXT NOT NULL,
      feed_id INTEGER NOT NULL,
      FOREIGN KEY (feed_id) REFERENCES feed_post (id) ON DELETE CASCADE
    )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS feed_comment (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      comment TEXT NOT NULL,
      feed_id INTEGER NOT NULL,
      FOREIGN KEY (feed_id) REFERENCES feed_post (id) ON DELETE CASCADE
    )
  ''');
  }

  Future<int> insertFeedPost({
    required String username,
    String? caption,
    int likeCount = 0,
    bool isLikedByUser = false,
    String? createdAt, // Pass DateTime.now().toIso8601String() if needed
  }) async {
    final db = await database;
    return await db.insert('feed_post', {
      'username': username,
      'caption': caption,
      'like_count': likeCount,
      'isLikedByUser': isLikedByUser ? 1 : 0,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    });
  }

  Future<int> insertFeedImage({
    required String imagePath,
    required int feedId,
  }) async {
    final db = await database;
    return await db.insert('feed_images', {
      'image_path': imagePath,
      'feed_id': feedId,
    });
  }

  Future<int> insertFeedComment({
    required String comment,
    required int feedId,
  }) async {
    final db = await database;
    return await db.insert('feed_comment', {
      'comment': comment,
      'feed_id': feedId,
    });
  }

  Future<List<Map<String, dynamic>>> fetchAllPosts() async {
    final db = await database;
    return await db.query('feed_post', orderBy: 'created_at DESC');
  }

  Future<List<Map<String, dynamic>>> fetchImagesByPostId(int postId) async {
    final db = await database;
    return await db.query(
      'feed_images',
      where: 'feed_id = ?',
      whereArgs: [postId],
    );
  }

  Future<List<Map<String, dynamic>>> fetchCommentsByPostId(int postId) async {
    final db = await database;
    return await db.query(
      'feed_comment',
      where: 'feed_id = ?',
      whereArgs: [postId],
    );
  }

  Future<List<Map<String, dynamic>>> fetchPostsWithDetails() async {
    final db = await database;
    final posts = await db.query('feed_post', orderBy: 'created_at DESC');

    final List<Map<String, dynamic>> result = [];

    for (var post in posts) {
      final postId = post['id'] as int;

      final images = await db.query(
        'feed_images',
        where: 'feed_id = ?',
        whereArgs: [postId],
      );

      final comments = await db.query(
        'feed_comment',
        where: 'feed_id = ?',
        whereArgs: [postId],
      );

      final mutablePost = Map<String, dynamic>.from(post); // Make mutable copy
      mutablePost['images'] = images;
      mutablePost['comments'] = comments;

      result.add(mutablePost); // ✅ add to new list
    }

    return result;
  }


  Future<int> updateLikeCount({
    required int postId,
    required int newLikeCount,
    required bool isLikedByUser,
  }) async {
    final db = await database;
    return await db.update(
      'feed_post',
      {
        'like_count': newLikeCount,
        'isLikedByUser': isLikedByUser ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [postId],
    );
  }

  Future<int> manageLikeCount(int postId) async {
    final db = await database;
    final result = await db.query(
      'feed_post',
      where: 'id = ?',
      whereArgs: [postId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final post = result.first;
      final isLiked = post['isLikedByUser'] == 1;
      final currentLikes = post['like_count'] as int;

      final newIsLiked = !isLiked;
      final newCount = isLiked ? currentLikes - 1 : currentLikes + 1;

     var data = await updateLikeCount(
        postId: postId,
        newLikeCount: newCount,
        isLikedByUser: newIsLiked,
      );

     return data;
    }else{
      return -1; // Post not found
    }
  }

  Future<void> insertFeedPostList() async {
    List<FeedPost> posts = [];

    posts = getInitialFeedPost();
    final db = await database;

    final existing = await db.query('feed_post');
    if (existing.isNotEmpty) return; //

    for (var post in posts) {
      final postId = await db.insert('feed_post', {
        'username': post.username,
        'caption': post.caption,
        'like_count': post.likeCount,
        'isLikedByUser': post.isLikedByUser ? 1 : 0,
        'created_at': post.createdAt,
      });

      for (var image in post.images) {
        await db.insert('feed_images', {
          'image_path': image.imagePath,
          'feed_id': postId,
        });
      }

      for (var comment in post.comments) {
        await db.insert('feed_comment', {
          'comment': comment.comment,
          'feed_id': postId,
        });
      }
    }
  }

  List<FeedPost> getInitialFeedPost() {
    return [
      FeedPost(
          id: 1,
          username: 'tech_freak12',
          caption: 'Exploring the latest tech trends!',
          likeCount: 10,
          isLikedByUser: false,
          createdAt: '2025-06-14T09:00:00',
          images: [
            FeedImages(id: 1, imagePath: 'https://picsum.photos/200/300', feedId: 1),
            FeedImages(id: 2, imagePath: 'https://picsum.photos/200/300', feedId: 1),
            FeedImages(id: 3, imagePath: 'https://picsum.photos/200/300', feedId: 1),
          ],
          comments: [
            FeedComments(id: 1, comment: 'Great post!', feedId: 1, userName: 'coffee_coder98'),
          ]),
      FeedPost(
          id: 2,
          username: 'coffee_coder98',
          caption: 'Morning coffee and coding vibes!',
          likeCount: 8,
          isLikedByUser: true,
          createdAt: '2025-06-13T18:45:00',
          images: [
            FeedImages(id: 1, imagePath: 'https://picsum.photos/200/300', feedId: 2),
            FeedImages(id: 2, imagePath: 'https://picsum.photos/200/300', feedId: 2),
          ],
          comments: [
            FeedComments(id: 1, comment: 'Best combo ever.. :)', feedId: 2, userName: 'tech_freak12'),
          ]),
      FeedPost(
          id: 3,
          username: 'widget_warrior',
          caption: 'Mastering Flutter widgets!',
          likeCount: 20,
          isLikedByUser: false,
          createdAt: '2025-06-12T12:30:00',
          images: [
            FeedImages(id: 1, imagePath: 'https://picsum.photos/200/300', feedId: 3),
            FeedImages(id: 2, imagePath: 'https://picsum.photos/200/300', feedId: 3),
          ],
          comments: [
            FeedComments(id: 1, comment: 'Nice Post', feedId: 3, userName: 'flutter_freak'),
          ]),
      FeedPost(
          id: 4,
          username: 'flutter_builder',
          caption: 'Building beautiful UIs with Flutter!',
          likeCount: 18,
          isLikedByUser: false,
          createdAt: '2025-06-11T12:55:00',
          images: [
            FeedImages(id: 1, imagePath: 'https://picsum.photos/200/300', feedId: 4),
          ],
          comments: [
            FeedComments(id: 1, comment: 'Comment Post ', feedId: 4, userName: 'widget_warrior'),
          ]),

      FeedPost(
          id: 5,
          username: 'flutter_freak',
          caption: 'Flutter is awesome!',
          likeCount: 4,
          isLikedByUser: false,
          createdAt: '2025-06-09T14:20:00',
          images: [
            FeedImages(id: 1, imagePath: 'https://picsum.photos/200/300', feedId: 5),
            FeedImages(id: 2, imagePath: 'https://picsum.photos/200/300', feedId: 5),
          ],
          comments: []),

      FeedPost(
          id: 6,
          username: 'async_ninja',
          caption: 'Async programming in Dart is powerful!',
          likeCount: 50,
          isLikedByUser: false,
          createdAt: '2025-06-08T16:00:00',
          images: [
            FeedImages(id: 1, imagePath: 'https://picsum.photos/200/300', feedId: 6),
          ],
          comments: [
            FeedComments(id: 1, comment: 'Async and elegant ✨', feedId: 6, userName: 'flutter_builder'),
          ]),

      FeedPost(
          id: 7,
          username: 'dart_dev99',
          caption: 'Dart is the future of programming!',
          likeCount: 54,
          isLikedByUser: true,
          createdAt: '2025-06-07T07:50:00',
          images: [
            FeedImages(id: 1, imagePath: 'https://picsum.photos/200/300', feedId: 7),
            FeedImages(id: 2, imagePath: 'https://picsum.photos/200/300', feedId: 7),
          ],
          comments: [
            FeedComments(id: 1, comment: 'Looks like a production-ready app', feedId: 4, userName: 'flutter_builder'),
          ]),
    ];
  }
}
