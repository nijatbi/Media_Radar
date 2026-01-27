import 'package:flutter/material.dart';
import 'package:media_radar/constants/Constant.dart';
import 'package:provider/provider.dart';
import '../../providers/AuthProvider.dart';
import '../HomePages/AddCreateCategoryAppBar.dart';

class CategoryAndKeyList extends StatefulWidget {
  const CategoryAndKeyList({super.key});

  @override
  State<CategoryAndKeyList> createState() => _CategoryAndKeyListState();
}

class _CategoryAndKeyListState extends State<CategoryAndKeyList> {
  @override
  void initState() {
    super.initState();

    // User məlumatını yükləyirik ekran açıldıqda
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),
          title: const Text(
            'Parametrlər',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                addCategoryAppBar(context);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 15, left: 5),
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kateqoriyalar',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F3BA3),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    final user = authProvider.user;

                    if (user == null || user.streams == null || user.streams!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Kateqoriya mövcud deyil',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: user.streams!.length,
                      itemBuilder: (context, index) {
                        final group = user.streams![index];
                        final isLast = index == user.streams!.length - 1;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                              child: Text(
                                group.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: group.keywords
                                  .map((keyword) => _buildTag(keyword.value))
                                  .toList(),
                            ),
                            if (!isLast) ...[
                              const SizedBox(height: 10),
                              Divider(color: Constant.inputBorderColor, thickness: 1),
                              const SizedBox(height: 10),
                            ],
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Constant.keyTextBackColor,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
    );
  }
}
