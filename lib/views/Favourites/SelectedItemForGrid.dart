import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:media_radar/models/New.dart';
import 'package:intl/intl.dart';

class SelectedItemForGrid extends StatefulWidget {
  final News? news;
  const SelectedItemForGrid({ this.news ,super.key});

  @override
  State<SelectedItemForGrid> createState() => _SelectedItemForGridState();
}

class _SelectedItemForGridState extends State<SelectedItemForGrid> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 120,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(
                "${widget.news!.imageUrl}",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    width: double.infinity,
                    child:  Icon(Icons.broken_image, color: Colors.grey, size: 30),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CupertinoActivityIndicator());
                },
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/download.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                     Text(
                      '${widget.news!.domain}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '${widget.news!.title}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            (widget.news?.isSaved ?? false)
                ? IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
              },
              icon: const Icon(
                Icons.bookmark,
                color: Color(0xFFF66F6A),
                size: 20,
              ),
            )
                : const SizedBox.shrink(),
          ],
        ),

        Text(
          '${formatDate(widget.news!.scrapedAt.toString())}',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
