import 'package:flutter/material.dart';
class SelectedItemForList extends StatefulWidget {
  const SelectedItemForList({super.key});

  @override
  State<SelectedItemForList> createState() => _SelectedItemForListState();
}

class _SelectedItemForListState extends State<SelectedItemForList> {
  @override
  Widget build(BuildContext context) {
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
  }
}
