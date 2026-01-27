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

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool isGrid = false;
  bool isShowMenu = false;
  int page = 1;
  late ScrollController _scrollController;
  late String formattedDate;
  late String dateText;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _loadTodayNews();
  }

  void _loadTodayNews() {
    DateTime today = DateTime.now();
    const List<String> months = [
      'yanvar', 'fevral', 'mart', 'aprel', 'may', 'iyun',
      'iyul', 'avqust', 'sentyabr', 'oktyabr', 'noyabr', 'dekabr'
    ];
    setState(() {
      dateText =
      "${today.day} ${months[today.month - 1]} ${today.year}-ci il";
    });
    setState(() {
      formattedDate =
      "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    });

    Future.microtask(() {
      Provider.of<NewsProvider>(context, listen: false)
          .getAllnewsByStreamKeyword(
        startDate: formattedDate,
        endDate: formattedDate,
        page: page,
        append: page > 1,
      );
    });
  }

  void _scrollListener() {
    final provider = Provider.of<NewsProvider>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !provider.isLoading) {
      page++;
      _loadTodayNews();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Consumer<NewsProvider>(builder: (context, newsProvider, child) {
              final newsList = newsProvider.newsList ?? [];

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
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2, color: const Color(0xFF646464)),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.more_horiz, size: 20),
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
                          margin: const EdgeInsets.only(right: 15, left: 5),
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
                            duration: const Duration(milliseconds: 200),
                            child:  Text(
                              '${dateText}',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3F3BA3)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SliverToBoxAdapter(
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
                            '17 noyabr 2025-ci il',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (newsList.isEmpty && !newsProvider.isLoading)
                    const SliverToBoxAdapter(
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
                    _gridView(newsList, newsProvider)
                  else
                    _listView(newsList, newsProvider),

                  SliverToBoxAdapter(
                    child: Visibility(
                      visible: newsProvider.isLoading,
                      child: const Padding(
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
                  else if (selected == "Tarix") showDate(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  SliverPadding _gridView(List<News> newsList, NewsProvider provider) {
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
            return SelectedItemForGrid(news: news);
          },
          childCount: newsList.length,
        ),
      ),
    );
  }

  SliverPadding _listView(List<News> newsList, NewsProvider provider) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
