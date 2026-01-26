import 'package:flutter/material.dart';
import 'package:media_radar/views/HomePages/AddCreateCategoryAppBar.dart';
import 'package:media_radar/views/HomePages/AppBarAlert.dart';
import 'package:media_radar/views/HomePages/CategoryItem.dart';
import 'package:media_radar/views/HomePages/ShowDate.dart';
import 'package:table_calendar/table_calendar.dart';
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

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  bool isGrid = false;
  bool isShowMenu = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Collapsing SliverAppBar
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
                        border: Border.all(width: 2, color: const Color(0xFF646464)),
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

                      // Scroll etdikdə title görünəcək
                      bool showTitle = top <= kToolbarHeight + 20;

                      return FlexibleSpaceBar(
                        centerTitle: true,
                        collapseMode: CollapseMode.pin,
                        title: AnimatedOpacity(
                          opacity: showTitle ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: const Text(
                            '17 noyabr 2025-ci il',
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

                // Ana səhifə başlığı
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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

                // Grid/List toggle
                isGrid ? _gridView() : _listView(),
              ],
            ),

            // Menu overlay
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
                  else if (selected == "Aktiv kateqoriyalar") selectedActiveCategory(context);
                  else if (selected == "Tarix") showDate(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _gridView() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.70,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) => const SelectedItemForGrid(),
          childCount: 10,
        ),
      ),
    );
  }

  Widget _listView() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => const SelectedItemForList(),
          childCount: 10,
        ),
      ),
    );
  }
}
