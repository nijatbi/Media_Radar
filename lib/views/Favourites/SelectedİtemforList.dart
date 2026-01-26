import 'package:flutter/material.dart';

class SelectedItemForList extends StatelessWidget {
  const SelectedItemForList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // tam yuxarı hizalama
        children: [
          // Şəkil (Solda)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage('assets/images/Rectangle 299.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Sağ hissə (Text və Icon-lar)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row: Avatar + oxu.az + Bookmark
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/download.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // oxu.az text
                    const Text(
                      'oxu.az',
                      style: TextStyle(fontSize: 10),
                    ),

                    const Spacer(),

                    // Bookmark icon
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.bookmark,
                        size: 20,
                        color: Color(0xFFF66F6A),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6), // Row ilə başlıq arasındakı boşluq

                // Başlıq
                const Text(
                  'Süni intellekt 2030-cu ilə qədər yalnız bir neçə iş yerini əvəzləyə bilməyəcək',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                // Tarix
                Text(
                  '10.08.2025 • 15:47',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
