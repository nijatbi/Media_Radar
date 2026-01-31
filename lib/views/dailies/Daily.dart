import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:media_radar/views/dailies/DailyNewItem.dart';
import 'package:provider/provider.dart';
import '../../constants/Constant.dart';
// Menyu və pəncərələr üçün lazımi importlar
import '../HomePages/AddCreateCategoryAppBar.dart';
import '../HomePages/SelectedAvtiveCategoryList.dart';
import '../HomePages/ShowDate.dart';
import '../HomePages/ShowSelectedSheet.dart';
import '../HomePages/ToolBarAppBar.dart';

class Daily extends StatefulWidget {
  const Daily({super.key});

  @override
  State<Daily> createState() => _DailyState();
}

class _DailyState extends State<Daily> {
  int _currentIndex = 0;
  bool isShowMenu = false;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isShowMenu = !isShowMenu;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: const Color(0xFF646464)),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.more_horiz, size: 20),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          addCategoryAppBar(context);
                        },
                        child: Container(
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
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Gündəm',
                    style: TextStyle(
                      color: Constant.baseColor,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                Consumer<NewsProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final filteredNews = (provider.newsList ?? [])
                        .where((news) {
                      if (news.imageUrl == null) return false;
                      if (news.imageUrl!.trim().isEmpty) return false;
                      if (news.imageUrl!.toLowerCase() == "null") return false;
                      if (news.imageUrl!.contains("file:///null")) return false;
                      return true;
                    })
                        .take(7)
                        .toList();

                    if (filteredNews.isEmpty) {
                      return const Expanded(
                        child: Center(child: Text('Xəbərlər mövcud deyil...',style: TextStyle(fontSize: 14,color: Colors.red,fontWeight: FontWeight.w500),)),
                      );
                    }

                    return Expanded(
                      child: Swiper(
                        itemCount: filteredNews.length,
                        layout: SwiperLayout.STACK,
                        itemWidth: screenWidth * 0.88,
                        itemHeight: screenHeight * 0.6,
                        onIndexChanged: (index) {
                          setState(() => _currentIndex = index);
                        },
                        customLayoutOption: CustomLayoutOption(
                          startIndex: -1,
                          stateCount: 3,
                        )
                          ..addTranslate([
                            const Offset(0, 0),
                            const Offset(0, 28),
                            const Offset(0, 56),
                          ])
                          ..addScale([1.0, 0.94, 0.88], Alignment.center),
                        itemBuilder: (context, index) {
                          final item = filteredNews[index];
                          String rawText = item.text ?? "";
                          String displayTitle = provider.statucCode == 1
                              ? (item.title ?? "")
                              : (rawText.length > 35 ? "${rawText.substring(0, 35)}..." : rawText);

                          return DailyNewItem(
                            imageUrl: item.imageUrl!,
                            coverImage: item.channelImage ?? "",
                            title: displayTitle,
                            isSaved: item.isSaved!,
                            categoryName: item.category ?? "Gündəm",
                            date: item.scrapedAt?.toString().split('.').first ?? "",
                            desc: rawText,
                            id: item.id!,
                          );
                        },
                        pagination: const SwiperPagination(
                          alignment: Alignment.bottomCenter,
                          builder: DotSwiperPaginationBuilder(
                            color: Colors.grey,
                            activeColor: Colors.green,
                            size: 8,
                            activeSize: 10,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            if (isShowMenu)
              Positioned.fill(
                child: GestureDetector(
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
                else if (selected == "Tarix") showDate(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}