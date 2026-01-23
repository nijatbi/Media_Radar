import 'package:flutter/material.dart';
import 'package:media_radar/constants/Constant.dart';

class SelectedList extends StatefulWidget {
  const SelectedList({super.key});

  @override
  State<SelectedList> createState() => _SelectedListState();
}

class _SelectedListState extends State<SelectedList> {
  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            /// APP BAR
            SliverAppBar(
              floating: true,
              pinned: true,
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

            isGrid ? _gridView() : _listView(),
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
          mainAxisSpacing: 0,
          crossAxisSpacing: 10,
          childAspectRatio: 0.70,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                          image:
                          AssetImage('assets/images/Rectangle 299.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/download.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'oxu.az',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Süni intellekt 2030-cu ilə qədər yalnız bir neçə iş yerini əvəzləyə bilməyəcək',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.bookmark,
                        color: Color(0xFFF66F6A),
                        size: 20,
                      ),
                    ),
                  ],
                ),

                Text(
                  '10.08.2025 • 15:47',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                      fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            );
          },
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
              (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image:
                        AssetImage('assets/images/Rectangle 299.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/download.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'oxu.az',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.bookmark,
                                color: Color(0xFFF66F6A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Süni intellekt 2030-cu ilə qədər yalnız bir neçə iş yerini əvəzləyə bilməyəcək',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '10.08.2025 • 15:47',
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            );
          },
          childCount: 10,
        ),
      ),
    );
  }
}
