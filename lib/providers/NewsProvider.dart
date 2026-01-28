import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_radar/models/New.dart';
import 'package:media_radar/services/NewsService.dart';

class NewsProvider extends ChangeNotifier {
  bool isLoading = false;
  List<News>? newsList = [];

  String? tableStartDate;
  String? tableEndDate;

  int statucCode=1;
  void updateDates(String? start, String? end) {
    tableStartDate = start;
    tableEndDate = end;
    notifyListeners();
  }

  void updateStatusCode(int statusC){
    statucCode=statusC;
    notifyListeners();
    if(statucCode==1){
      newsList=[];
      getAllnewsByStreamKeyword(page: 1,append: false);
      notifyListeners();
    }
    else{
      newsList=[];
      getAllnewsByTelegram(page:1,append: false);
      notifyListeners();
    }
    print("Status code : ${statucCode}");
  }

  Future<void> getAllnewsByStreamKeyword({
    int page = 1,
    bool append = false,
  }) async {
    isLoading = true;

    if (!append) {
      newsList = [];
    }
    notifyListeners();

    try {
      String todayFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final String startStr = (tableStartDate != null && tableStartDate!.isNotEmpty)
          ? tableStartDate!
          : todayFormatted;

      final String endStr = (tableEndDate != null && tableEndDate!.isNotEmpty)
          ? tableEndDate!
          : todayFormatted;
      notifyListeners();

      final fetchedNews = await NewsService.getUserByStream(
        startDate: startStr,
        endDate: endStr,
        page: page,
      );
      if (append) {
        newsList = [...?newsList, ...fetchedNews];
      } else {
        newsList = fetchedNews;
      }
    } catch (e) {
      if (!append) {
        newsList = [];
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //Telegramdan datanin cekilmesi


  Future<void> getAllnewsByTelegram({
    int page = 1,
    bool append = false,
  }) async {
    isLoading = true;

    if (!append) {
      newsList = [];
    }
    notifyListeners();

    try {
      String todayFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final String startStr = (tableStartDate != null && tableStartDate!.isNotEmpty)
          ? tableStartDate!
          : todayFormatted;

      final String endStr = (tableEndDate != null && tableEndDate!.isNotEmpty)
          ? tableEndDate!
          : todayFormatted;
      notifyListeners();

      final fetchedNews = await NewsService.getUserByTelegram(
        startDate: startStr,
        endDate: endStr,
        page: page,
      );

      if (append) {
        newsList = [...?newsList, ...fetchedNews];
      } else {
        newsList = fetchedNews;
      }
    } catch (e) {
      if (!append) {
        newsList = [];
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}