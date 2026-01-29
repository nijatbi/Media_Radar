  import 'package:flutter/material.dart';
  import 'package:media_radar/constants/Constant.dart';
  import 'package:media_radar/providers/FavouriteProvider.dart';
  import 'package:media_radar/views/Favourites/Selected%C4%B0temforList.dart';
  import 'package:provider/provider.dart';

  import '../../models/New.dart';
  import '../../providers/NewsProvider.dart';
  import '../HomePages/AddCreateCategoryAppBar.dart';
  import '../HomePages/SelectedAvtiveCategoryList.dart';
  import '../HomePages/ShowDate.dart';
  import '../HomePages/ShowSelectedSheet.dart';
  import '../HomePages/ToolBarAppBar.dart';
  import 'SelectedItemForGrid.dart';

  class SelectedList extends StatefulWidget {
    const SelectedList({super.key});

    @override
    State<SelectedList> createState() => _SelectedListState();
  }

  class _SelectedListState extends State<SelectedList> {
    bool isGrid = false;
    bool isShowMenu=false;


    @override
    Widget build(BuildContext context) {
      final favouriteProvider=Provider.of<FavouriteProvider>(context);
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Consumer<FavouriteProvider>(builder: (context,provider,child){
                final favouirteNews=favouriteProvider.favouritesList ?? [];
               return  CustomScrollView(
                 slivers: [

                   SliverAppBar(
                     floating: true,
                     pinned: true,
                     backgroundColor: Colors.white,
                     elevation: 0,
                     surfaceTintColor: Colors.transparent,
                     leading: GestureDetector(
                       onTap: () {
                         setState(() {
                           isShowMenu = !isShowMenu;
                         });
                       },
                       child: Container(
                         margin: const EdgeInsets.all(12),
                         decoration: BoxDecoration(
                           border: Border.all(
                               width: 2, color: const Color(0xFF646464)),
                           shape: BoxShape.circle,
                         ),
                         child:
                         const Icon(Icons.more_horiz, size: 20),
                       ),
                     ),
                     actions: [
                       IconButton(
                         onPressed: () {
                           setState(() {
                             isGrid = !isGrid;
                           });
                         },
                         icon: Icon(
                           isGrid
                               ? Icons.view_list
                               : Icons.grid_view_outlined,
                           color: Colors.black,
                         ),
                       ),
                       GestureDetector(
                         onTap: (){
                           addCategoryAppBar(context);
                         },
                         child: Container(
                           margin:
                           const EdgeInsets.only(right: 15, left: 5),
                           width: 40,
                           height: 40,
                           decoration: const BoxDecoration(
                             color: Color(0xFF23C98D),
                             shape: BoxShape.circle,
                           ),
                           child:
                           const Icon(Icons.add, color: Colors.white),
                         ),
                       )
                     ],
                   ),

                   SliverToBoxAdapter(
                     child: Padding(
                       padding:
                       const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                       child: Text(
                         'Seçilmişlər',
                         style: TextStyle(
                           color: Constant.baseColor,
                           fontSize: 34,
                           fontWeight: FontWeight.w700,
                         ),
                       ),
                     ),
                   ),
                   if (favouirteNews!.isEmpty && !provider.isLoading)
                     SliverToBoxAdapter(
                       child: Center(
                         child: Padding(
                           padding: EdgeInsets.all(20),
                           child: Text(
                             ' Heç bir xəbər seçilməyib...',
                             style: TextStyle(
                                 fontSize: 16,
                                 color: Colors.red,
                                 fontWeight: FontWeight.w600),
                           ),
                         ),
                       ),
                     )

                         else if (isGrid)
                       _gridView(favouirteNews, provider)
                   else
                   _listView(favouirteNews, provider),
                 ],

               );

              }),
              if (isShowMenu)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        isShowMenu = false;
                      });
                    },
                  ),
                ),

              AnimationContainerInAppBar(
                isShowMenu: isShowMenu,
                onSelect: (selected) {
                  setState(() {
                    isShowMenu = false;
                  });

                  if(selected == "Seçilmiş mənbə") showSelectedSheet(context);
                  else if(selected == "Aktiv kateqoriyalar") selectedActiveCategory(context);
                  else if(selected == "Tarix") showDate(context);
                },
              )
            ],
          )

        ),
      );
    }

    SliverPadding _gridView(List<News> newsList, FavouriteProvider provider) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            childAspectRatio: 0.70,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final news = newsList[index];
              return SelectedItemForGrid(news: news,key: ValueKey("grid_${news.id}"),);
            },
            childCount: newsList.length,
          ),
        ),
      );
    }

    SliverPadding _listView(List<News> newsList, FavouriteProvider provider) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final news = newsList[index];
              return SelectedItemForList(news: news,key: ValueKey("grid_${news.id}"),);
            },
            childCount: newsList.length,
          ),
        ),
      );
    }
  }
