import 'package:flutter/material.dart';

import '../notifier/theme.dart';

class GlobalParams {
  static MonTheme themeActuel=MonTheme();
  static List<Map<String, dynamic>> menus = [
    {"title": "Home", "icon": Icon(Icons.home, color: Colors.blueAccent), "route": "/home"},
    {"title": "Leaderboard", "icon": Icon(Icons.leaderboard, color: Colors.blueAccent), "route": "/leaderboard"},
    {"title": "Achievements", "icon": Icon(Icons.emoji_events, color: Colors.blueAccent), "route": "/achievements"},
    {"title": "Settings", "icon": Icon(Icons.settings, color: Colors.blueAccent), "route": "/settings"},

  ];


  static const List<Map<String, dynamic>> categories = [
    {'name': 'Any Category', 'index': 0},
    {'name': 'General Knowledge', 'index': 9},
    {'name': 'Entertainment: Books', 'index': 10},
    {'name': 'Entertainment: Film', 'index': 11},
    {'name': 'Entertainment: Music', 'index': 12},
    {'name': 'Entertainment: Musicals & Theatres', 'index': 13},
    {'name': 'Entertainment: Television', 'index': 14},
    {'name': 'Entertainment: Video Games', 'index': 15},
    {'name': 'Entertainment: Board Games', 'index': 16},
    {'name': 'Science & Nature', 'index': 17},
    {'name': 'Science: Computers', 'index': 18},
    {'name': 'Science: Mathematics', 'index': 19},
    {'name': 'Mythology', 'index': 20},
    {'name': 'Sports', 'index': 21},
    {'name': 'Geography', 'index': 22},
    {'name': 'History', 'index': 23},
    {'name': 'Politics', 'index': 24},
    {'name': 'Art', 'index': 25},
    {'name': 'Celebrities', 'index': 26},
    {'name': 'Animals', 'index': 27},
    {'name': 'Vehicles', 'index': 28},
    {'name': 'Entertainment: Comics', 'index': 29},
    {'name': 'Science: Gadgets', 'index': 30},
    {'name': 'Entertainment: Japanese Anime & Manga', 'index': 31},
    {'name': 'Entertainment: Cartoon & Animations', 'index': 32},
  ];


}
