import 'package:flutter/material.dart';
import 'package:media_radar/providers/FavouriteProvider.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:provider/provider.dart';

import '../../constants/Constant.dart';
void showSelectedSheet(BuildContext context) {

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Xəbər mənbəyini seçin',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3C3C4399),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, thickness: 1),
                  ListTile(
                    title:  Center(child: Text('Yerli xəbərlər',style: TextStyle(
                        fontSize: 20,

                        fontWeight:FontWeight.w500 ,color: Constant.languageAlertColor),)),
                    onTap: () {
                      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
                      newsProvider.updateStatusCode(1);
                      final favouriteProvider=Provider.of<FavouriteProvider>(context,listen: false);
                      favouriteProvider.getFavouriteNews(newsProvider);
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(height: 1, thickness: 1),
                  ListTile(

                    title:  Center(child: Text('Telegram',style: TextStyle(
                        fontSize: 20,
                        fontWeight:FontWeight.w500 ,color: Constant.languageAlertColor
                    ),)),
                    onTap: () async{
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
                      newsProvider.updateStatusCode(2);
                      final favouriteProvider=Provider.of<FavouriteProvider>(context,listen: false);
                      favouriteProvider.getFavouriteNews(newsProvider);
                    },
                  ),
                  const Divider(height: 1, thickness: 1),
                  ListTile(
                    title: const Center(
                      child: Text('İmtina et', style: TextStyle(color: Colors.red)),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}