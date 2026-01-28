import 'package:flutter/material.dart';
import 'package:media_radar/models/New.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:media_radar/views/HomePages/AddCreateCategoryAppBar.dart';
import 'package:media_radar/views/HomePages/AppBarAlert.dart';
import 'package:media_radar/views/HomePages/ShowDate.dart';
import 'package:provider/provider.dart';
import '../../constants/Constant.dart';
import '../Favourites/SelectedItemForGrid.dart';
import '../Favourites/SelectedİtemforList.dart';
import 'SelectedAvtiveCategoryList.dart';
import 'ShowSelectedSheet.dart';
import 'ToolBarAppBar.dart';
import 'package:intl/intl.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with AutomaticKeepAliveClientMixin{
  bool isGrid = false;
  bool isShowMenu = false;
  int page = 1;
  late ScrollController _scrollController;
  late String formattedDate;
  late String dateText;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);

    Future.microtask(() {
      final provider = Provider.of<NewsProvider>(context, listen: false);
      if (provider.newsList == null || provider.newsList!.isEmpty) {
        if (provider.statucCode == 1) {
          provider.getAllnewsByStreamKeyword(page: 1, append: false);
        } else {
          provider.getAllnewsByTelegram(page: 1, append: false);
        }
      }
    });

    _loadTodayNews();
  }
  void _loadTodayNews() {
    DateTime today = DateTime.now();
     List<String> months = [
      'yanvar', 'fevral', 'mart', 'aprel', 'may', 'iyun',
      'iyul', 'avqust', 'sentyabr', 'oktyabr', 'noyabr', 'dekabr'
    ];
    setState(() {
      dateText =
      "${today.day} ${months[today.month - 1]} ${today.year}-cı il";
    });
    setState(() {
      formattedDate =
      "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    });
  }

  void _scrollListener() {
    final provider = Provider.of<NewsProvider>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !provider.isLoading) {
      page++;

      if (provider.statucCode == 1) {
        provider.getAllnewsByStreamKeyword(page: page, append: true);
      } else {
        provider.getAllnewsByTelegram(page: page, append: true);
      }
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Consumer<NewsProvider>(builder: (context, provider, child) {
              final newsList = provider.newsList ?? [];
               List<String> months = [
                'yanvar', 'fevral', 'mart', 'aprel', 'may', 'iyun',
                'iyul', 'avqust', 'sentyabr', 'oktyabr', 'noyabr', 'dekabr'
              ];

              String formatAzDate(String? dateStr) {
                DateTime date = dateStr != null ? DateTime.parse(dateStr) : DateTime.now();

                String day = date.day.toString();
                String monthName = months[date.month - 1];
                String year = date.year.toString();

                return "$day $monthName $year-cı il";
              }

              String finalText;
              if (provider.tableStartDate != null && provider.tableEndDate != null) {
                finalText = "${formatAzDate(provider.tableStartDate)} - ${formatAzDate(provider.tableEndDate)}";
              } else {
                finalText = formatAzDate(null); // Bugün
              }
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    expandedHeight: 80,
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
                        margin:  EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2, color: const Color(0xFF646464)),
                          shape: BoxShape.circle,
                        ),
                        child:  Icon(Icons.more_horiz, size: 20),
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
                          isGrid ? Icons.view_list : Icons.grid_view_outlined,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          addCategoryAppBar(context);
                        },
                        child: Container(
                          margin:  EdgeInsets.only(right: 15, left: 5),
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFF23C98D),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      )
                    ],
                    flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        double top = constraints.biggest.height;
                        bool showTitle = top <= kToolbarHeight + 20;
                        return FlexibleSpaceBar(
                          centerTitle: true,
                          collapseMode: CollapseMode.pin,
                          title: AnimatedOpacity(
                            opacity: showTitle ? 1.0 : 0.0,
                            duration:  Duration(milliseconds: 200),
                            child:  Text(
                              '${finalText}',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3F3BA3)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                   SliverToBoxAdapter(
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ana Səhifə',
                            style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3F3BA3)),
                          ),
                          SizedBox(height: 10),
                          Text(
                        '${finalText}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (newsList.isEmpty && !provider.isLoading)
                     SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Xəbərlər mövcud deyil... Zəhmət olmasa Kateqoriya yaradın...',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )
                  else if (isGrid)
                    _gridView(newsList, provider)
                  else
                    _listView(newsList, provider),

                  SliverToBoxAdapter(
                    child: Visibility(
                      visible: provider.isLoading,
                      child:  Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
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
            if (isShowMenu)
              AnimationContainerInAppBar(
                isShowMenu: isShowMenu,
                onSelect: (selected) {
                  setState(() {
                    isShowMenu = false;
                  });
                  if (selected == "Seçilmiş mənbə") showSelectedSheet(context);
                  else if (selected == "Aktiv kateqoriyalar")
                    selectedActiveCategory(context);
                  else if (selected == "Tarix") {
                    setState(() {
                      isShowMenu = false;
                    });

                    showDate(context);

                    setState(() {
                      page = 1;
                    });
                  };
                },
              ),
          ],
        ),
      ),
    );
  }

  SliverPadding _gridView(List<News> newsList, NewsProvider provider) {
    return SliverPadding(
      padding:  EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.70,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final news = newsList[index];
            return SelectedItemForGrid(news: news);
          },
          childCount: newsList.length,
        ),
      ),
    );
  }

  SliverPadding _listView(List<News> newsList, NewsProvider provider) {
    return SliverPadding(
      padding:  EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final news = newsList[index];
            return SelectedItemForList(news: news);
          },
          childCount: newsList.length,
        ),
      ),
    );
  }
}
