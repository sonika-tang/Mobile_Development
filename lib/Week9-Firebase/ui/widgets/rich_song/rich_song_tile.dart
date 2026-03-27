import 'package:flutter/material.dart';

import '../../../model/artists/rich_song.dart';
import '../../theme/theme.dart';

class RichSongTile extends StatelessWidget {
  const RichSongTile({
    super.key,
    required this.richSong,
    required this.isPlaying,
    required this.onTap,
  });

  final RichSong richSong;
  final bool isPlaying;
  final VoidCallback onTap;

  String get _duration {
    final m = richSong.duration.inMinutes;
    final s = richSong.duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$m:$s';
  }

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
          leading: CircleAvatar(
            backgroundImage: NetworkImage(richSong.imageUrl.toString()),
          ),
          onTap: onTap,
          title: Text(richSong.title),
          trailing: Text(
            isPlaying ? "Playing" : "",
            style: TextStyle(color: Colors.amber),
          ),
          subtitle: Row(
            children: [
              CircleAvatar(
                radius: 8,
                backgroundImage: NetworkImage(
                  richSong.artistImageUrl.toString(),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${richSong.artistName} · ${richSong.artistGenre} · $_duration',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
