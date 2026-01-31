import 'package:flutter/material.dart';
import 'package:media_radar/providers/AuthProvider.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:provider/provider.dart';
import '../../constants/Constant.dart';
import 'CategoryItem.dart';

void selectedActiveCategory(BuildContext context) {
  List<int> selectedIds = [];
  bool isInitialized = false;

  final newsProvider = Provider.of<NewsProvider>(context, listen: false);

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, modalSetState) {
          return Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final user = authProvider.user;

              if (!isInitialized && user != null && user.streams != null) {
                selectedIds = user.streams!
                    .where((s) => s.is_active == true)
                    .map((s) => s.id!)
                    .toList();
                isInitialized = true;
              }

              return Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Aktiv kateqoriyalar',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Divider(),

                          Expanded(
                            child: (user == null || user.streams == null || user.streams!.isEmpty)
                                ? const Center(child: Text('Kateqoriya mövcud deyil...'))
                                : ListView.builder(
                              itemCount: user.streams!.length,
                              itemBuilder: (context, index) {
                                final stream = user.streams![index];
                                final bool isSelected = selectedIds.contains(stream.id);

                                return CategoryItem(
                                  id: stream.id!,
                                  name: stream.name,
                                  isChecked: isSelected,
                                  onChanged: (bool? val) {
                                    modalSetState(() {
                                      if (val == true) {
                                        selectedIds.add(stream.id!);
                                      } else {
                                        selectedIds.remove(stream.id!);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),


                    Positioned(
                      bottom: 30,
                      left: 24,
                      right: 24,
                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                            await _handleSync(authProvider, selectedIds, newsProvider);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.baseColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            'Təsdiqlə',
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
    },
  );
}

Future<void> _handleSync(AuthProvider provider, List<int> finalSelectedIds, NewsProvider newsProvider) async {
  List<int> initialActiveIds = provider.user!.streams!
      .where((s) => s.is_active == true)
      .map((s) => s.id!)
      .toList();

  List<int> toActivate = finalSelectedIds
      .where((id) => !initialActiveIds.contains(id))
      .toList();

  List<int> toDeactivate = initialActiveIds
      .where((id) => !finalSelectedIds.contains(id))
      .toList();

  if (toActivate.isNotEmpty) {
    await provider.activeStreamAndGetData(toActivate, newsProvider);
  }

  if (toDeactivate.isNotEmpty) {
    await provider.deActiveStreamAndGetData(toDeactivate, newsProvider);
  }

  await provider.getCurrentUser();
}