import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:media_radar/views/dailies/DailyNewItem.dart';
import 'package:provider/provider.dart';
import '../../constants/Constant.dart';

class Daily extends StatefulWidget {
  const Daily({super.key});

  @override
  State<Daily> createState() => _DailyState();
}

class _DailyState extends State<Daily> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final newsProvider=Provider.of<NewsProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: const Color(0xFF646464)),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.more_horiz, size: 20),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 15, left: 5),
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF23C98D),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    child: Center(child: Text('Xəbərlər mövcud deyil...')),
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

                      String rawTitle = item.title ?? "";
                      String rawText = item.text ?? "";

                      String displayTitle = "";
                      String displayDesc = "";

                      if (provider.statucCode == 1) {
                        displayTitle = rawTitle;
                        displayDesc = rawText;
                      } else {
                        displayTitle = rawText.length > 35
                            ? "${rawText.substring(0, 35)}..."
                            : rawText;
                        displayDesc = rawText;
                      }

                      return DailyNewItem(
                        imageUrl: item.imageUrl!,
                        coverImage: item.channelImage ?? "",
                        title: displayTitle,
                        isSaved: item.isSaved!,
                        categoryName: item.category ?? "Gündəm",
                        date: item.scrapedAt?.toString().split('.').first ?? "",
                        desc: displayDesc,
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
      ),
    );
  }
}
