import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
            // Başlıq
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

            // Carousel
            Expanded(
              child: Swiper(
                itemCount: 10,
                layout: SwiperLayout.STACK,
                itemWidth: screenWidth * 0.8,
                itemHeight: screenHeight * 0.55,
                onIndexChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  bool isCurrent = index == _currentIndex;
                  return Transform.translate(
                    offset: Offset(0, isCurrent ? 0 : 20),
                    child: Transform.scale(
                      scale: isCurrent ? 1.0 : 0.85,
                      child: Stack(
                        children: [
                          // Şəkil və transparan alt kartlar
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/photo.webp'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black26, BlendMode.darken),
                              ),
                            ),
                          ),
                          // Siyaset etiketi 45°
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Transform.rotate(
                              angle: 0.785398, // 45°
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.flag, size: 14),
                                    SizedBox(width: 4),
                                    Text(
                                      'Siyaset',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Alt məlumat
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/Rectangle 299.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      'media.az',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'President of the Republic of Azerbaijan Ilham Aliyev made a speech at general debates of 75th session of United Nations General Assembly in a video format',
                                  style: TextStyle(fontSize: 14,
                                      fontWeight: FontWeight.w500

                                      ,color: Colors.white),
                                  maxLines: 2,

                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.grey,
                    activeColor: Colors.green,
                    size: 8.0,
                    activeSize: 10.0,
                    space: 4.0,
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
