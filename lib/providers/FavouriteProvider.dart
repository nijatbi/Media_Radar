import 'package:flutter/cupertino.dart';
import 'package:media_radar/models/New.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:media_radar/services/FavouriteService.dart';
import 'package:provider/provider.dart';

class FavouriteProvider extends ChangeNotifier{
    List<News>? favouritesList=[];
    bool isLoading=false;

    Future<void> addNewsToFavourite(int id)async{
      isLoading=true;
      try{

      }
      catch (e){
        throw  Exception("Xeta bas verdi : ${e}");
      }
    }

    Future<void>getFavouriteNews(NewsProvider newsProvider) async{
      isLoading=true;
      final fetchNews=await FavouriteService.getNewsFromMain();
      favouritesList=[];
      favouritesList=fetchNews;
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

}