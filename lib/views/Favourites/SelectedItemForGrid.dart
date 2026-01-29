import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:media_radar/models/New.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../services/NewsService.dart';
import '../../services/SecureStorageService.dart';
import '../dailies/NewsItem.dart';

class SelectedItemForGrid extends StatefulWidget {
  final News? news;
  const SelectedItemForGrid({this.news, super.key});

  @override
  State<SelectedItemForGrid> createState() => _SelectedItemForGridState();
}

class _SelectedItemForGridState extends State<SelectedItemForGrid> {
  String? _token;
  String? imageUrlNews;
  String? imageUrlCover;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = await SecureStorageService.getToken();
    final imgUrl = await NewsService.buildImageUrl(widget.news?.imageUrl);
    final coverUrl = await NewsService.buildImageUrl(widget.news?.channelImage);

    if (mounted) {
      setState(() {
        _token = token;
        imageUrlNews = imgUrl;
        imageUrlCover = coverUrl;
      });
    }
  }

  Widget _buildMainImage(bool isTelegram) {
    if (isTelegram) {
      if (_token == null || imageUrlNews == null) {
        return const Center(child: CupertinoActivityIndicator());
      }
      return Image.network(
        imageUrlNews!,
        headers: {'Authorization': "Bearer $_token"},
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.grey),
      );
    } else {
      return Image.network(
        widget.news?.imageUrl ?? '',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
  }

  Widget _buildChannelAvatar(bool isTelegram) {
    if (isTelegram && imageUrlCover != null && _token != null) {
      return ClipOval(
        child: Image.network(
          imageUrlCover!,
          headers: {'Authorization': "Bearer $_token"},
          width: 16,
          height: 16,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => const Icon(Icons.account_circle, size: 16, color: Colors.grey),
        ),
      );
    }
    return const Icon(Icons.account_circle, size: 16, color: Colors.grey);
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      DateTime dateTime = DateTime.parse(dateStr.split('.').first);
      return DateFormat('dd.MM.yyyy • HH:mm').format(dateTime);
    } catch (e) {
      return dateStr ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    bool isTelegram = newsProvider.statucCode != 1;

    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsItem(
              image: newsProvider.statucCode==1 ? widget.news!.imageUrl : imageUrlNews,
              title: widget.news!.title ,
              id: widget.news!.id.toString(),
              text:  widget.news!.text ,
              isSaved: widget.news!.isSaved,
              date: widget.news!.scrapedAt.toString(),
            ),
          ),
        );
      },
      child: Hero(
        tag: widget.news!.id!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[200],
                  ),
                  child: _buildMainImage(isTelegram),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildChannelAvatar(isTelegram),
                        const SizedBox(width: 5),
                        Text(
                          widget.news?.domain ?? 'Media',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
                    (context.watch<NewsProvider>().statucCode != 1)
                        ? ((widget.news?.text ?? "").length > 35
                        ? "${widget.news!.text!.substring(0, 35)}..."
                        : (widget.news?.title ?? ""))
                        : (widget.news?.title ?? ""),

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (widget.news?.isSaved ?? false)
                  const Icon(Icons.bookmark, color: Color(0xFFF66F6A), size: 18),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              formatDate(widget.news?.scrapedAt?.toString()),
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}