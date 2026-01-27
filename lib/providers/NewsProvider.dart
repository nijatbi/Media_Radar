import 'package:flutter/cupertino.dart';
import 'package:media_radar/models/New.dart';
import 'package:media_radar/services/NewsService.dart';

class NewsProvider extends ChangeNotifier {
  bool isLoading = false;
  List<News>? newsList = [];

  Future<void> getAllnewsByStreamKeyword({
    String? startDate,
    String? endDate,
    int page = 1,
    bool append = false,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final fetchedNews = await NewsService.getUserByStream(
        startDate: startDate,
        endDate: endDate,
        page: page,
      );

      if (append) {
        newsList = [...?newsList, ...fetchedNews];
      } else {
        newsList = fetchedNews;
      }

      notifyListeners();
    } catch (e) {
      print("NewsProvider exception: $e");
      if (!append) {
        newsList = [];
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
