import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/New.dart';

class SelectedItemForList extends StatelessWidget {
  final News? news;
  const SelectedItemForList({this.news,super.key});
  String formatDate(String dateStr) {
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      String formatted = DateFormat('dd MMMM yyyy – HH:mm').format(dateTime);
      return formatted;
    } catch (e) {
      return dateStr;
    }
  }
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
              image: DecorationImage(
                image: (news?.imageUrl != null && news!.imageUrl!.isNotEmpty && news!.imageUrl != "Null")
                    ? NetworkImage(news!.imageUrl!)
                    : const AssetImage('assets/images/Rectangle 299.png') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
           SizedBox(width: 10),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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


                     Text(
                      '${news!.domain}',
                      style: TextStyle(fontSize: 10),
                    ),

                    const Spacer(),

                    (news?.isSaved ?? false)
                        ? GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.bookmark,
                        size: 20,
                        color: Color(0xFFF66F6A),
                      ),
                    )
                        : const SizedBox.shrink()

                  ],
                ),

                const SizedBox(height: 6),


                 Text(
                  '${news!.title}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),


                Text(
                  '${formatDate(news!.publishedAt.toString())}',
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
