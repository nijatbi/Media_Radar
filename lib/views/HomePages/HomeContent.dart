import 'package:flutter/material.dart';
import 'package:media_radar/views/HomePages/AppBarAlert.dart';
import 'package:media_radar/views/HomePages/CategoryItem.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constants/Constant.dart';
import '../Favourites/SelectedItemForGrid.dart';
import '../Favourites/SelectedİtemforList.dart';
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  bool isGrid = false;
  bool isShowMenu=false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
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
                      child:
                      const Icon(Icons.more_horiz, size: 20),
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
                        isGrid
                            ? Icons.view_list
                            : Icons.grid_view_outlined,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin:
                      const EdgeInsets.only(right: 15, left: 5),
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF23C98D),
                        shape: BoxShape.circle,
                      ),
                      child:
                      const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Ana Səhifə',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '11 noyabr 2025-ci il',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                isGrid ? _gridView() : _listView(),
              ],
            ),
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

            Positioned(
              top: kToolbarHeight + 1,
              left: 10,
              right: 16,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: isShowMenu ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !isShowMenu,
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: isShowMenu
                        ? AppBarAlert(
                      showMenu: isShowMenu,
                      onSelect: (selected) {
                        print('kliklendi: $selected');
                        setState(() {
                          isShowMenu = false;
                        });
                        if(selected=="Seçilmiş mənbə"){
                          _showSelectedSheet();
                        }
                        else if(selected=="Aktiv kateqoriyalar"){
                          _selectedActiveCategory();
                        }
                        else if(selected=="Tarix"){
                            _showDate();
                        }
                      },
                    )
                        : const SizedBox(),
                  ),
                ),
              ),
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
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
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
              (context, index) =>
          const SelectedItemForList(),
          childCount: 10,
        ),
      ),
    );
  }

  void _selectedActiveCategory() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return Container(
              color: Colors.white,
              height: 400,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            width: 80,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Başlıq + divider
                        const Text(
                          'Aktiv kateqoriyalar',
                          style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 30),
                        const Divider(height: 1, color: Colors.grey),

                        const SizedBox(height: 10),

                        // Kateqoriyalar scrollable, max height 150
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 150,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(6, (index) {
                                return CategoryItem();
                              }),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 120,
                    left: 24,
                    right: 24,
                    child: Column(
                      children: const [
                        Divider(height: 1, color: Colors.grey),
                      ],
                    ),
                  ),

                  // Həmişə bottomda button
                  Positioned(
                    bottom: 40,
                    left: 24,
                    right: 24,
                    child: SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constant.baseColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        child: const Text(
                          'Təsdiqlə',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 550,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    // Drag indicator
                    Container(
                      width: 80,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Calendar + alt yazı scrollable
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Calendar
                            TableCalendar(
                              firstDay: DateTime(2000, 1, 1),
                              lastDay: DateTime(2100, 12, 31),
                              focusedDay: DateTime.now(),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                leftChevronIcon: Icon(Icons.chevron_left),
                                rightChevronIcon: Icon(Icons.chevron_right),
                                titleTextStyle: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(
                                  color: Constant.baseColor.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: Constant.baseColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              onDaySelected: (selectedDay, focusedDay) {
                                print("Seçilmiş tarix: $selectedDay");
                              },
                            ),

                            const SizedBox(height: 16),

                            // Alt yazı
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.date_range),SizedBox(width: 10,),
                                const Text(
                                  "13 noy 2025 - 14 noy 2025 ",
                                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500, color: Colors.black),
                                ),
                              ],
                            ),

                            const SizedBox(height: 80), // Bottom button üçün boşluq
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom fixed button
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.baseColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    child: const Text(
                      "Təsdiqlə",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }






  void _showSelectedSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Xəbər mənbəyini seçin',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF3C3C4399),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, thickness: 1),
                    ListTile(
                      title:  Center(child: Text('Yerli xəbərlər',style: TextStyle(
                          fontSize: 20,

                          fontWeight:FontWeight.w500 ,color: Constant.languageAlertColor),)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(height: 1, thickness: 1),
                    ListTile(
                      title:  Center(child: Text('Telegram',style: TextStyle(
                          fontSize: 20,
                          fontWeight:FontWeight.w500 ,color: Constant.languageAlertColor
                      ),)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(height: 1, thickness: 1),
                    ListTile(
                      title: const Center(
                        child: Text('İmtina et', style: TextStyle(color: Colors.red)),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
