import 'package:flutter/material.dart';

import 'package:media_radar/providers/NewsProvider.dart';

import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:intl/intl.dart';

import '../../constants/Constant.dart';
void showDate(BuildContext context) {
  final currentProvider = Provider.of<NewsProvider>(context, listen: false);

  DateTime focusedDay = DateTime.now();
  DateTime? rangeStart;
  DateTime? rangeEnd;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            height: 580,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      // Üst Handle
                      Container(
                        width: 80, height: 4,
                        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(2)),
                      ),
                      const SizedBox(height: 16),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TableCalendar(
                                firstDay: DateTime(2000, 1, 1),
                                lastDay: DateTime(2100, 12, 31),
                                focusedDay: focusedDay,
                                rangeSelectionMode: RangeSelectionMode.enforced,
                                rangeStartDay: rangeStart,
                                rangeEndDay: rangeEnd,
                                headerStyle: const HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  titleTextStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                                ),
                                calendarStyle: CalendarStyle(
                                  rangeHighlightColor: Constant.baseColor.withOpacity(0.15),
                                  rangeStartDecoration: BoxDecoration(color: Constant.baseColor, shape: BoxShape.circle),
                                  rangeEndDecoration: BoxDecoration(color: Constant.baseColor, shape: BoxShape.circle),
                                  todayDecoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                                ),
                                onRangeSelected: (start, end, focused) {
                                  setModalState(() {
                                    rangeStart = start;
                                    rangeEnd = end;
                                    focusedDay = focused;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.date_range, color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Text(
                                    rangeStart != null
                                        ? "${DateFormat('dd.MM.yyyy').format(rangeStart!)} - ${rangeEnd != null ? DateFormat('dd.MM.yyyy').format(rangeEnd!) : '...'}"
                                        : "Tarix aralığı seçin",
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 20, left: 16, right: 16,
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: (rangeStart != null && rangeEnd != null) ? () {
                        final String startStr = DateFormat('yyyy-MM-dd').format(rangeStart!);
                        final String endStr = DateFormat('yyyy-MM-dd').format(rangeEnd!);
                        print("Modaldan göndərilən: $startStr");
                        Provider.of<NewsProvider>(context, listen: false).updateDates(startStr, endStr);
                        if(currentProvider.statucCode==1){
                          currentProvider.getAllnewsByStreamKeyword(page: 1,append: false,);
                        }else{
                          currentProvider.getAllnewsByTelegram(page: 1,append: false,);
                        }


                        Navigator.pop(context);
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.baseColor,
                        disabledBackgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text(
                        "Təsdiqlə",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
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