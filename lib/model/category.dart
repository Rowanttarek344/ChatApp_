import 'package:flutter/cupertino.dart';

class Category {
  static const String sportsId = 'sports';
  static const String moviesId = 'movies';
  static const String musicId = 'music';

  String categoryId;
  late String title;
  late String image;

  Category(
      {required this.categoryId, required this.title, required this.image});

  Category.fromId(this.categoryId) {
    if (categoryId == sportsId) {
          title = 'Sports';
          image = 'assets/images/sports.png';
    } else if (categoryId == moviesId) {
          title = 'Movies';
          image = 'assets/images/movies.png';
    } else if (categoryId == musicId) {
          title= 'Music';
          image= 'assets/images/music.png';
    }
  }

  static List<Category> getCategory() {
    return [
      Category.fromId(sportsId),
      Category.fromId(moviesId),
      Category.fromId(musicId)
    ];
  }
}
