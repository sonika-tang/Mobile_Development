import 'package:flutter/material.dart';
import '../view_model/library_item_data.dart';

class LibraryItemTile extends StatelessWidget {
  const LibraryItemTile({
    super.key,
    required this.data,
    required this.isPlaying,
    required this.isLiking,
    required this.onTap,
    required this.onLike,
  });

  final LibraryItemData data;
  final bool isPlaying;
  final bool isLiking;
  final VoidCallback onTap;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data.song.imageUrl.toString()),
          ),
          title: Text(data.song.title),
          subtitle: Row(
            children: [
              Text('${data.song.duration.inMinutes} mins'),
              const SizedBox(width: 12),
              Text(data.artist.name),
              const SizedBox(width: 12),
              Text(data.artist.genre),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPlaying)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text('Playing', style: TextStyle(color: Colors.amber)),
                ),
              // W10-01: Like button
              isLiking
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : GestureDetector(
                      onTap: onLike,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${data.song.likes}',
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
