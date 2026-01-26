import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:media_radar/views/dailies/DailyNewItem.dart';
import '../../constants/Constant.dart';

class Daily extends StatefulWidget {
  const Daily({super.key});

  @override
  State<Daily> createState() => _DailyState();
}

class _DailyState extends State<Daily> {
  int _currentIndex = 0;
  List<Map<String, String>> data=[
    {
      'id':'1',
      'image':"assets/images/photo.webp",
      'title':"media.az",
      'desc':"xeberler barede melumat xeberler barede melumat xeberler barede melumat xeberler barede melumat xeberler barede melumat "
    ,'date' :'10.08.2025 • 15:47'
    },
    {
      'image':"assets/images/Rectangle 299.png",
      'id':'12',

      'title':"media.az",
      'desc':"xeberler barede melumat xeberler barede melumat xeberler barede melumat xeberler barede melumat xeberler barede melumat "
      ,'date' :'10.08.2025 • 15:47'
    },
    {
      'image':"assets/images/download.png",
      'id':'13',

      'title':"media.az",
      'desc':"xeberler barede melumat xeberler barede melumat xeberler barede melumat xeberler barede melumat xeberler barede melumat "
      ,'date' :'10.08.2025 • 15:47'
    },
    {
      'image':"assets/images/images.jpg",
      'id':'14',

      'title':"media.az",
      'desc':"xeberler barede melumat xeberler barede melumat xeberler barede melumat xeberler barede melumat xeberler barede melumat "
      ,'date' :'10.08.2025 • 15:47'
    },
  ];
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

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
            /// BAŞLIQ
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

            /// CAROUSEL
            Expanded(
              child: Swiper(
                itemCount: data.length,
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
                  ..addScale(
                    [1.0, 0.94, 0.88],
                    Alignment.center,
                  ),

                itemBuilder: (context, index) {
                  return DailyNewItem(image: data[index]["image"]!,title: data[index]["title"]!,
                  date: data[index]["date"]!,
                    desc: data[index]["desc"]!,
                    id: data[index]["id"]!,
                  );
                },

                pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.grey,
                    activeColor: Colors.green,
                    size: 8,
                    activeSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
