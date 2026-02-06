import 'package:flutter/material.dart';
import 'package:media_radar/models/TelegramChannel.dart';
import 'package:media_radar/services/SiteService.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constants/Constant.dart';
import 'package:intl/intl.dart';
import '../../models/New.dart';
import '../Favourites/SelectedİtemforList.dart';

class AdvancedSearchPanel extends StatefulWidget {
  const AdvancedSearchPanel({super.key});

  @override
  State<AdvancedSearchPanel> createState() => _AdvancedSearchPanelState();
}

class _AdvancedSearchPanelState extends State<AdvancedSearchPanel> {
  final TextEditingController _searchController = TextEditingController();
  List<String> group = [];
  List<TelegramChannel> selectedChannels = [];
  List<TelegramChannel> channelNames = [];
  int selectedIndex = 0;
  bool showAddIcon = false;
  DateTimeRange? selectedDateRange;

  // Axtarış nəticələri və vəziyyət idarəsi
  List<News> searchNews = [];
  String errorText = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getChannelNames();
  }

  Future<void> getChannelNames() async {
    try {
      if (selectedIndex == 0) {
        final response = await SiteService.getAllSitesNews();

      } else {
        final response = await SiteService.getAllSitesTelegram();
        setState(() => channelNames = response);
      }
    } catch (e) {
      print("Mənbə yükləmə xətası: $e");
    }
  }

  // --- Axtarış funksiyası ---
  Future<void> _handleSearch() async {
    if (group.isEmpty && selectedChannels.isEmpty && selectedDateRange == null) {
      setState(() => errorText = 'Zəhmət olmasa ən azı bir filtr seçin');
      return;
    }

    setState(() {
      isLoading = true;
      errorText = '';
      searchNews = [];
    });

    try {
      String? start = selectedDateRange != null
          ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)
          : null;
      String? end = selectedDateRange != null
          ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)
          : null;

      List<int> sourceIds = selectedChannels.map((e) => e.id!).toList();

      final results = await SiteService.getNewsFromSearchTelegram(
        keywords: group,
        startTime: start,
        endTime: end,
        sourcesIds: sourceIds,
        page: 1,
      );

      setState(() {
        searchNews = results;
        if (results.isEmpty) errorText = 'Xəbər tapılmadı';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorText = 'Axtarış zamanı xəta baş verdi';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Təkmil Axtarış',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Açar sözlər girişi
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Açar sözləri daxil edin...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    suffixIcon: showAddIcon
                        ? IconButton(
                      icon: const Icon(Icons.add_circle, color: Color(0xFF3F3BA3)),
                      onPressed: () {
                        if (_searchController.text.trim().isNotEmpty) {
                          setState(() {
                            group.add(_searchController.text.trim());
                            _searchController.clear();
                            showAddIcon = false;
                          });
                        }
                      },
                    )
                        : null,
                  ),
                  onChanged: (value) => setState(() => showAddIcon = value.trim().length >= 3),
                ),
                const SizedBox(height: 10),
                Wrap(spacing: 8, children: group.map((tag) => _buildTag(tag)).toList()),

                const SizedBox(height: 20),
                // 2. Mənbə seçimi (Yerli / Telegram)
                Row(
                  children: [
                    Expanded(child: _buildItem(0, "Yerli xəbərlər")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildItem(1, "Telegram")),
                  ],
                ),

                // Telegram kanalları (Yalnız Telegram seçiləndə)
                if (selectedIndex == 1) ...[
                  const SizedBox(height: 20),
                  _buildSectionTitle('Telegram kanalı'),
                  _buildSelectorField(
                    text: selectedChannels.isEmpty ? "Seçim edin" : selectedChannels.map((e) => e.name).join(", "),
                    onTap: () => _showChannelSelector(context),
                  ),
                ],

                const SizedBox(height: 20),
                // 3. Tarix seçimi
                _buildSectionTitle("Tarix aralığı"),
                _buildSelectorField(
                  text: selectedDateRange == null
                      ? "Tarix seçin"
                      : "${DateFormat('dd.MM.yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd.MM.yyyy').format(selectedDateRange!.end)}",
                  icon: Icons.calendar_month,
                  onTap: () => _selectDateRange(context),
                ),

                const SizedBox(height: 30),
                // 4. Axtar Düyməsi
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF23C98D),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: isLoading ? null : _handleSearch,
                    child: isLoading
                        ? const SizedBox(height: 20, width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Axtar",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(),

                // 5. Nəticələr siyahısı
                if (errorText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text(errorText,
                        style: const TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w500))),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: searchNews.length,
                    itemBuilder: (context, index) {
                      return SelectedItemForList(news: searchNews[index]);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
    );
  }

  Widget _buildSelectorField({required String text, required VoidCallback onTap, IconData icon = Icons.keyboard_arrow_down}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14))),
            Icon(icon, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index, String title) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (selectedIndex != index) {
          setState(() {
            selectedIndex = index;
            selectedChannels.clear();
            searchNews = [];
            getChannelNames();
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Constant.baseColor : Colors.transparent, width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Center(
          child: Text(title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                  color: isSelected ? Constant.baseColor : Colors.black87)),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Chip(
      label: Text(text, style: const TextStyle(fontSize: 12)),
      onDeleted: () => setState(() => group.remove(text)),
      deleteIcon: const Icon(Icons.close, size: 14),
      backgroundColor: Constant.keyTextBackColor,
    );
  }

  // --- Dialog və Selectorlar ---

  void _showChannelSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Text(selectedIndex == 0 ? "Xəbər saytlarını seçin" : "Telegram kanallarını seçin",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Divider(),
                  Expanded(
                    child: channelNames.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      itemCount: channelNames.length,
                      itemBuilder: (context, index) {
                        final channel = channelNames[index];
                        final isSelected = selectedChannels.any((e) => e.id == channel.id);
                        return CheckboxListTile(
                          title: Text(channel.name, style: const TextStyle(fontSize: 13)),
                          value: isSelected,
                          activeColor: const Color(0xFF23C98D),
                          onChanged: (val) {
                            setModalState(() {
                              if (val == true) {
                                selectedChannels.add(channel);
                              } else {
                                selectedChannels.removeWhere((e) => e.id == channel.id);
                              }
                            });
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF23C98D),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Hazırdır", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTime? tempStart = selectedDateRange?.start;
    DateTime? tempEnd = selectedDateRange?.end;
    DateTime tempFocused = selectedDateRange?.start ?? DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Tarix aralığını seçin",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TableCalendar(
                      firstDay: DateTime(2000),
                      lastDay: DateTime(2100),
                      focusedDay: tempFocused,
                      rangeStartDay: tempStart,
                      rangeEndDay: tempEnd,
                      rangeSelectionMode: RangeSelectionMode.enforced,
                      rowHeight: 45,
                      headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                      calendarStyle: CalendarStyle(
                        rangeHighlightColor: Constant.baseColor.withOpacity(0.1),
                        rangeStartDecoration: BoxDecoration(color: Constant.baseColor, shape: BoxShape.circle),
                        rangeEndDecoration: BoxDecoration(color: Constant.baseColor, shape: BoxShape.circle),
                        todayDecoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                      ),
                      onRangeSelected: (start, end, focused) {
                        setDialogState(() {
                          tempStart = start;
                          tempEnd = end ?? start;
                          tempFocused = focused;
                        });
                      },
                      onPageChanged: (focused) => tempFocused = focused,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Ləğv et", style: TextStyle(color: Colors.grey)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF23C98D)),
                          onPressed: () {
                            if (tempStart != null) {
                              setState(() {
                                selectedDateRange = DateTimeRange(start: tempStart!, end: tempEnd ?? tempStart!);
                              });
                            }
                            Navigator.pop(context);
                          },
                          child: const Text("Təsdiqlə", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}