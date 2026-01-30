import 'package:flutter/cupertino.dart';
import 'package:media_radar/models/New.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:media_radar/services/FavouriteService.dart';
import 'package:provider/provider.dart';

class FavouriteProvider extends ChangeNotifier{
    List<News>? favouritesList=[];
    bool isLoading=false;
    Future<void> addNewsToFavourite(int? id, NewsProvider newsProvider) async {
      isLoading = true;
      notifyListeners();

      try {
        final response = await FavouriteService.addNewsToFavService(id);

        if (response) {

          await getFavouriteNews(newsProvider);
        }
      } catch (e) {
        print("Xeta: $e");
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
    Future<void> addNewsToFavouriteInTelegram(int? channel_id,int post_id, NewsProvider newsProvider) async {
      isLoading = true;
      notifyListeners();

      try {
        final response = await FavouriteService.addNewsToFavTelegramService(
          channel_id,
          post_id,
        );

        if (response) {
          await getFavouriteNews(newsProvider);
          notifyListeners();
        }
      } catch (e) {
        print("Xeta: $e");
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }


    Future<void> deleteNewsFromMainProvider(int?id,NewsProvider newsProvider)async{
      isLoading=true;
      notifyListeners();
      final response=await FavouriteService.deleteNewsFromMain(id);
      if(response){
        getFavouriteNews(newsProvider);
        isLoading=false;
        notifyListeners();
      }
      else{
        isLoading=false;
        notifyListeners();
      }
    }


    Future<void> deleteNewsFromTelegram(int?channelId,int? postId,NewsProvider newsProvider)async{
      isLoading=true;
      notifyListeners();
      final response=await FavouriteService.deleteNewsFromTelegram(channelId,postId);
      if(response){
        getFavouriteNews(newsProvider);
        isLoading=false;
        notifyListeners();
      }
      else{
        isLoading=false;
        notifyListeners();
      }
    }


    Future<void>getFavouriteNews(NewsProvider newsProvider) async{
      isLoading=true;
      favouritesList=[];
      if(newsProvider.statucCode==1){
        final fetchNews=await FavouriteService.getNewsFromMain();
        favouritesList=[];
        favouritesList=fetchNews;
        isLoading=false;

        notifyListeners();

      }
      else{
        final fetchNewsFromTg=await FavouriteService.getNewsFromTelegram();
        favouritesList=[];
        favouritesList=fetchNewsFromTg;
        isLoading=false;
        notifyListeners();
      }

      notifyListeners();
    }

    bool isItemSaved(int id) {
        return  favouritesList?.any((news) => news.id == id) ?? false;
    }

}