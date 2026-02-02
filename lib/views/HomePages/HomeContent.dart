import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:media_radar/models/New.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:media_radar/views/HomePages/AddCreateCategoryAppBar.dart';
import 'package:media_radar/views/HomePages/ShowDate.dart';
import 'package:provider/provider.dart';
import '../../constants/Constant.dart';
import '../../providers/FavouriteProvider.dart';
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

class _HomeContentState extends State<HomeContent> with AutomaticKeepAliveClientMixin {
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
    _initDeepLinks();

    Future.microtask(() {
      final provider = Provider.of<NewsProvider>(context, listen: false);

      if (provider.statucCode == 1) {
        provider.getAllnewsByStreamKeyword(page: 1, append: false);
      } else {
        provider.getAllnewsByTelegram(page: 1, append: false);
      }
      final favouriteProvider = Provider.of<FavouriteProvider>(context, listen: false);
      favouriteProvider.getFavouriteNews(provider);
    });

    _loadTodayNews();
  }

  void _initDeepLinks() {
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((uri) {
      if (uri.path.contains('newsItem')) {
        final id = uri.queryParameters['id'];
        final date = uri.queryParameters['date'];
        if (id != null && date != null) {
          Navigator.pushNamed(context, '/newsItem', arguments: {'id': int.parse(id), 'date': date});
        }
      }
    });
  }

  void _loadTodayNews() {
    DateTime today = DateTime.now();
    List<String> months = ['yanvar', 'fevral', 'mart', 'aprel', 'may', 'iyun', 'iyul', 'avqust', 'sentyabr', 'oktyabr', 'noyabr', 'dekabr'];
    setState(() {
      dateText = "${today.day} ${months[today.month - 1]} ${today.year}";
      formattedDate = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    });
  }

  void _scrollListener() {
    final provider = Provider.of<NewsProvider>(context, listen: false);
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 && !provider.isLoading) {
      page++;
      provider.statucCode == 1
          ? provider.getAllnewsByStreamKeyword(page: page, append: true)
          : provider.getAllnewsByTelegram(page: page, append: true);
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
              List<String> months = ['yanvar', 'fevral', 'mart', 'aprel', 'may', 'iyun', 'iyul', 'avqust', 'sentyabr', 'oktyabr', 'noyabr', 'dekabr'];

              String formatAzDate(String? dateStr) {
                DateTime date = dateStr != null ? DateTime.parse(dateStr) : DateTime.now();
                return "${date.day} ${months[date.month - 1]} ${date.year}";
              }

              String finalText = (provider.tableStartDate != null && provider.tableEndDate != null)
                  ? "${formatAzDate(provider.tableStartDate)} - ${formatAzDate(provider.tableEndDate)}"
                  : formatAzDate(null);

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
                      onTap: () => setState(() => isShowMenu = !isShowMenu),
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: const Color(0xFF646464)),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.more_horiz, size: 20, color: Colors.black),
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => setState(() => isGrid = !isGrid),
                        icon: Icon(isGrid ? Icons.view_list : Icons.grid_view_outlined, color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () => addCategoryAppBar(context),
                        child: Container(
                          margin: const EdgeInsets.only(right: 15, left: 5),
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(color: Color(0xFF23C98D), shape: BoxShape.circle),
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

                        duration: Duration(milliseconds: 200),

                        child: Text(

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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ana Səhifə', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: Color(0xFF3F3BA3))),
                          const SizedBox(height: 10),
                          Text(finalText, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),

                  if (newsList.isEmpty && !provider.isLoading)
                    const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('Xəbərlər mövcud deyil...', style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    )
                  else if (isGrid)
                    _gridView(newsList)
                  else
                    _listView(newsList),

                  SliverToBoxAdapter(
                    child: Visibility(
                      visible: provider.isLoading,
                      child: const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator())),
                    ),
                  ),
                ],
              );
            }),

            if (isShowMenu)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() => isShowMenu = false),
                  child: Container(color: Colors.transparent),
                ),
              ),

            AnimationContainerInAppBar(
              isShowMenu: isShowMenu,
              onSelect: (selected) {
                setState(() => isShowMenu = false);
                if (selected == "Seçilmiş mənbə") showSelectedSheet(context);
                else if (selected == "Aktiv kateqoriyalar") selectedActiveCategory(context);
                else if (selected == "Tarix") {
                  showDate(context);
                  setState(() => page = 1);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding _gridView(List<News> newsList) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.70,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => SelectedItemForGrid(news: newsList[index]),
          childCount: newsList.length,
        ),
      ),
    );
  }

  SliverPadding _listView(List<News> newsList) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => SelectedItemForList(news: newsList[index]),
          childCount: newsList.length,
        ),
      ),
    );
  }
}