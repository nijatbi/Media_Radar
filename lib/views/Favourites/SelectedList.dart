import 'package:flutter/material.dart';
import 'package:media_radar/constants/Constant.dart';
import 'package:media_radar/views/Favourites/Selected%C4%B0temforList.dart';
import 'package:media_radar/views/Favourites/SelectedItemForGrid.dart';

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
            return SelectedItemForGrid();
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
            return SelectedItemForList();
          },
          childCount: 10,
        ),
      ),
    );
  }
}
