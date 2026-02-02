import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_radar/services/NewsService.dart';
import 'package:provider/provider.dart';
import 'package:media_radar/providers/NewsProvider.dart';
import 'package:media_radar/services/SecureStorageService.dart';
import '../../models/New.dart';
import '../../providers/FavouriteProvider.dart';
import '../dailies/NewsItem.dart';

class SelectedItemForList extends StatefulWidget {
  final News? news;
  const SelectedItemForList({this.news, super.key});

  @override
  State<SelectedItemForList> createState() => _SelectedItemForListState();
}

class _SelectedItemForListState extends State<SelectedItemForList> {
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

  String formatDate(String dateStr) {
    if (dateStr.isEmpty || dateStr == "null") return "";
    try {
      DateTime dateTime = DateTime.parse(dateStr.split('.').first);
      return DateFormat('dd MMMM yyyy – HH:mm').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  String domainImageUrl(String img) {
    String cleanDomain = img.replaceAll('https://', '').replaceAll('http://', '');
    return 'https://www.google.com/s2/favicons?domain=$cleanDomain&sz=64';
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    final isTelegram = newsProvider.statucCode != 1;
    final favouriteProvider=Provider.of<FavouriteProvider>(context,listen: true);
    final bool isSavedLocally = favouriteProvider.isItemSaved(widget.news!.id!);
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsItem(
              image: newsProvider.statucCode==1 ? widget.news!.imageUrl : imageUrlNews,
              title: widget.news!.title ,
              id: widget.news!.id!,
              text:  widget.news!.text ,
              channelId: widget.news!.channel_Id,
              isSaved: widget.news!.isSaved,
              date: widget.news!.scrapedAt.toString(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[200],
                child: _buildMainImage(isTelegram),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildChannelAvatar(isTelegram),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.news?.domain ?? '',
                          style: const TextStyle(fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSavedLocally)
                        const Icon(
                          Icons.bookmark,
                          color: Colors.amber,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isTelegram
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
                  const SizedBox(height: 10),
                  Text(
                    formatDate(widget.news?.scrapedAt?.toString() ?? ''),
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
        errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.grey),
      );
    } else {
      return Image.network(
        widget.news?.imageUrl ?? '',
        fit: BoxFit.cover,
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
          width: 20,
          height: 20,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => const Icon(Icons.account_circle, size: 20, color: Colors.grey),
        ),
      );
    }

    return Image.network(
      domainImageUrl(widget.news!.domain.toString()),
      width: 15,
      height: 15,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
            Icons.public,
            size: 15,
            color: Colors.grey
        );
      },
    );
  }
}