import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:media_radar/models/New.dart';
import 'package:media_radar/providers/FavouriteProvider.dart';
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

  String domainImageUrl(String img) {
    String cleanDomain = img
        .replaceAll('https://', '')
        .replaceAll('http://', '')
        .split('/')
        .first;
    return 'https://www.google.com/s2/favicons?domain=$cleanDomain&sz=64';
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
    final favouriteProvider = Provider.of<FavouriteProvider>(context, listen: true);
    final bool isSavedLocally = favouriteProvider.isItemSaved(widget.news?.id ?? 0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsItem(
              image: newsProvider.statucCode == 1 ? widget.news!.imageUrl : imageUrlNews,
              title: widget.news!.title,
              id: widget.news!.id!,
              text: widget.news!.text,
              channelId: widget.news!.channel_Id,
              isSaved: widget.news!.isSaved,
              date: widget.news!.scrapedAt.toString(),
            ),
          ),
        );
      },
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
              // DƏYİŞİKLİK BURADADIR:
              Positioned(
                bottom: 8,
                left: 8,
                // "right" parametrini sildik ki, tam width tutmasın
                child: Container(
                  constraints: BoxConstraints(
                    // Şəklin enindən çox olmasın deyə maksimum limit qoyuruq (padding çıxmaqla)
                    maxWidth: MediaQuery.of(context).size.width / 2 - 30,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // İçindəki qədər yer tutur
                    children: [
                      _buildChannelAvatar(isTelegram),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          widget.news?.domain ?? 'Media',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                  isTelegram
                      ? ((widget.news?.text ?? "").length > 35
                      ? "${widget.news!.text!.substring(0, 35)}..."
                      : (widget.news?.text ?? ""))
                      : (widget.news?.title ?? ""),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isSavedLocally)
                const Icon(
                  Icons.bookmark,
                  color: Colors.amber,
                  size: 18,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            formatDate(widget.news?.scrapedAt?.toString()),
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMainImage(bool isTelegram) {
    String? finalUrl = isTelegram ? imageUrlNews : widget.news?.imageUrl;

    if (finalUrl == null || finalUrl.trim().isEmpty) {
      return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
    }

    return Image.network(
      finalUrl,
      headers: isTelegram && _token != null ? {'Authorization': "Bearer $_token"} : null,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  Widget _buildChannelAvatar(bool isTelegram) {
    if (isTelegram && imageUrlCover != null && imageUrlCover!.isNotEmpty && _token != null) {
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
    return Image.network(
      domainImageUrl(widget.news?.domain ?? ''),
      width: 14,
      height: 14,
      errorBuilder: (c, e, s) => const Icon(Icons.public, size: 14, color: Colors.grey),
    );
  }
}