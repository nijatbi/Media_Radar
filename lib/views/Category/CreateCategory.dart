import 'package:flutter/material.dart';

import '../../constants/Constant.dart';
import '../HomePages/CategoryItem.dart';
class CreateCategoryModal extends StatefulWidget {
  const CreateCategoryModal({super.key});

  @override
  State<CreateCategoryModal> createState() => _CreateCategoryModalState();
}

class _CreateCategoryModalState extends State<CreateCategoryModal> {
  @override
  Widget build(BuildContext context) {
    return (SizedBox());

    void _addCreateCategory(){
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, modalSetState) {
              return Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height-kToolbarHeight,
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

  }
}
